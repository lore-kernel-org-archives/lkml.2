Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab2BPU2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 15:28:50 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33891 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab2BPU2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 15:28:48 -0500
MIME-Version: 1.0
In-Reply-To: <CAE6n16mCrJC=Sre+PT1H_VfSjW0MGyi0xtEcdcRvGMvvwXWzmA@mail.gmail.com>
References: <1329422549-16407-1-git-send-email-wad@chromium.org>
 <1329422549-16407-5-git-send-email-wad@chromium.org> <CAE6n16mCrJC=Sre+PT1H_VfSjW0MGyi0xtEcdcRvGMvvwXWzmA@mail.gmail.com>
From: Markus Gutschke <markus@chromium.org>
Date: Thu, 16 Feb 2012 12:28:25 -0800
X-Google-Sender-Auth: x15HOJCeMkhEKG69_0TWWeOza5k
Message-ID: <CAE6n16nUB8eg18YHdYbSUqtZ_WJduk4B_dYqyYy37K+6di6yVw@mail.gmail.com>
Subject: Re: [PATCH v8 5/8] seccomp: Add SECCOMP_RET_TRAP
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.org,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, keescook@chromium.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 12:02, Will Drewry <wad@chromium.org> wrote:
> Adds a new return value to seccomp filters that triggers a SIGTRAP to be delivered with the new TRAP_SECCOMP si_code.
>
> This allows in-process system call emulation -- including just specifying an errno or cleanly dumping core -- rather than just dying.

SIGTRAP might not be the ideal choice of signal number, as it can make
it very difficult to debug the program in gdb. Other than that, I love
this feature. It'll significantly simplify the code that we have in
Chrome.


Markus
