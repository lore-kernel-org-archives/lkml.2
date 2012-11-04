Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab2KDREA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 12:04:00 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:52312 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab2KDRD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 12:03:58 -0500
MIME-Version: 1.0
In-Reply-To: <op.wm85dbb76426ze@localhost.localdomain>
References: <loom.20121005T132825-464@post.gmane.org>
	<op.wm85dbb76426ze@localhost.localdomain>
Date: Sun, 4 Nov 2012 17:03:58 +0000
Message-ID: <CAEwFKRCDbxbODSP917ZvNXGYzW2iuipaiD4cFkTuQQvsMeMkeQ@mail.gmail.com>
Subject: Re: The uncatchable jitter, or may the scheduler wars be over?
From: Lukasz Sokol <el.es.cr@gmail.com>
To: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A word of addition,

On Sun, Nov 4, 2012 at 2:04 PM, Uwaysi Bin Kareem
<uwaysi.bin.kareem@paradoxuncreated.com> wrote:
[snip]
>
> Also like I stated elsewhere, since daemons seem to make a difference,
> optimally putting daemons or processes that can, on a low-jitter queue,
> transparent to the user, seems optimal. Unfortunately realtime is not quite
> working as one would expect, causing input to be choked at times, if you
> want to have one main app, and the rest on sched_other, as a low-jitter
> queue. So I am still iterating this.

Hard real time kernel, will make the situation even worse: there the userspace
will get preempted always and no matter what it is doing; RT means here,
the userspace will /get/ the slice, but whether the slice will be enough, no one
can guarantee but whoever wrote the userspace.
It's the userspace that must decide 'do I have enough time to run
another rendering loop within
this time slice (or before vsync is imminent)'.

(As in: real time is not 'as fast as possible' but 'as fast as
specified' and the specification
need to be within reason).

>
[snip]
> Peace Be With You.

Lukasz
