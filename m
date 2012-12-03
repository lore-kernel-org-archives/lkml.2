Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab2LCOwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:52:15 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43690 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755330Ab2LCOgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:10 -0500
Message-Id: <20121203143157.502415052@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:57 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 71/89] x86, microcode, AMD: Add support for family 16h processors
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Ostrovsky <boris.ostrovsky@amd.com>

commit 36c46ca4f322a7bf89aad5462a3a1f61713edce7 upstream.

Add valid patch size for family 16h processors.

[ hpa: promoting to urgent/stable since it is hw enabling and trivial ]

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
Acked-by: Andreas Herrmann <herrmann.der.user@googlemail.com>
Link: http://lkml.kernel.org/r/1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/microcode_amd.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index b3e67ba..efdec7c 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -190,6 +190,7 @@ static unsigned int verify_patch_size(int cpu, u32 patch_size,
 #define F1XH_MPB_MAX_SIZE 2048
 #define F14H_MPB_MAX_SIZE 1824
 #define F15H_MPB_MAX_SIZE 4096
+#define F16H_MPB_MAX_SIZE 3458
 
 	switch (c->x86) {
 	case 0x14:
@@ -198,6 +199,9 @@ static unsigned int verify_patch_size(int cpu, u32 patch_size,
 	case 0x15:
 		max_size = F15H_MPB_MAX_SIZE;
 		break;
+	case 0x16:
+		max_size = F16H_MPB_MAX_SIZE;
+		break;
 	default:
 		max_size = F1XH_MPB_MAX_SIZE;
 		break;


