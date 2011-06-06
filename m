Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab1FFWHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:07:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:60329 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab1FFWHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:07:10 -0400
Date: Mon, 6 Jun 2011 22:06:48 GMT
From: tip-bot for Josh Triplett <josh@joshtriplett.org>
Message-ID: <tip-f505c553dbe24b18a8590eb0eb5890a839acd0c3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, sam@ravnborg.org, fweisbec@gmail.com,
        tglx@linutronix.de, josh@joshtriplett.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sam@ravnborg.org, torvalds@linux-foundation.org, fweisbec@gmail.com,
        tglx@linutronix.de, josh@joshtriplett.org, mingo@elte.hu
In-Reply-To: <20110606012358.GA1909@leaf>
References: <20110606012358.GA1909@leaf>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/debug] debug: Make CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to unhide debug options
Git-Commit-ID: f505c553dbe24b18a8590eb0eb5890a839acd0c3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Jun 2011 22:06:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f505c553dbe24b18a8590eb0eb5890a839acd0c3
Gitweb:     http://git.kernel.org/tip/f505c553dbe24b18a8590eb0eb5890a839acd0c3
Author:     Josh Triplett <josh@joshtriplett.org>
AuthorDate: Sun, 5 Jun 2011 18:23:58 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Jun 2011 00:05:15 +0200

debug: Make CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to unhide debug options

Several debugging options currently default to y, such as
CONFIG_DEBUG_BUGVERBOSE and CONFIG_DEBUG_RODATA.  Embedded users
might want to turn those options off to save space; however,
turning them off requires turning on CONFIG_DEBUG_KERNEL to
unhide them.  Since CONFIG_DEBUG_KERNEL exists specifically to
unhide debugging options, and CONFIG_EXPERT exists specifically
to unhide options potentially needed by experts and/or embedded
users, make CONFIG_EXPERT automatically imply
CONFIG_DEBUG_KERNEL.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110606012358.GA1909@leaf
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 init/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index ebafac4..14370d3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -909,6 +909,8 @@ config ANON_INODES
 
 menuconfig EXPERT
 	bool "Configure standard kernel features (expert users)"
+	# Unhide debug options, to make the on-by-default options visible
+	select DEBUG_KERNEL
 	help
 	  This option allows certain base kernel options and settings
           to be disabled or tweaked. This is for specialized
