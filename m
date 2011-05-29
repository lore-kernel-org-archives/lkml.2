Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab1E2Ojx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 10:39:53 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:58993 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532Ab1E2Ojw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 10:39:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <19938.23219.306163.24059@pilspetsen.it.uu.se>
Date: Sun, 29 May 2011 16:39:47 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Lutomirski <luto@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] x86 vdso updates
In-Reply-To: <20110528153536.GB27104@elte.hu>
References: <alpine.LFD.2.02.1105262049180.3078@ionos>
	<4DDEC589.3010201@mit.edu>
	<20110527061208.GB9260@elte.hu>
	<BANLkTinOQ_C_-Bix4FTQxHqP3aavmTRrzg@mail.gmail.com>
	<BANLkTikKAx=KXZuECAXaskhZOre-2ZHutw@mail.gmail.com>
	<20110528153536.GB27104@elte.hu>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:
 > 
 > * Andrew Lutomirski <luto@mit.edu> wrote:
 > 
 > > On Fri, May 27, 2011 at 7:36 AM, Andrew Lutomirski <luto@mit.edu> wrote:
 > > > 3. Add int 0xcc and use it from vgettimeofday.  It will SIGSEGV if
 > > > called from a user address (so it has no risk of ever becoming ABI)
 > > > and it will do gettimeofday if called from the right address.  (I like
...
 > > Make it a real syscall but with extra constraints.  It would have the
 > > same calling convention as the syscall instruction, but it would turn
 > > into SIGKILL if the calling address isn't in the VSYSCALL page

This will make things difficult for user-space dynamic binary instrumentation
applications, since these normally execute generated code at different
addresses than the original code.

Is there a safe fallback for this particular vsyscall?

/Mikael
