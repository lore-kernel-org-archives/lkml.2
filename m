Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab1KSBII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 20:08:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54425 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab1KSBIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 20:08:05 -0500
Date: Fri, 18 Nov 2011 17:07:42 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-3f86886c72fb68088162c7e08cc7f85282f1860c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, hjl.tools@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, hjl.tools@gmail.com
In-Reply-To: <1321569446-20433-7-git-send-email-hpa@linux.intel.com>
References: <1321569446-20433-7-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/syscall] x86, syscall: Allow syscall offset to be symbolic
Git-Commit-ID: 3f86886c72fb68088162c7e08cc7f85282f1860c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 17:07:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f86886c72fb68088162c7e08cc7f85282f1860c
Gitweb:     http://git.kernel.org/tip/3f86886c72fb68088162c7e08cc7f85282f1860c
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 18 Nov 2011 17:01:19 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 18 Nov 2011 17:01:19 -0800

x86, syscall: Allow syscall offset to be symbolic

Allow the specified syscall offset to be symbolic, e.g. a macro.  For
offset system calls, this if nothing else makes the generated code
easier to read.

Suggested-by: H. J. Lu <hjl.tools@gmail.com>
Link: http://lkml.kernel.org/r/1321569446-20433-7-git-send-email-hpa@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/syscalls/syscallhdr.sh |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/syscalls/syscallhdr.sh b/arch/x86/syscalls/syscallhdr.sh
index b3c5930..31fd5f1 100644
--- a/arch/x86/syscalls/syscallhdr.sh
+++ b/arch/x86/syscalls/syscallhdr.sh
@@ -15,7 +15,11 @@ grep -E "^[0-9A-Fa-fXx]+[[:space:]]+${my_abis}" "$in" | sort -n | (
     echo ""
 
     while read nr abi name entry ; do
-	echo "#define __NR_${prefix}${name}" $((nr+offset))
+	if [ -z "$offset" ]; then
+	    echo "#define __NR_${prefix}${name} $nr"
+	else
+	    echo "#define __NR_${prefix}${name} ($offset + $nr)"
+        fi
     done
 
     echo ""
