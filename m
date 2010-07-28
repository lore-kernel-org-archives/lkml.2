Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab0G1HT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 03:19:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:42183 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab0G1HTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 03:19:18 -0400
Date: Wed, 28 Jul 2010 07:19:00 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        sfr@canb.auug.org.au, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, sfr@canb.auug.org.au
In-Reply-To: <20100728134252.2e4c27cf.sfr@canb.auug.org.au>
References: <20100728134252.2e4c27cf.sfr@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86, vdso: Don't quote $nm in the script for checking vdso references
Message-ID: <tip-18642a57df02a044b91219d3176128996ddc81a5@git.kernel.org>
Git-Commit-ID: 18642a57df02a044b91219d3176128996ddc81a5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 28 Jul 2010 07:19:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18642a57df02a044b91219d3176128996ddc81a5
Gitweb:     http://git.kernel.org/tip/18642a57df02a044b91219d3176128996ddc81a5
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 27 Jul 2010 23:52:29 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 27 Jul 2010 23:52:29 -0700

x86, vdso: Don't quote $nm in the script for checking vdso references

Don't quote $nm in the script for checking the vdso for external
references.  Doing so breaks multiword constructs, like using
CROSS_COMPILE='ccache '.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <20100728134252.2e4c27cf.sfr@canb.auug.org.au>
---
 arch/x86/vdso/checkundef.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/vdso/checkundef.sh b/arch/x86/vdso/checkundef.sh
index 490be1c..7ee90a9 100755
--- a/arch/x86/vdso/checkundef.sh
+++ b/arch/x86/vdso/checkundef.sh
@@ -1,7 +1,7 @@
 #!/bin/sh
 nm="$1"
 file="$2"
-"$nm" "$file" | grep '^ *U' > /dev/null 2>&1
+$nm "$file" | grep '^ *U' > /dev/null 2>&1
 if [ $? -eq 1 ]; then
     exit 0
 else
