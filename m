Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab2LAWDh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 17:03:37 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:48008 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab2LAWDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 17:03:36 -0500
MIME-Version: 1.0
In-Reply-To: <20121201214438.GA6544@gmail.com>
References: <20121201111609.GA18679@gmail.com> <CA+55aFx_yJbonbEC5AYteyNv+qWbG-H=yj_=YaiJHwKyu4FH3Q@mail.gmail.com>
 <20121201214438.GA6544@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 1 Dec 2012 14:03:14 -0800
X-Google-Sender-Auth: fp6uQP4-PMshDKRGtiZ-k4705r4
Message-ID: <CA+55aFwp7ZNN5s1vhY9M2VwtjCEien=_iVfCeE1khqH4KY7prw@mail.gmail.com>
Subject: Re: [RFC GIT PULL] scheduler fix for autogroups
To: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 1, 2012 at 1:44 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> You are not missing anything. That flag is my fault not Mike's:
> I booted the initial version of that patch but was unsure
> whether autogroups was enabled - it's a pretty transparent
> feature. So I figured that having that flag (but readonly) would
> give us this information definitely.

So what's the advantage of it being read-only at all?

Since the flag is clearly *used*, make it read-write, and then all my
objections go away (except for a slight worry that the dropping of
/proc/<pid>/autogroup_nice or whatever it is could break some odd
system app, but I don't worry *too* much about that).

Disabling autogroup is clearly something people might want, since the
code tests for it. So removing the flag entirely seems wrong too. But
if it exists, it should be writable. No?

             Linus
