Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab0IUT61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 15:58:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:54878 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756338Ab0IUT60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 15:58:26 -0400
Date: Tue, 21 Sep 2010 19:58:06 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        just.for.lkml@googlemail.com, yinghai@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, just.for.lkml@googlemail.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <4C7B0578.8090807@kernel.org>
References: <4C7B0578.8090807@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, setup: Fix earlyprintk=serial,ttyS0,115200
Message-ID: <tip-83d9f65bdae6f6b34d75282c6618d3f50846849a@git.kernel.org>
Git-Commit-ID: 83d9f65bdae6f6b34d75282c6618d3f50846849a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 21 Sep 2010 19:58:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  83d9f65bdae6f6b34d75282c6618d3f50846849a
Gitweb:     http://git.kernel.org/tip/83d9f65bdae6f6b34d75282c6618d3f50846849a
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sun, 29 Aug 2010 18:12:24 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 21 Sep 2010 10:18:14 -0700

x86, setup: Fix earlyprintk=serial,ttyS0,115200

Torsten reported that there is garbage output,
after commit 8fee13a48e4879fba57725f6d9513df4bfa8e9f3 (x86,
setup: enable early console output from the decompressor)

It turns out we missed the offset for that case.

Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4C7B0578.8090807@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/early_serial_console.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/early_serial_console.c b/arch/x86/boot/early_serial_console.c
index 030f4b9..407a8e2 100644
--- a/arch/x86/boot/early_serial_console.c
+++ b/arch/x86/boot/early_serial_console.c
@@ -58,7 +58,7 @@ static void parse_earlyprintk(void)
 		if (arg[pos] == ',')
 			pos++;
 
-		if (!strncmp(arg, "ttyS", 4)) {
+		if (!strncmp(arg + pos, "ttyS", 4)) {
 			static const int bases[] = { 0x3f8, 0x2f8 };
 			int idx = 0;
 
