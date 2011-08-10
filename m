Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab1HJT3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 15:29:09 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59254 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab1HJT3I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 15:29:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110810171415.GA2988@redhat.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
 <1311630170-26057-4-git-send-email-jim.cromie@gmail.com> <CAO+b5-rpXrAZ6bAtWiy+rCaWEmRCwzMmNrqsRWQChM9nkdofiw@mail.gmail.com>
 <CAJfuBxzq67UM7i+EmDzdFCWfbEPM2cGad1Ed4cfCP5+v2QVgwg@mail.gmail.com>
 <CAO+b5-qoMiuOSga_fnzMfKsGDDkBAY7oLoJK1xk+XvvbT21OwQ@mail.gmail.com>
 <20110728182427.GD2659@redhat.com> <CAJfuBxwS0rQG=REt9wwYde7d=j1a4z1JdV3fiJ2UexHychCbcw@mail.gmail.com>
 <20110803182709.GA2462@redhat.com> <CAJfuBxyPtxxCvA4LBx8J+6ADgj1ah4nroM30uYS880pJN+eGxA@mail.gmail.com>
 <20110810171415.GA2988@redhat.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Wed, 10 Aug 2011 13:28:36 -0600
Message-ID: <CAJfuBxwO143EiZKVcgEefs0izjoXoXOSFnob+aBDiaVw2wyyQA@mail.gmail.com>
Subject: Re: [PATCH 03/25] dynamic_debug: use pr_debug instead of pr_info
To: Jason Baron <jbaron@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 11:14 AM, Jason Baron <jbaron@redhat.com> wrote:

trimmed

>>
>> alright, I can live with that, but Id like to note the loss of selectivity
>> in the verbose-only approach before capitulating:
>>
>> the pr_info()s in _proc_ routines are quite noisy when enabled.
>>
>> in my current config, which has 537 callsites,
>> enabling all those pr_debug()s unselectively, ie:
>>
>> Kernel command line: ... ddebug_query="module dynamic_debug +pflt; "
>> loglevel=8 dynamic_debug.verbose=1
>>
>> and doing : ~# cat /dbg/dynamic_debug/control
>> logs 836 lines like
>> [2573] ddebug_proc_next:866: called m=c6f99a40 p=c88955d0 *pos=427
>> [2573] ddebug_proc_show:888: called m=c6f99a40 p=c88955e8
>>
>> Not completely overwhelming perhaps, but nice to silence.
>>
>> Before switching to pr_debug, I had changed those proc pr_infos to:
>> if (verbose >= 10)
>>     pr_info(...)
>>
>> that quiets things nicely, and is knowable via modinfo,
>> is that addition acceptable ?
>>
>
> why do you have '10' here, isn't it just, if (verbose) ?

Because the ddebug_proc_show and ddebug_proc_next routines
are called a lot (~500 times each on my build) when looking at control file.
For my needs, there wasnt much info in them..

As to the number, I wanted to leave space for other increments
of verbosity, and I couldnt resist an homage to Spinal Tap:
    This verbosity goes to eleven !

If you'd prefer, I can switch to a flags/mask approach,
or drop back to pure boolean.


>
>> BTW, are you aiming for tip tree ?
>
> The dynamic debug patches have been going in via Greg KH's device
> tree. Now that the merge window has closed, I going to re-send the patch
> series that I had pending. You can then send your series on top of that,
> if you'd like.
>

Sure, that works.  Ill watch for it.
Mine is 'ready' subject to changes in your series, and pushback.

> Thanks,
>
> -Jason
>
