Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab2AYXgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 18:36:45 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55290 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab2AYXgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 18:36:42 -0500
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Pedro Alves <palves@redhat.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
Date: Thu, 26 Jan 2012 00:36:35 +0100
User-Agent: KMail/1.8.2
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
        Jamie Lokier <jamie@shareable.org>, Andrew Lutomirski <luto@mit.edu>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com> <20120125193635.GA30311@redhat.com> <4F206420.5080200@redhat.com>
In-Reply-To: <4F206420.5080200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201201260036.35805.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 January 2012 21:20, Pedro Alves wrote:
> On 01/25/2012 07:36 PM, Oleg Nesterov wrote:
> > 
> > Not sure this is really better, but there is another idea. Currently we
> > have PTRACE_O_TRACESYSGOOD to avoid the confusion with the real SIGTRAP.
> > Perhaps we can add PTRACE_O_TRACESYS_VERY_GOOD (or we can look at
> > PT_SEIZED instead) and report TS_COMPAT via ptrace_report_syscall ?
> 
> May I beg to don't rely on PTRACE_SYSCALL for anything new?

This doesn't *add* anything new. All the same ptrace stops will happen
at exactly the same moments. No new stops added. We only add a value
into upper half of waitpid status: (status >> 16) used to be 0
on syscall entry. Now it will be PTRACE_EVENT_SYSCALL_ENTRY[1].
That's all.

> You can't PTRACE_SINGLESTEP and PTRACE_SYSCALL simultaneously.

This is an orthogonal problem.

-- 
vda
