Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab2ALRDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:03:15 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51408 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753401Ab2ALRDL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:03:11 -0500
MIME-Version: 1.0
In-Reply-To: <1326302710-9427-2-git-send-email-wad@chromium.org>
References: <1326302710-9427-1-git-send-email-wad@chromium.org> <1326302710-9427-2-git-send-email-wad@chromium.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 12 Jan 2012 09:02:49 -0800
X-Google-Sender-Auth: oPk2Htx1nQnAdXZTzxjMk2hByn4
Message-ID: <CAObL_7FMuomx-fAKUHA2mHAQrLSOOKF0=4ugkvk2b8rfFXk3EQ@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 9:25 AM, Will Drewry <wad@chromium.org> wrote:
> This patch adds support for seccomp mode 2.  This mode enables dynamic
> enforcement of system call filtering policy in the kernel as specified
> by a userland task.  The policy is expressed in terms of a BPF program,
> as is used for userland-exposed socket filtering.  Instead of network
> data, the BPF program is evaluated over struct user_regs_struct at the
> time of the system call (as retrieved using regviews).
>

There's some seccomp-related code in the vsyscall emulation path in
arch/x86/kernel/vsyscall_64.c.  How should time(), getcpu(), and
gettimeofday() be handled?  If you want filtering to work, there
aren't any real syscall registers to inspect, but they could be
synthesized.

Preventing a malicious task from figuring out approximately what time
it is is basically impossible because of the way that vvars work.  I
don't know how to change that efficiently.

--Andy
