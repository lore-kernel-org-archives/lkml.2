Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab2JHLXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 07:23:39 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44616 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab2JHLXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 07:23:37 -0400
Message-ID: <5072B7B0.7050507@gmail.com>
Date: Mon, 08 Oct 2012 19:23:28 +0800
From: Charles Wang <0oo0.hust@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Huacai Chen <chenhc@lemote.com>, Charles Wang <muming.wq@taobao.com>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Seems like "sched: Add missing call to calc_load_exit_idle()"
 should be reverted in 3.5 branch
References: <CAAhV-H54CJdg+UekpucZ=kOgCY5r5vvYQ+v4VwAMTCv+mCedXA@mail.gmail.com> <20121004174626.GB14301@kroah.com> <1349375519.14388.16.camel@twins> <CAFzf2XxYab=MUdffjR7VtftW=Xv45KQFbd3YSn2ogJpUWf+wqA@mail.gmail.com>
In-Reply-To: <CAFzf2XxYab=MUdffjR7VtftW=Xv45KQFbd3YSn2ogJpUWf+wqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2012 09:39 AM, Jonathan Nieder wrote:
> Peter Zijlstra wrote:
>
>> I can't find wtf went wrong either, the initial patch 5167e8d5417bf5c
>> contains both hunks, but in that case the fixup 749c8814f0 doesn't make
>> sense, not can I find anything in merge commits using:
>>
>>    git log -S calc_load_exit_idle kernel/time/tick-sched.c
>
>   git log -m -p --first-parent -Scalc_load_exit_idle -- kernel/time/tick-sched.c
>
> finds 3992c0321258 ("Merge branch 'timers-core-for-linus'",
> 2012-07-22), which seems to have mismerged 2ac0d98fd624 ("nohz: Make
> nohz API agnostic against idle ticks cputime accounting").
That's it.  Patch 2ac0d98fd624 and 19f5f7364("nohz: Separate idle 
sleeping time accounting from nohz logic") are produced on 2011-07-28, 
merged on 2012-07-22, right after 5167e8d5417bf5c, but applied before 
5167e8d5417bf5c.
These two patches changed tick_nohz_idle_exit, which causing Peter's 
patch 5167e8d5417bf5c couldn't fully be applied.
There should be conflict being reported, but why we don't get is really 
confused.
>
> Thanks,
> Jonathan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

