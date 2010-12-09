Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab0LISls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:41:48 -0500
Received: from mail.windriver.com ([147.11.1.11]:41199 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0LISlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:41:47 -0500
Message-ID: <4D0122E2.6000109@windriver.com>
Date: Thu, 09 Dec 2010 12:41:38 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Tal Lubko <tallubko@yahoo.com>
CC: linux-kernel@vger.kernel.org,
        KGDB Mailing List <kgdb-bugreport@lists.sourceforge.net>
Subject: Re: kgdb issues in 2.6.26.5-rt9
References: <270554.37369.qm@web53305.mail.re2.yahoo.com>
In-Reply-To: <270554.37369.qm@web53305.mail.re2.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Dec 2010 18:41:39.0402 (UTC) FILETIME=[B7464AA0:01CB97D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2010 02:04 AM, Tal Lubko wrote:
> Hello all,
>
> I am running a custom 2.6.26.5-rt9 kernel which is the 2.6.26.5 vanilla kernel 
> with version 9 of the real time patch for that specific version. I am trying to 
> debug a "hard" problem which means not a problem which is easily reproducibe, 
> appears only on boot, only under certain conditions etc. In order to debug the 
> problem I am using kgdb.
>
> Before anyone flames me, I am aware that kgdb is not the highway as far as 
> kernel debugging is concerned, but due to certain external factors I am 
> interested in making that approach work.
>
> My understanding of the kgdb status (please correct me if I am wrong on any of 
> the following...):
> - kgdb is supported in 2.6.26.5 vanilla and the important stuff works.
> - the version of kgdb in 2.6.26.5 is the "light" version by Ingo, Thomas and 
> Jason which means that some features are missing.
> - I am not aware of any limitations of the host side gdb that I am supposed to 
> use in order to debug the target (I tried using 6.6 and 6.8)
>
> The problems I have with kgdb:
> - info threads shows most of the threads on the system but then hangs for a 
> short time with various data errors. As a first stab this seems like a protocol 
> issue between host and target.
>   

It depends.  The only way to know for sure is to do something like
following command before issuing your commands in gdb.

set debug remote 1

That will at least tell you were things started "hang".

> - thread [tid] does not work. It claims that the thread ids that I use do not 
> exist although the info that I do manage to get out of "info threads" admits 
> that they do. ps(1) on the target also confirms the thread id numbers.
>   

In gdb the thread command only works if you could obtain the thread
list.  If you know the thread struct address of some process you are
interested in, it may be easier to just reference it in the debugger.  
The debugger is a tool that you can use as a helper and it is not good
at "every scenario" under the sun especially if you are concerned at all
about speed or determinism.   You would be better served to be looking
at tracing tools if that is the case.

> - I haven't managed to set breakpoints. For instance: breaking on printk using 
> "break printk" results in a segv of the debugger (huh?!?). This looks like a gdb 
>
>   

Perhaps the documentation sheds some light in later releases of kgdb
(and the kernel for that matter).   My guess is that you need to turn
off the kernel option CONFIG_DEBUG_RODATA.  There was no safety check
for this in 2.6.26.  A great number of other problems have been solved
over time as well with HW breakpoints and SMP robustness.

Best of luck debugging.  :-)

Cheers,
Jason.
