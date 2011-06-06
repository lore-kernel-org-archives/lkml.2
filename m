Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab1FFIf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:35:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:40190 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756980Ab1FFIfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:35:51 -0400
Date: Mon, 6 Jun 2011 08:34:54 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-38172403a97828ae2ea12281b19528582d6625d4@git.kernel.org>
Cc: mingo@redhat.com, brgerst@gmail.com, torvalds@linux-foundation.org,
        mikpe@it.uu.se, richard.weinberger@gmail.com, jj@chaosbits.net,
        JBeulich@novell.com, tglx@linutronix.de, Louis.Rilling@kerlabs.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, luto@mit.edu,
        andi@firstfloor.org, bp@alien8.de, arjan@infradead.org, mingo@elte.hu
Reply-To: mingo@redhat.com, torvalds@linux-foundation.org, brgerst@gmail.com,
        mikpe@it.uu.se, richard.weinberger@gmail.com, jj@chaosbits.net,
        JBeulich@novell.com, tglx@linutronix.de, Louis.Rilling@kerlabs.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, luto@mit.edu,
        andi@firstfloor.org, bp@alien8.de, arjan@infradead.org, mingo@elte.hu
In-Reply-To: <4de62bfbf6974f14d0e9d9ae37cc137dbc926a30.1307292171.git.luto@mit.edu>
References: <4de62bfbf6974f14d0e9d9ae37cc137dbc926a30.1307292171.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
Git-Commit-ID: 38172403a97828ae2ea12281b19528582d6625d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Jun 2011 08:34:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38172403a97828ae2ea12281b19528582d6625d4
Gitweb:     http://git.kernel.org/tip/38172403a97828ae2ea12281b19528582d6625d4
Author:     Andy Lutomirski <luto@mit.edu>
AuthorDate: Sun, 5 Jun 2011 13:50:25 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 6 Jun 2011 09:43:15 +0200

x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule

CONFIG_UNSAFE_VSYSCALLS was added in the previous patch as a
temporary hack to avoid penalizing users who don't build glibc
from git.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: Valdis.Kletnieks@vt.edu
Cc: pageexec@freemail.hu
Link: http://lkml.kernel.org/r/4de62bfbf6974f14d0e9d9ae37cc137dbc926a30.1307292171.git.luto@mit.edu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/feature-removal-schedule.txt |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 1a9446b..94b4470 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -600,3 +600,12 @@ Why:	Superseded by the UVCIOC_CTRL_QUERY ioctl.
 Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 
 ----------------------------
+
+What:	CONFIG_UNSAFE_VSYSCALLS (x86_64)
+When:	When glibc 2.14 or newer is ubitquitous.  Perhaps mid-2012.
+Why:	Having user-executable code at a fixed address is a security problem.
+	Turning off CONFIG_UNSAFE_VSYSCALLS mostly removes the risk but will
+	make the time() function slower on glibc versions 2.13 and below.
+Who:	Andy Lutomirski <luto@mit.edu>
+
+----------------------------
