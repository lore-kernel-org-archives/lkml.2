Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458Ab2EUSWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:22:00 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55254 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab2EUSV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:21:58 -0400
MIME-Version: 1.0
Date: Mon, 21 May 2012 14:21:57 -0400
X-Google-Sender-Auth: vBZNph94dajoxKfQwgGo6dho0KQ
Message-ID: <CACLa4puRJLUd6hAHO6zFYiqa5dFVum8eLmNMk_ef+=r8OGhjRg@mail.gmail.com>
Subject: seccomp and ptrace. what is the correct order?
From: Eric Paris <netdev@parisplace.org>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com, hpa@zytor.com, mingo@redhat.com,
        oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net,
        mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu,
        eparis@redhat.com, serge.hallyn@canonical.com, indan@nul.nu,
        pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com,
        keescook@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viro ask me a question today and I didn't have a good answer.

Lets assume I set a seccomp filter that will allow read and will
deny/kill ioctl.  If something else is tracing me I could call read.
The read will pass the seccomp hook and move onto the ptrace hook.
The tracer could then change the syscall number to ioctl and I would
then actually perform an ioctl.

Is that what we want?  Do we want to do the permission check based on
what a process ask at syscall enter or do we want to do the permission
check based on what the kernel is actually going to do on behalf of
the process?

Does the question make sense?

-Eric
