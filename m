Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab2GQXT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 19:19:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53189 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab2GQXTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 19:19:24 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3.5 0/2] seccomp and vsyscall fixes
Date: Tue, 17 Jul 2012 16:19:18 -0700
Message-Id: <cover.1342566495.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies for the lateness of this stuff.  I was at a conference last
week when the Chrome issue was discovered and I couldn't do this
properly until I got back.

Will, can you confirm that this version is okay and passes your tests?
It passes mine.

While there are no known seccomp users that will have trouble,
SECCOMP_RET_TRAP and SECCOMP_RET_TRACE currently interact oddly with
emulated vsyscalls.  This might lead to ABI issues down the road (if
something starts to rely on current behavior) or unexpected malfunctions
(if something tries to change, say, sys_gettimeofday, into a different
syscall and gets completely bogus results on a vsyscall-using distro.

It's unlikely that fixing this later will cause issues, but it would be
nice to nail down and document the vsyscall quirks for the first
released kernel with seccomp mode 2 support.

(Patch 2/2 is very much optional.  It fixes a strange corner case.  It
 ought to be fine for 3.6, since I very much doubt that any real code
 will hit that corner case and cause ABI problems.)

Andy Lutomirski (2):
  seccomp: Make syscall skipping and nr changes more consistent
  seccomp: Future-proof against silly tracers

 Documentation/prctl/seccomp_filter.txt |   74 ++++++++++++++++++++--
 arch/x86/include/asm/syscall.h         |   11 +++
 arch/x86/kernel/vsyscall_64.c          |  110 +++++++++++++++++---------------
 kernel/seccomp.c                       |   28 +++++++-
 4 files changed, 163 insertions(+), 60 deletions(-)

-- 
1.7.7.6

