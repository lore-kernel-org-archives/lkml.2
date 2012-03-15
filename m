Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161726Ab2COXdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 19:33:49 -0400
Received: from cpanel23.proisp.no ([88.87.44.74]:56736 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161312Ab2COXdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 19:33:44 -0400
Message-ID: <4F627C4A.3090903@numascale.com>
Date: Fri, 16 Mar 2012 00:33:30 +0100
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] Use x2apic_supported() in the default_apic_id_valid()
 function.
References: <CAE9FiQXC7T7JQRfiry8nHaRYN3ggy9vfzc2jDUzar80hv6pEvw@mail.gmail.com>   <1331834583-16070-1-git-send-email-sp@numascale.com>   <CAE9FiQUh-kEcLLAZYiy90UJY8-WmXTKhYrjS7HQ40U+Ah2dwNg@mail.gmail.com>  <1331846504.16101.12.camel@sbsiddha-desk.sc.intel.com>  <4F626E6C.5010809@numascale.com> <1331852692.16101.30.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1331852692.16101.30.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/2012 00:04, Suresh Siddha wrote:
> On Thu, 2012-03-15 at 23:34 +0100, Steffen Persvold wrote:
>> Is my understanding of your suggestion correct that in
>> x2apic_phys/cluster.c we add the following apic_id_valid() function :
>>
>> static int x2apic_apic_id_valid(int apicid)
>> {
>>    	return x2apic_mode || (apicid<  255);
>> }
>
> Steffen, We can have something like:
>
> static int x2apic_apic_id_valid(int apicid)
> {
>     	return 1;
> }
>
> and
>
> static int xapic_apic_id_valid(int apicid)
> {
>     	return apicid<  255;
> }
>
> If we have selected x2apic driver, then we know we are already in x2apic
> mode. And also x2apic_uv_x need to use the x2apic version above.
>

If you specify "nox2apic" option, will it choose the xapic driver 
instead (and early enough) ? Otherwise I think we might break Yinghai's 
commit (a35fd28256e7736cc84af8931a16224f0bfaaf6c).

Cheers,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold
