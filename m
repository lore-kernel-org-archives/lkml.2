Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1GWTTO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 15:19:14 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:58117 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753336Ab1GWTTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 15:19:11 -0400
X-AuditID: 12074425-b7bcaae000000a1b-b1-4e2b1e886466
From: Andy Lutomirski <luto@MIT.EDU>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH resend 0/2] Fix x86-64 linker script when using gold
Date: Sat, 23 Jul 2011 15:19:01 -0400
Message-Id: <cover.1311448660.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <201107231559.23537.a.miskiewicz@gmail.com>
References: <201107231559.23537.a.miskiewicz@gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsUixG6notshp+1ncGQKm8XSHy+ZLfquHGW3
	uLxrDpvFlkvNrBY/NjxmdWD1uNX2h9lj56y77B6bVnWyeXzeJBfAEsVlk5Kak1mWWqRvl8CV
	cWPiLsaCnWwV3Q9/szUwzmPtYuTgkBAwkXh/N7OLkRPIFJO4cG89G4gtJLCPUaL7fHUXIxeQ
	vYFRYmrPLmYI5xmTxMQpl8Gq2ARUJDqWPmACsUUE/CR+vm9nBrGZBSIlLjxZzQJiCwu4SNw5
	85cRxGYRUJVYuvgNWA2vgL7Eiue3GCE2y0kcufwcbA6ngIXEjY2NrBBXmEt8WTCFZQIj3wJG
	hlWMsim5Vbq5iZk5xanJusXJiXl5qUW6Fnq5mSV6qSmlmxjB4eWiuoNxwiGlQ4wCHIxKPLyb
	vmj5CbEmlhVX5h5ilORgUhLlDZPR9hPiS8pPqcxILM6ILyrNSS0+xCjBwawkwnt5C1A5b0pi
	ZVVqUT5MSpqDRUmcN8T7v6+QQHpiSWp2ampBahFMVoaDQ0mClxsYR0KCRanpqRVpmTklCGkm
	Dk6Q4TxAw/fLAtXwFhck5hZnpkPkTzHqcvyc3XuUUYglLz8vVUqclx9kkABIUUZpHtwcWFp4
	xSgO9JYw7y+QUTzAlAI36RXQEiagJfIKmiBLShIRUlINjFwZp4Ktpz8+MHnfTv4Vh6t2J3Bo
	6p2q0mKYaCMWpvtZeGHzHda7VzedPXHhYzunW7+MkUZLZy1r8ArjUwIC9a0eZnXVzpdm306/
	XLnCycUjz/b6gcwTD2vSPrO+ZHwhoFrxNlQ17IL9umW/jjdX9L4wKxVPWJIqoPFUagrjtmm3
	bOeU98TNUWIpzkg01GIuKk4EAJqGx/rmAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resent because I misspelled linux-kernel the first time.]

We were hitting two bugs:
http://sourceware.org/bugzilla/show_bug.cgi?id=13019
http://sourceware.org/bugzilla/show_bug.cgi?id=13023

The former was really a bug on the linker script that neither the
old bfd linker nor the kernel loader cared about.  It caused gold to
bail, though.

The second is, I think, a legitimate bug in gold.  But rather than
regressing on current gold versions, we can work around it.

This is what I get for messing with the linker script :-/

Andy Lutomirski (2):
  x86-64: Move the "user" vsyscall segment out of the data segment.
  x86-64: Work around gold bug 13023

 arch/x86/kernel/vmlinux.lds.S |   46 ++++++++++++++++++++++------------------
 1 files changed, 25 insertions(+), 21 deletions(-)

-- 
1.7.6

