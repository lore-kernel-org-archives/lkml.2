Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab1FFR1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:27:46 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:52358 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756136Ab1FFR1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:27:43 -0400
X-AuditID: 1209190e-b7c39ae000000a8c-8e-4ded0e00c4a0
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, Ingo Molnar <mingo@elte.hu>
Cc: pageexec@freemail.hu, Mikael Pettersson <mikpe@it.uu.se>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 0/3] x86-64: vsyscall emulation cleanups
Date: Mon,  6 Jun 2011 13:27:22 -0400
Message-Id: <cover.1307380481.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsUixG6nrsvA99bXoIvLou/KUXaLaRvFLS7v
	msNm8aT5OqPFlkvNrBaP1zxntnjU95bd4seGx6wOHB632v4weyzp+MHusXPWXXaP/y+PsHls
	WtXJ5nFixm8Wj8+b5DxOtHxhDeCI4rJJSc3JLEst0rdL4MrY92sLc8ECropln6YyNTD+Ze9i
	5OSQEDCRmH1oKhOELSZx4d56ti5GLg4hgX2MEh/Pn2WBcNYzSsx79Z8NpEpI4BCTRN+CLBCb
	TUBFomPpA7BuEQF9id9nFzGCNDALPGeUePHhBFiDsICFRN+3t8wgNouAqsTRL6/AVvMCNcz5
	8wWogQNotYLE+VX5Exh5FjAyrGKUTcmt0s1NzMwpTk3WLU5OzMtLLdI11svNLNFLTSndxAgK
	OU5Jvh2MXw8qHWIU4GBU4uF99OWNrxBrYllxZe4hRkkOJiVR3lbet75CfEn5KZUZicUZ8UWl
	OanFhxglOJiVRHjj3wCV86YkVlalFuXDpKQ5WJTEeWdKqvsKCaQnlqRmp6YWpBbBZGU4OJQk
	eMVBhgoWpaanVqRl5pQgpJk4OEGG8wANn8cBVMNbXJCYW5yZDpE/xajLsfXE24OMQix5+Xmp
	UuK8+SCDBECKMkrz4ObAUsUrRnGgt4R5PUGqeIBpBm7SK6AlTEBLjju9AllSkoiQkmpgNOVe
	4rkoODClXadu4tWlh5ssLjnOULjx/AjvuwufryQVXZMPPNo5u4l1XZjHhULGYxJeHUp8M/hr
	3L+n5Es/+eS1Zf7FiAPaPdu22JSkfJ50P/qKwr/GR56CTmntE9kDeo+wrd/10eW8qmeLiJfy
	j/UvPrtZ9hvzr/p8bfbcixU6TbIujy9UKLEUZyQaajEXFScCAGEbbSfwAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc list trimmed from the previous patches to include only people who seem
 like they would care about this round of changes.  My apologies if I missed
 anyone.]

This series applies to the x86/vdso branch of the -tip tree.

Patch 1/3 deletes some very outdated comments in vsyscall_64.c.

Patch 2/3 simplifies the vsyscall emulation int 0xcc mechanism and removes
some ret instructions that are (as pointed out by the PaX team) possibly
dangerous.

Patch 3/3 fixes what is arguably the most serious problem of all: people
thought that CONFIG_COMPAT_VSYSCALLS controlled binary compatibility.  It
changes the Kconfig short description, help text, and feature removal entry
to make it a lot more clear what's going on.

Andy Lutomirski (3):
  x86-64: Fix outdated comments in vsyscall_64.c
  x86-64: Clean up vsyscall emulation and remove fixed-address ret
  x86-64: Clarify CONFIG_COMPAT_VSYSCALLS text

 Documentation/feature-removal-schedule.txt |   11 ++-
 arch/x86/Kconfig                           |   27 +++++----
 arch/x86/include/asm/vsyscall.h            |   10 +++-
 arch/x86/kernel/vsyscall_64.c              |   85 +++++++++-------------------
 arch/x86/kernel/vsyscall_emu_64.S          |   17 +-----
 5 files changed, 58 insertions(+), 92 deletions(-)

-- 
1.7.5.2

