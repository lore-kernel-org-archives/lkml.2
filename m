Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab2K0XqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:46:09 -0500
Received: from ozlabs.org ([203.10.76.45]:50718 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756507Ab2K0XqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:46:06 -0500
From: Michael Neuling <mikey@neuling.org>
To: Grant Likely <grant.likely@secretlab.ca>
cc: Jimi Xenidis <jimix@pobox.com>, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH v2] drivers/of: Constify device_node->name and ->path_component_name
In-reply-to: <1353075625-7755-1-git-send-email-grant.likely@secretlab.ca>
References: <1353075625-7755-1-git-send-email-grant.likely@secretlab.ca>
Comments: In-reply-to Grant Likely <grant.likely@secretlab.ca>
   message dated "Fri, 16 Nov 2012 14:20:25 -0000."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Wed, 28 Nov 2012 10:46:04 +1100
Message-ID: <23435.1354059964@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Neither of these should ever be changed once set. Make them const and
> fix up the users that try to modify it in-place. In one case
> kmalloc+memcpy is replaced with kstrdup() to avoid modifying the string.
> 
> Build tested with defconfigs on ARM, PowerPC, Sparc, MIPS, x86 among
> others.

Grant,

This breaks powerpc chroma_defconfig in next-20121127 with:

arch/powerpc/sysdev/scom.c:160:17: error: assignment discards 'const' qualifier from pointer target type [-Werror]

The following fixes it.  The change is to generic code, so I'm not sure
it's the right fix as it may break other configs/archs.

diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 66c434f..77f64e4 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -23,7 +23,7 @@
 struct file_operations;
 
 struct debugfs_blob_wrapper {
-	void *data;
+	const void *data;
 	unsigned long size;
 };
