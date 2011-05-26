Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906Ab1EZTGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:06:18 -0400
Received: from mail.lang.hm ([64.81.33.126]:40819 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757630Ab1EZTGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:06:17 -0400
Date: Thu, 26 May 2011 12:05:16 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Will Drewry <wad@chromium.org>, Colin Walters <walters@verbum.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
In-Reply-To: <20110526184723.GA3177@elte.hu>
Message-ID: <alpine.DEB.2.02.1105261204020.4413@asgard.lang.hm>
References: <20110525191152.GC19633@outflux.net> <BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com> <BANLkTinZYk8YPSxwhuRePo=TdmM45qkgKw@mail.gmail.com> <BANLkTi=s09aAqiOzgAJByqZvhQLaCmEErQ@mail.gmail.com> <BANLkTik0Np23G3SjgZw3NYBG5DCFdmH+Rw@mail.gmail.com>
 <BANLkTi=VQEbB1CdS2w03q38d0YSc+_WYgg@mail.gmail.com> <BANLkTimZjwdepwS2mjysRyHytfhd2P7vSA@mail.gmail.com> <BANLkTi=UFB6PLfsSTVpFEQbveMs-W4MjUg@mail.gmail.com> <BANLkTim44ziUsEbYVOjfLPvOLfhUgH9itw@mail.gmail.com> <BANLkTineHBZ-oHRsfc9R6bpcp_oyczL5pA@mail.gmail.com>
 <20110526184723.GA3177@elte.hu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011, Ingo Molnar wrote:

> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> It also gets rid of all configuration - one of the things that
>> makes most security frameworks (look at selinux, but also just
>> ACL's etc) such a crazy rats nest is the whole "set up for other
>> processes". If it's designed very much to be about just the "self"
>> process (after initialization etc), then I think that avoids pretty
>> much all the serious issues.
>
> That's how the event filters work currently: even when inherited they
> get removed when exec-ing a setuid task, so they cannot leak into
> privileged context and cannot modify execution there.
>
> Inheritance works when requested, covering only same-credential child
> tasks, not privileged successors.

this is a very reasonable default, but there should be some way of saying 
that you want the restrictions to carry over to the suid task (I really 
know what I'm doing switch)

David Lang
