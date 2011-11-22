Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946Ab1KVXAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 18:00:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33880 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab1KVXAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 18:00:19 -0500
Date: Tue, 22 Nov 2011 14:57:57 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-9147621c771c8b6a5c8985373af3a8200e8b4a41@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mmarek@suse.cz, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mmarek@suse.cz
In-Reply-To: <4ECA8991.20302@suse.cz>
References: <4ECA8991.20302@suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/syscall] kbuild, headers.sh: Don't make archheaders explicitly
Git-Commit-ID: 9147621c771c8b6a5c8985373af3a8200e8b4a41
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 22 Nov 2011 14:58:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9147621c771c8b6a5c8985373af3a8200e8b4a41
Gitweb:     http://git.kernel.org/tip/9147621c771c8b6a5c8985373af3a8200e8b4a41
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 22 Nov 2011 14:47:50 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 22 Nov 2011 14:47:50 -0800

kbuild, headers.sh: Don't make archheaders explicitly

We don't need to explicitly invoke the archheaders target because of
the dependency on __headers in the Makefile.

Reported-and-tested-by: Michal Marek <mmarek@suse.cz>
Link: http://lkml.kernel.org/r/4ECA8991.20302@suse.cz
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 scripts/headers.sh |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/scripts/headers.sh b/scripts/headers.sh
index af1ed88..978b42b 100755
--- a/scripts/headers.sh
+++ b/scripts/headers.sh
@@ -7,7 +7,6 @@ set -e
 do_command()
 {
 	if [ -f ${srctree}/arch/$2/include/asm/Kbuild ]; then
-		make ARCH=$2 KBUILD_HEADERS=$1 archheaders
 		make ARCH=$2 KBUILD_HEADERS=$1 headers_$1
 	else
 		printf "Ignoring arch: %s\n" ${arch}
