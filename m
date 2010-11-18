Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698Ab0KRVtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:49:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:45211 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887Ab0KRVtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:49:53 -0500
Date: Thu, 18 Nov 2010 21:49:13 GMT
From: tip-bot for Vasiliy Kulikov <segoon@openwall.com>
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, segoon@openwall.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, segoon@openwall.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1290104207-31279-1-git-send-email-segoon@openwall.com>
References: <1290104207-31279-1-git-send-email-segoon@openwall.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86, mrst: Check platform_device_register() return code
Message-ID: <tip-5ca9afdb9f6a5267927b54de3f42c756e8af7fcd@git.kernel.org>
Git-Commit-ID: 5ca9afdb9f6a5267927b54de3f42c756e8af7fcd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 21:49:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ca9afdb9f6a5267927b54de3f42c756e8af7fcd
Gitweb:     http://git.kernel.org/tip/5ca9afdb9f6a5267927b54de3f42c756e8af7fcd
Author:     Vasiliy Kulikov <segoon@openwall.com>
AuthorDate: Thu, 18 Nov 2010 21:16:45 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 18 Nov 2010 13:45:46 -0800

x86, mrst: Check platform_device_register() return code

platform_device_register() may fail, if so propagate the return
code from mrst_device_create().

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
LKML-Reference: <1290104207-31279-1-git-send-email-segoon@openwall.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/mrst/vrtc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/mrst/vrtc.c b/arch/x86/platform/mrst/vrtc.c
index 4d3f770..32cd7ed 100644
--- a/arch/x86/platform/mrst/vrtc.c
+++ b/arch/x86/platform/mrst/vrtc.c
@@ -159,8 +159,7 @@ static int __init mrst_device_create(void)
 	vrtc_resources[1].start = sfi_mrtc_array[0].irq;
 	vrtc_resources[1].end = sfi_mrtc_array[0].irq;
 
-	platform_device_register(&vrtc_device);
-	return 0;
+	return platform_device_register(&vrtc_device);
 }
 
 module_init(mrst_device_create);
