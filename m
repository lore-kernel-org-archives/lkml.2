Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993411Ab2K3TMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:12:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:59518 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992965Ab2K3TCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:02:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 04/54] x86, microcode, AMD: Add support for family 16h processors
Date: Fri, 30 Nov 2012 10:55:35 -0800
Message-Id: <20121130185208.339192908@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Ostrovsky <boris.ostrovsky@amd.com>

commit 36c46ca4f322a7bf89aad5462a3a1f61713edce7 upstream.

Add valid patch size for family 16h processors.

[ hpa: promoting to urgent/stable since it is hw enabling and trivial ]

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
Acked-by: Andreas Herrmann <herrmann.der.user@googlemail.com>
Link: http://lkml.kernel.org/r/1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/microcode_amd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -97,6 +97,7 @@ static unsigned int verify_ucode_size(in
 #define F1XH_MPB_MAX_SIZE 2048
 #define F14H_MPB_MAX_SIZE 1824
 #define F15H_MPB_MAX_SIZE 4096
+#define F16H_MPB_MAX_SIZE 3458
 
 	switch (c->x86) {
 	case 0x14:
@@ -105,6 +106,9 @@ static unsigned int verify_ucode_size(in
 	case 0x15:
 		max_size = F15H_MPB_MAX_SIZE;
 		break;
+	case 0x16:
+		max_size = F16H_MPB_MAX_SIZE;
+		break;
 	default:
 		max_size = F1XH_MPB_MAX_SIZE;
 		break;


