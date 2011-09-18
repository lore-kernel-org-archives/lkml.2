Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab1IRTMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 15:12:10 -0400
Received: from mx2.parallels.com ([64.131.90.16]:49211 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573Ab1IRTMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 15:12:08 -0400
Message-ID: <4E764259.5070209@parallels.com>
Date: Sun, 18 Sep 2011 16:11:21 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <ebiederm@xmission.com>, <davem@davemloft.net>, <gthelen@google.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH v2 1/7] Basic kernel memory functionality for the Memory
 Controller
References: <1316051175-17780-1-git-send-email-glommer@parallels.com> <1316051175-17780-2-git-send-email-glommer@parallels.com> <20110917174535.GA1658@shutemov.name> <4E7567E0.9010401@parallels.com> <20110918190509.GC28057@shutemov.name>
In-Reply-To: <20110918190509.GC28057@shutemov.name>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.106.51.14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2011 04:05 PM, Kirill A. Shutemov wrote:
> On Sun, Sep 18, 2011 at 12:39:12AM -0300, Glauber Costa wrote:
>>> No kernel memory accounting for root cgroup, right?
>> Not sure. Maybe kernel memory accounting is useful even for root cgroup.
>> Same as normal memory accounting... what we want to avoid is kernel
>> memory limits. OTOH, if we are not limiting it anyway, accounting it is
>> just useless overhead... Even the statistics can then be gathered
>> through all
>> the proc files that show slab usage, I guess?
>
> It's better to leave root cgroup without accounting. At least for now.
> We can add it later if needed.

Fair.

>>>
>>>> @@ -3979,6 +3999,10 @@ static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
>>>>    		else
>>>>    			val = res_counter_read_u64(&mem->memsw, name);
>>>>    		break;
>>>> +	case _KMEM:
>>>> +		val = res_counter_read_u64(&mem->kmem, name);
>>>> +		break;
>>>> +
>>>
>>> Always zero in root cgroup?
>>
>> Yes, if we're not accounting, it should be zero. WARN_ON, maybe?
>
> -ENOSYS?
>
I'd personally prefer WARN_ON. It is good symmetry from userspace PoV to 
always be able to get a value out of it. Also, it something goes wrong 
and it is not zero for some reason, this will help us find it.

