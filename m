Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab0LVKz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 05:55:58 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:54750 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab0LVKz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 05:55:57 -0500
X-Authority-Analysis: v=1.1 cv=Inhw+Jdt7z1D3BivGPfn2aw54OvUEJw5lAn/booRZkE= c=1 sm=0 a=45vASgi77HYA:10 a=8nJEP1OIZ-IA:10 a=uMtljfmLDVLoqQOk5K3MRw==:17 a=yvcETbOcCbnVw1fe4qUA:9 a=wv69TibhTzCn9f8crgCaBlz-0FQA:4 a=wPNLvfGTeEIA:10 a=uMtljfmLDVLoqQOk5K3MRw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 68.204.193.27
Message-ID: <4D11D939.9080808@cfl.rr.com>
Date: Wed, 22 Dec 2010 05:55:53 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michael Tokarev <mjt@tls.msk.ru>,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: VERY slow scrolling on radeon graphics card: debugging a timing
 issue?
References: <4D0FC36D.9010304@msgid.tls.msk.ru> <20101222020041.c168bf87.akpm@linux-foundation.org>
In-Reply-To: <20101222020041.c168bf87.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2010 05:00 AM, Andrew Morton wrote:
> (cc dri-devel)
>
> On Mon, 20 Dec 2010 23:58:21 +0300 Michael Tokarev <mjt@tls.msk.ru> wrote:
>
>   
>> Hello.
>>
>> A weird problem here, and I'm looking for help in
>> an attempt to solve it.
>>
>> Ever since KMS went into kernel and I tried turning
>> it on, the scrolling speed on the resulting "text"
>> console (with kms it works in one of graphics modes
>> hence "text" in quotes) become really _awful_.
>>
>> For example, running `dmesg' (which has ~2000 lines)
>> on the console takes about 2.5 _minutes_ (!) to
>> complete, -- which means the speed is about 10 lines
>> per second.  On an old notebook I have, with some also
>> nvidia card, the same operation completes in about
>> 0.8 sec.
>>
>> The lines goes up in a slow motion, I can watch every
>> new line appearing and scrolling.
>>
>> It was this way for a long time, and I almost gave up --
>> in X everything works ok, and in order to speed up
>> booting again I just added "quiet" option to the kernel
>> command line, to avoid scrolling of kernel messages.
>>
>> But yesterday I noticed something else entirely, which
>> make me hope the problem actually _can_ be solved.
>>
>> The thing is: that same scrolling becomes much faster
>> when I "do something" else while it scrolls up.  First
>> I noticed this when I wanted to switch to another vt
>> while it were scrolling -- I held down Ctrl key on my
>> keyboard, and out of the sudden the scroll speed up
>> dramatically.
>>
>> It turned out I can speed the thing to about 10 times
>> by generating some load: hit and hold a key on the
>> keyboard (generates interrupts?), run kernel compile
>> in the background (generates disk interrupts?), move
>> mouse...
>>
>> While doing "something", the same scrolling completes
>> in about 8 seconds instead of 2m30s.  Dramatic improvement.
>>
>> Now, when I hold a key or move mouse, the scrolling
>> is "jumpy" - sometimes it slows down back to original
>> "slow" form for a bit, and sometimes it jumps a few
>> lines in one go.
>>
>> I tried to disable cpufreq (selecting "performance"
>> governor) - this changes exactly nothing.
>>
>> Next someone suggested the "perf" tool.  And this one
>> is even more interesting: while `perf top' is running
>> (on another console or X), the scrolling is.. fast
>> again, as if I were moving my mouse!  Once I stop
>> `perf top', it becomes slow again.  So the bug
>> disappears while you watch it.
>>
>> And there I'm stuck again.  I asked in #radeon, but
>> there, Alex Deucher told me that he has no clue and
>> that the behavour is weird (it is weird indeed).
>>
>> Any hints on where to go from there are apprecated.
>>
>> The hardware is an AMD780g-based motherboard with
>> and Athlon CPU, I've seen the same behavour from
>> many other similar boards.  Kernels - all up to
>> the current 2.6.36.2, sine the old days when kms
>> for radeon first appeared in staging.
>>
>> I know kms/fbcon scrolling is slow on radeon because
>> it uses completely unoptimized bitblt routines (even
>> when the hw is pretty much capable of doing all that
>> stuff internally).  But what I see here is something
>> different - the 8 sec to scroll 2000 lines is the
>> result from the un-optimal bitblt, not the 2m30s.
>>     
>

I also see this very problem on several machines I have with radeon video.
For me the worst part is using vi in a konsole. Moving the cursor around
is so slow that I just can't use these machines directly and have to ssh
into them from another machine just to work on them.

I know its probably not proper to mention it, but when I run the ATI
proprietary
driver, that problem does go away. But for other reasons I can't use it.

Regards
Mark
