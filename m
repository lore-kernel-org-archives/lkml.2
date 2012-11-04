Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2KDOET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 09:04:19 -0500
Received: from smtp.getmail.no ([84.208.15.66]:65129 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412Ab2KDOEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 09:04:16 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: linux-kernel@vger.kernel.org, el es <el.es.cr@gmail.com>
Subject: Re: The uncatchable jitter, or may the scheduler wars be over?
References: <loom.20121005T132825-464@post.gmane.org>
Date: Sun, 04 Nov 2012 15:04:13 +0100
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wm85dbb76426ze@localhost.localdomain>
In-reply-to: <loom.20121005T132825-464@post.gmane.org>
User-Agent: Opera Mail/12.02 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Oct 2012 14:04:29 +0200, el es <el.es.cr@gmail.com> wrote:

> Hello,
>
> first of all, the posts that inspired me to write this up,
> were from Uwaysi Bin Kareem (paradoxuncreated dot com).
>
> Here is what I think:
> could the source of graphic/video jitter as most people
> perceive it, be something that could be technically defined
> as 'graphic buffer underrun', caused by the scheduler
> unable to align the deadline for some userspace programs
> that are crucial to video/opengl output v-refresh, that
> being really HARD RT ? As in, say the scheduler could
> sometimes decide to preempt the userspace in the middle of
> OpenGL/fb call [pretty easy to imagine this : userspace that
> often blocks on calls to the video hardware, or has a
> usespace thread that does that, and is unable to finish
> some opengl pipeline calls before end of its slice, or
> in case of misalignment, can execute enough commands to
> create one (or several) frame(s), and then is cut in the
> middle of creating another one and has to wait for its
> turn again, and in the mean time, vsync/video buffer swap
> occurs, and that last frame is lost/discarded/created with
> time settings from previous slice which are wrong]
>
> Bearing in mind, that the most length the video/fb/opengl
> buffer can have, is probably 3 (triple buffering as in
> some game settings), as opposed to (at least some)
> sound hw which can have buffers several ms long,
> it's not hard to imagine what happens if userspace cannot
> make it in time to update the buffer, causing 'underruns'.
>
> This would also explain why it doesn't matter to 'server'
> people - they don't have RT video hw/buffers they care for...
> (but they tune the below for max throughput instead)
>
> But whether it is measurable or not - I don't know.
>
> The OP (Uwaysi) has been fiddling with HZ value and the
> averaging period of the scheduler (which he called 'filter')
> (and granularity too). He's had some interesting results IMO.
>
> Hope the above makes sense and not much gibberish :)
>
> Lukasz
>

I have now tried both CFS and BFS.Doom 3 is now running with very low  
jitter on both. Both need a 90hz timer, no highres timer, and a  
granularity/interval suited for "natural" (psychovisual profile).
I also compiled them with some optimizations, and options for low jitter.
(KBUILD_CFLAGS	+= -O3 -fno-defer-pop --param prefetch-latency=200)
With Vsync on in doom3, it runs very smooth. Vsync off, BFS has less  
jitter than CFS.
Doom 3 does 3 passes to opengl, and therefore seems more jitter-sensitive,  
so getting it to run well, means minimizing jitter.
Compatibility layers, like Wine adds complexity though, and I have HL2  
running in an intensely tweaked XP install, perfectly (without jitter).  
With wine and BFS, it runs as good, but with some major one second  
jitters. With CFS, some more smaller jitters / higher average jitter. But  
the major jitters are of less lenght. Videojitter on youtube, seems less  
with CFS aswell.

So for "scheduler wars" indeed, identifying those jitters, and getting the  
best of both, is optimal.

This with "low-latency desktop" preemption.

I have yet to get the realtime patch/threadirqs working, however within  
the month I will have a new e5 computer, which probably will be a whole  
lot more fun to test that on.

Also like I stated elsewhere, since daemons seem to make a difference,  
optimally putting daemons or processes that can, on a low-jitter queue,  
transparent to the user, seems optimal. Unfortunately realtime is not  
quite working as one would expect, causing input to be choked at times, if  
you want to have one main app, and the rest on sched_other, as a  
low-jitter queue. So I am still iterating this.

Reducing jitter, seems to generally improve the computing experience,  
setting also higher expectations to quality. Also a machine with jitter  
ofcourse, behaves like a lower-end computer. So reducing jitter, seems to  
be central to an enjoyable computing experience. This all without  
unreasonable effort ofcourse.

Peace Be With You.
