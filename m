Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab1EZRHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:07:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63731 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757825Ab1EZRHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:07:19 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=zw1CKeOhDhoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=hK-pZKct-4YsXGPFf8kA:9 a=ZyUfxaRzCUF3CiHrBQsA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system
 call filtering
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Drewry <wad@chromium.org>, Colin Walters <walters@verbum.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>
In-Reply-To: <BANLkTi=VQEbB1CdS2w03q38d0YSc+_WYgg@mail.gmail.com>
References: <1305807728.11267.25.camel@gandalf.stny.rr.com>
	 <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com>
	 <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
	 <1306254027.18455.47.camel@twins> <20110524195435.GC27634@elte.hu>
	 <alpine.LFD.2.02.1105242239230.3078@ionos> <20110525150153.GE29179@elte.hu>
	 <alpine.LFD.2.02.1105251836030.3078@ionos>
	 <20110525180100.GY19633@outflux.net>
	 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
	 <20110525191152.GC19633@outflux.net>
	 <BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com>
	 <BANLkTinZYk8YPSxwhuRePo=TdmM45qkgKw@mail.gmail.com>
	 <BANLkTi=s09aAqiOzgAJByqZvhQLaCmEErQ@mail.gmail.com>
	 <BANLkTik0Np23G3SjgZw3NYBG5DCFdmH+Rw@mail.gmail.com>
	 <BANLkTi=VQEbB1CdS2w03q38d0YSc+_WYgg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 26 May 2011 13:07:16 -0400
Message-ID: <1306429636.3857.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 09:46 -0700, Linus Torvalds wrote:

> And if you filter system calls, it's entirely possible that you can
> attack suid executables through such a vector. Your "limit system
> calls for security" security suddenly turned into "avoid the system
> call that made things secure"!
> 
> See what I'm saying?

So you are not complaining about this implementation, but the use of
syscall filtering?

There may be some user that says, "oh I don't want my other apps to be
able to call setuid" thinking it will secure their application even
more. But because that application did the brain dead thing to not check
the return code of setuid, and it just happened to be running
privileged, it then execs off another application that can root the box.

Because, originally that setuid would have succeeded if the user did
nothing special, but now with this filtering, and the user thinking that
they could limit their app from doing harm, they just opened up a hole
that caused their app to do the exact opposite and give the exec'd app
full root privileges.

Did I get this right?

-- Steve


