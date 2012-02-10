Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230Ab2BJVTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 16:19:38 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47004 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758959Ab2BJVTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 16:19:36 -0500
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
Date: Fri, 10 Feb 2012 22:19:29 +0100
User-Agent: KMail/1.8.2
Cc: "Jamie Lokier" <jamie@shareable.org>, "Oleg Nesterov" <oleg@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>, "Andrew Lutomirski" <luto@mit.edu>,
        "Will Drewry" <wad@chromium.org>, linux-kernel@vger.kernel.org,
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
        "Roland McGrath" <mcgrathr@chromium.org>
References: <20120210020255.GA8333@jl-vm1.vm.bytemark.co.uk> <281b99af510eb77040272903245f0256.squirrel@webmail.greenhost.nl>
In-Reply-To: <281b99af510eb77040272903245f0256.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201202102219.29423.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 February 2012 04:37, Indan Zupancic wrote:
> > I read somewhere about a bug report where syscall-exit was seen after
> > attach, but I don't remember where now.
> 
> Well, if you attach at a random moment you can get a syscall-exit first,
> I guess. I suppose you have to wait till you get the SIGSTOP notification
> before you can be sure that the next syscall event will be an entry one.

No. After PTRACE_ATTACH, next reported waitpid result will be either
a ptrace-stop of signal-delivery-stop variety,
or death (WIFEXITED/WIFSIGNALED). Syscall exit notification
is not possible (modulo kernel bugs). For one, syscall entry/exit
notifications must be explicitly requested by PTRACE_SYSCALL, which
wasn't yet done!

-- 
vda
