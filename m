Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab2JEMEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 08:04:43 -0400
Received: from plane.gmane.org ([80.91.229.3]:59450 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193Ab2JEMEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 08:04:41 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el es <el.es.cr@gmail.com>
Subject: The uncatchable jitter, or may the scheduler wars be over?
Date: Fri, 5 Oct 2012 12:04:29 +0000 (UTC)
Message-ID: <loom.20121005T132825-464@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 86.171.78.167 (Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20100101 Firefox/15.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

first of all, the posts that inspired me to write this up,
were from Uwaysi Bin Kareem (paradoxuncreated dot com).

Here is what I think:
could the source of graphic/video jitter as most people 
perceive it, be something that could be technically defined 
as 'graphic buffer underrun', caused by the scheduler 
unable to align the deadline for some userspace programs
that are crucial to video/opengl output v-refresh, that 
being really HARD RT ? As in, say the scheduler could 
sometimes decide to preempt the userspace in the middle of
OpenGL/fb call [pretty easy to imagine this : userspace that
often blocks on calls to the video hardware, or has a
usespace thread that does that, and is unable to finish
some opengl pipeline calls before end of its slice, or
in case of misalignment, can execute enough commands to
create one (or several) frame(s), and then is cut in the 
middle of creating another one and has to wait for its 
turn again, and in the mean time, vsync/video buffer swap 
occurs, and that last frame is lost/discarded/created with
time settings from previous slice which are wrong]

Bearing in mind, that the most length the video/fb/opengl
buffer can have, is probably 3 (triple buffering as in 
some game settings), as opposed to (at least some) 
sound hw which can have buffers several ms long,
it's not hard to imagine what happens if userspace cannot
make it in time to update the buffer, causing 'underruns'.

This would also explain why it doesn't matter to 'server'
people - they don't have RT video hw/buffers they care for...
(but they tune the below for max throughput instead)

But whether it is measurable or not - I don't know.

The OP (Uwaysi) has been fiddling with HZ value and the
averaging period of the scheduler (which he called 'filter')
(and granularity too). He's had some interesting results IMO.

Hope the above makes sense and not much gibberish :)

Lukasz

