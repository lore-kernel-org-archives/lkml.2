Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992527Ab2KAULb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:11:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934346Ab2KAULR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:11:17 -0400
From: Milan Broz <mbroz@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jaxboe@fusionio.com, kzak@redhat.com, Milan Broz <mbroz@redhat.com>
Subject: [RFC PATCH 3/4] Deprecate loop crypto ioctl fields.
Date: Thu,  1 Nov 2012 21:11:03 +0100
Message-Id: <a7fbc700349b5cff0fde025cfc34bd979f0b39c5.1351799190.git.mbroz@redhat.com>
In-Reply-To: <cover.1351799189.git.mbroz@redhat.com>
References: <cover.1351799189.git.mbroz@redhat.com>
In-Reply-To: <cover.1351799189.git.mbroz@redhat.com>
References: <cover.1351799189.git.mbroz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark encryption loop fields in userspace API deprecated.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 include/uapi/linux/loop.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/loop.h b/include/uapi/linux/loop.h
index e0cecd2..d0896c7 100644
--- a/include/uapi/linux/loop.h
+++ b/include/uapi/linux/loop.h
@@ -11,7 +11,7 @@
 
 
 #define LO_NAME_SIZE	64
-#define LO_KEY_SIZE	32
+#define LO_KEY_SIZE	32 /* deprecated */
 
 
 /*
@@ -33,11 +33,11 @@ struct loop_info {
 	unsigned long	   lo_inode; 		/* ioctl r/o */
 	__kernel_old_dev_t lo_rdevice; 		/* ioctl r/o */
 	int		   lo_offset;
-	int		   lo_encrypt_type;
-	int		   lo_encrypt_key_size; 	/* ioctl w/o */
+	int		   lo_encrypt_type;	/* deprecated */
+	int		   lo_encrypt_key_size; 	/* deprecated */
 	int		   lo_flags;			/* ioctl r/o */
 	char		   lo_name[LO_NAME_SIZE];
-	unsigned char	   lo_encrypt_key[LO_KEY_SIZE]; /* ioctl w/o */
+	unsigned char	   lo_encrypt_key[LO_KEY_SIZE]; /* deprecated */
 	unsigned long	   lo_init[2];
 	char		   reserved[4];
 };
@@ -49,17 +49,17 @@ struct loop_info64 {
 	__u64		   lo_offset;
 	__u64		   lo_sizelimit;/* bytes, 0 == max available */
 	__u32		   lo_number;			/* ioctl r/o */
-	__u32		   lo_encrypt_type;
-	__u32		   lo_encrypt_key_size;		/* ioctl w/o */
+	__u32		   lo_encrypt_type;		/* deprecated */
+	__u32		   lo_encrypt_key_size;		/* deprecated */
 	__u32		   lo_flags;			/* ioctl r/o */
 	__u8		   lo_file_name[LO_NAME_SIZE];
-	__u8		   lo_crypt_name[LO_NAME_SIZE];
-	__u8		   lo_encrypt_key[LO_KEY_SIZE]; /* ioctl w/o */
+	__u8		   lo_crypt_name[LO_NAME_SIZE]; /* deprecated */
+	__u8		   lo_encrypt_key[LO_KEY_SIZE]; /* deprecated */
 	__u64		   lo_init[2];
 };
 
 /*
- * Loop filter types
+ * Loop filter types (deprecated)
  */
 
 #define LO_CRYPT_NONE		0
-- 
1.7.10.4

