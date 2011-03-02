Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab1CBAnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 19:43:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:56946 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553Ab1CBAnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 19:43:23 -0500
Date: Wed, 2 Mar 2011 00:43:04 GMT
From: tip-bot for Daniel J Blueman <daniel.blueman@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        daniel.blueman@gmail.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        daniel.blueman@gmail.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <AANLkTimxxTMU3=4ry-_zbY6v1xiDi+hW9y1RegTr8vLK@mail.gmail.com>
References: <AANLkTimxxTMU3=4ry-_zbY6v1xiDi+hW9y1RegTr8vLK@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, build: Make sure mkpiggy fails on read error
Message-ID: <tip-6670e9cdaf554290e26121aa72f0118f2fac52e5@git.kernel.org>
Git-Commit-ID: 6670e9cdaf554290e26121aa72f0118f2fac52e5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Mar 2011 00:43:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6670e9cdaf554290e26121aa72f0118f2fac52e5
Gitweb:     http://git.kernel.org/tip/6670e9cdaf554290e26121aa72f0118f2fac52e5
Author:     Daniel J Blueman <daniel.blueman@gmail.com>
AuthorDate: Wed, 23 Feb 2011 09:33:59 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 1 Mar 2011 16:32:03 -0800

x86, build: Make sure mkpiggy fails on read error

Ensure build doesn't silently continue despite read failure,
addressing a warning due to the unchecked call.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
LKML-Reference: <AANLkTimxxTMU3=4ry-_zbY6v1xiDi+hW9y1RegTr8vLK@mail.gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/mkpiggy.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index 646aa78..46a8238 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -62,7 +62,12 @@ int main(int argc, char *argv[])
 	if (fseek(f, -4L, SEEK_END)) {
 		perror(argv[1]);
 	}
-	fread(&olen, sizeof olen, 1, f);
+
+	if (fread(&olen, sizeof(olen), 1, f) != 1) {
+		perror(argv[1]);
+		return 1;
+	}
+
 	ilen = ftell(f);
 	olen = getle32(&olen);
 	fclose(f);
