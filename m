Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964980Ab2EXSHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:07:55 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36921 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964927Ab2EXSHx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:07:53 -0400
MIME-Version: 1.0
In-Reply-To: <4FBE5E3C.9070600@zytor.com>
References: <20120522173942.GJ11775@ZenIV.linux.org.uk> <1337875681-20717-1-git-send-email-wad@chromium.org>
 <4FBE5E3C.9070600@zytor.com>
From: Roland McGrath <mcgrathr@google.com>
Date: Thu, 24 May 2012 11:07:31 -0700
Message-ID: <CAB=4xhp3WYoD6RnY+Y=XV18RiCLOeT-dsDmHxAVUYpaSUMpZdA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] move the secure_computing call
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org, indan@nul.nu,
        netdev@parisplace.org, linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de,
        luto@mit.edu, serge.hallyn@canonical.com, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 9:13 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> I think this really screws with using seccomp for self-interception.  I
> wouldn't inherently be opposed to the following flow:
>
>        seccomp -> ptrace -> seccomp
>
> ... i.e. if ptrace is enabled and we enable something, run it through
> seccomp again, but there are bunch of use cases (mostly involving
> SIGSYS) where doing ptrace before seccomp is just bizarre.

Are you sure?  This is ptrace syscall tracing going first.
If seccomp generates a SIGSYS, then ptrace will still get its opportunity
to intercept the signal and change the register state however it likes.


Thanks,
Roland
