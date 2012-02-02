Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab2BBAd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 19:33:57 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:48577 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab2BBAd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 19:33:56 -0500
Message-ID: <4F29D9C4.6030401@linux.vnet.ibm.com>
Date: Wed, 01 Feb 2012 16:33:08 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] perf: Adding sysfs group format attribute for pmu
 device
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com> <1327674868-10486-1-git-send-email-jolsa@redhat.com> <1327674868-10486-6-git-send-email-jolsa@redhat.com> <4F231256.8080905@linux.vnet.ibm.com> <20120130095223.GB1552@m.brq.redhat.com> <4F289486.2050107@linux.vnet.ibm.com> <1328103384.2760.37.camel@laptop>
In-Reply-To: <1328103384.2760.37.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020200-7408-0000-0000-0000025554EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 05:36 AM, Peter Zijlstra wrote:
> On Tue, 2012-01-31 at 17:25 -0800, Corey Ashford wrote:
>>
>> One other comment that occurs to me is that it would be nice for perf to
>> know when a supplied value is out of range, or will have undefined
>> results.  For example, a field may be 8 bits wide, but not all 8-bit
>> values are legal.  For example, there may be 208 events, and the codes
>> may be somehwhat or even very sparsely encoded.  So, ideally, a config
>> field in sysfs might look like this:
>>
>> config1:0-7:0x0-0xd8,0xdb-0xe2,0xe4-0xe6
>>
>> This way perf could check for valid values before stuffing them into
>> registers, and give a good error message to the user.  If there is no
>> restriction field, it would be assumed all of the possible values are valid.
>>
>> I think the kernel code needs to check for bad values as well, because
>> people can bypass the restrictions exposed by sysfs and use the
>> perf_events API directly. 
> 
> Define bad? The only case where perf cares (from a kernel pov) is when
> it can make the hardware melt and similar things. Programming the PMU in
> a non-nonsensical but non-destructive way is fine, you get what you ask
> for.

The main definition of "bad" would be a known config that has no meaning
(or perhaps is improperly implemented on the chip).  This would just
give the user some extra help that he might have incorrectly configured
the PMU.  Perf could identify down to the specific field that may not be
set correctly.  You could add an override switch to perf (--force-config
etc.) that would allow the user to bypass the check if he really wanted
to use that config.

It's also conceivable that there would be known PMU modes, that let's
say, stores values into a memory buffer (like IBS, etc), that if you use
a particular config, it would overwhelm the memory bus and choke the
processor down.

That said, this feature would just be nice to have, and is only on my
wish list.

Thanks for considering comments,

- Corey

