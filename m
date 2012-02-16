Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab2BPV3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 16:29:16 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62153 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2BPV3N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 16:29:13 -0500
MIME-Version: 1.0
In-Reply-To: <4F3D7250.6040504@zytor.com>
References: <1329422549-16407-1-git-send-email-wad@chromium.org>
 <1329422549-16407-3-git-send-email-wad@chromium.org> <4F3D61CB.2000301@zytor.com>
 <CABqD9hb3WxKxLZ2GuUrbDM--koW+a3ser5TU8y6+e0sAhOT9dw@mail.gmail.com> <4F3D7250.6040504@zytor.com>
From: Markus Gutschke <markus@chromium.org>
Date: Thu, 16 Feb 2012 13:28:49 -0800
X-Google-Sender-Auth: 5VYwc35XjnR2ouPealOKy0wwjcs
Message-ID: <CAE6n16kweRehdozft0tKOB1P5LtGFJDCLQP=2EXfm8P0enyH=A@mail.gmail.com>
Subject: Re: [PATCH v8 3/8] seccomp: add system call filtering using BPF
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, mingo@redhat.com,
        oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net,
        mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu,
        eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org,
        scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com,
        keescook@chromium.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 13:17, H. Peter Anvin <hpa@zytor.com> wrote:
> The other thing that you really need in addition to system call number is
> ABI identifier, since a syscall number may mean different things for
> different entry points.  For example, on x86-64 system call number 4 is
> write() if called via int $0x80 but stat() if called via syscall64. This is
> a local property of the system call, not a global per process.

I think, the documentation said that as soon as prctl() is used to set
a bpf filter for system calls, it automatically disallows system calls
using an entry point other than the one used by this particular
prctl().

I was trying to come up with scenarios where this particular approach
causes problem, but I can't think of any off the top of my head. So,
it might actually turn out to be a very elegant way to reduce the
attack surface of the kernel. If we are really worried about userspace
compatibility, we could make the kernel send a signal instead of
terminating the program, if the wrong entry point was used; not sure
if that is needed, though.


Markus
