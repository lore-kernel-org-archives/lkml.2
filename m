Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab2HUBPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 21:15:15 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:40237 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab2HUBPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 21:15:11 -0400
Message-ID: <5032E114.30503@us.ibm.com>
Date: Mon, 20 Aug 2012 18:15:00 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org
Subject: Re: BUG: NULL pointer dereference in shmem_evict_inode()
References: <20120821010403.GA12018@localhost> <5032E021.2030400@linaro.org>
In-Reply-To: <5032E021.2030400@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082101-5518-0000-0000-000006FC2AA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 06:10 PM, John Stultz wrote:
> On 08/20/2012 06:04 PM, Fengguang Wu wrote:
>> Hi John,
>>
>> The below oops happens in v3.5..v3.6-rc2 and it's bisected down to 
>> commit
>> 2a8c0883c ("time: Move xtime_nsec adjustment underflow handling 
>> timekeeping_adjust").
>>
>> However linux-next is working fine. Do you have any fixes not yet 
>> sent to Linus?
> Yea, there's a fix pending in tip/timers/urgent 
> (4e8b14526ca7fb046a81c94002c1c43b6fdf0e9b) to catch crazy values from 
> settimeofday or the cmos clock that might overflow a ktime_t.
>
> Out of curiosity, how are you triggering/reproducing this?
>

Looking at the commit you pointed out, it seems more likely Ingo's fix 
(1d17d17484d40f2d5b35c79518597a2b25296996) might be related, but that 
should have landed in v3.6-rc2.  So I'm not sure.

thanks
-john


