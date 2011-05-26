Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab1EZOhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 10:37:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37094 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab1EZOhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 10:37:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=OUGOMY3+aFvzx/n70x30ydk6vyro4O594Q35IfSMJLtLogkxCt4gfzc6HmjVhW5LzB
         VHJ4hRUDzUU38szxYHfPydX3BsF5PnvYB/0Xz9pEzZz6+QTLeNivEnB3gD6ELyh/xtmL
         FtDsiPIIyTi6GQO7BOfhQZ3WYpxZ9uBIl4y6w=
MIME-Version: 1.0
In-Reply-To: <BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com>
References: <1305807728.11267.25.camel@gandalf.stny.rr.com>
	<BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com>
	<BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
	<1306254027.18455.47.camel@twins>
	<20110524195435.GC27634@elte.hu>
	<alpine.LFD.2.02.1105242239230.3078@ionos>
	<20110525150153.GE29179@elte.hu>
	<alpine.LFD.2.02.1105251836030.3078@ionos>
	<20110525180100.GY19633@outflux.net>
	<BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
	<20110525191152.GC19633@outflux.net>
	<BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com>
Date: Thu, 26 May 2011 10:37:12 -0400
X-Google-Sender-Auth: 1mvz3VKQJTnyImqwmWQL36egxGQ
Message-ID: <BANLkTinZYk8YPSxwhuRePo=TdmM45qkgKw@mail.gmail.com>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call filtering
From: Colin Walters <walters@verbum.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <kees.cook@canonical.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Will Drewry <wad@chromium.org>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 4:01 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> As to your example of apache modules - last I saw, most of those were
> written in high-level scripting languages that almost invariably end
> up using quite a bit of the system call interfaces. And more
> importantly, almost nobody does unportable code.

Well, there's a difference between frameworks and applications.  At
least in GNOME e.g. we've been generally good at picking up and
transparently taking advantage of Linux-specific stuff where possible
like splice() in g_file_copy(), and in this cycle I'll probably end up
using signalfd() to fix a long standing race condition.

> So hey, I'm willing to be convinced. But I'll need more than people
> _saying_ that they'd be interested. Because judging by past
> performance, nobody ever uses esoteric cool new features.

I'm curious which features you feel are esoteric and cool but unused?
