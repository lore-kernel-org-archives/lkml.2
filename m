Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3AGRc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 12:32:26 -0500
Received: from service87.mimecast.com ([91.220.42.44]:37906 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab3AGRcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 12:32:25 -0500
Message-ID: <50EB06A4.7030908@arm.com>
Date: Mon, 07 Jan 2013 17:32:20 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Pawel Moll <Pawel.Moll@arm.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Tim (Xen.org)" <tim@xen.org>, Ian Campbell <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 21/24] arm/v2m: initialize arch_timers even if v2m_timer
 is not present
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>  <1347621207-11294-21-git-send-email-stefano.stabellini@eu.citrix.com> <1347625628.2497.65.camel@hornet> <alpine.DEB.2.02.1209141347250.29232@kaball.uk.xensource.com> <alpine.DEB.2.02.1301071719180.4981@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1301071719180.4981@kaball.uk.xensource.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 07 Jan 2013 17:32:21.0752 (UTC) FILETIME=[F3113F80:01CDECFC]
X-MC-Unique: 113010717322303101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/13 17:21, Stefano Stabellini wrote:
> On Fri, 14 Sep 2012, Stefano Stabellini wrote:
>> On Fri, 14 Sep 2012, Pawel Moll wrote:
>>> On Fri, 2012-09-14 at 12:13 +0100, Stefano Stabellini wrote:
>>>> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>>>> CC: Russell King <linux@arm.linux.org.uk>
>>>> CC: Pawel Moll <pawel.moll@arm.com>
>>>> CC: Marc Zyngier <marc.zyngier@arm.com>
>>>> ---
>>>>  arch/arm/mach-vexpress/v2m.c |   11 ++++++-----
>>>>  1 files changed, 6 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
>>>> index 37608f2..4e567f7 100644
>>>> --- a/arch/arm/mach-vexpress/v2m.c
>>>> +++ b/arch/arm/mach-vexpress/v2m.c
>>>> @@ -621,16 +621,17 @@ static void __init v2m_dt_timer_init(void)
>>>>  
>>>>  	v2m_clk_init();
>>>>  
>>>> -	err = of_property_read_string(of_aliases, "arm,v2m_timer", &path);
>>>> -	if (WARN_ON(err))
>>>> -		return;
>>>> -	node = of_find_node_by_path(path);
>>>> -	v2m_sp804_init(of_iomap(node, 0), irq_of_parse_and_map(node, 0));
>>>>  	if (arch_timer_of_register() != 0)
>>>>  		twd_local_timer_of_register();
>>>>  
>>>>  	if (arch_timer_sched_clock_init() != 0)
>>>>  		versatile_sched_clock_init(v2m_sysreg_base + V2M_SYS_24MHZ, 24000000);
>>>> +
>>>> +	err = of_property_read_string(of_aliases, "arm,v2m_timer", &path);
>>>> +	if (WARN_ON(err))
>>>> +		return;
>>>> +	node = of_find_node_by_path(path);
>>>> +	v2m_sp804_init(of_iomap(node, 0), irq_of_parse_and_map(node, 0));
>>>>  }
>>>>  
>>>>  static struct sys_timer v2m_dt_timer = {
>>>
>>> Fair point. The alias is going to disappear anyway (I'm working on a VE
>>> platform rework right now), but in case I won't get it on time for 3.7,
>>> I'll make sure this one is merged instead.
>>
>> Great, thanks!
>> Should I leave this patch out of the Xen on ARM series for 3.7 then?
>>
> 
> I have just noticed that this patch hasn't been merged yet, but still we
> need it to boot Linux on Xen.
> Do you want me to rebase and resent?

I'm looking at v3.8-rc2, and the code have changed significantly (see
433683a66401adb0150792e725cc4f631c94de46).

If you don't have an "arm,sp804" device in your DT, it shouldn't get
registered and carry on registering the per-cpu timers. Can you check
that it fixes your issue?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

