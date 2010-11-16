Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402Ab0KPGpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 01:45:25 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61905 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759264Ab0KPGpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 01:45:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YJElKQvOB9nVDZXk7UAkd4duFjV1zv8pWjtvAqEFRdOAG/ZZ38kvKR/pBlEGQr20vs
         tFa8cFSz+gRMqJm/5Lqhbt4fQFofzDpqws5M0exx1OeL6J1dyWdF9S33hQsu4gRQ2Qak
         5ykprfix7AezvdC5m6Y9LA1aMbxCMB/K1vEdc=
From: Tushar Mehta <tushariiitb@gmail.com>
To: gregkh@suse.de, hpa@zytor.com, ak@linux.intel.com,
        andrea.gelmini@gelma.net, hjk@linutronix.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        autofs@linux.kernel.org, Tushar Mehta <tushariiitb@gmail.com>
Subject: [PATCH] Staging: fix coding style issue in asus_oled/asus_oled.c and autofs/dirhash.c
Date: Tue, 16 Nov 2010 12:13:50 +0530
Message-Id: <1289889830-21163-1-git-send-email-tushariiitb@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the asus_oled.c and dirhash.c file that
fixes up a brace warning found by the checkpatch.pl tool

Signed-off-by: Tushar Mehta <tushariiitb@gmail.com>
---
 drivers/staging/asus_oled/asus_oled.c |    2 +-
 drivers/staging/autofs/dirhash.c      |   87 ++++++++++++++++++--------------
 2 files changed, 50 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 8c95d8c..1dda9fb 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -70,7 +70,7 @@ module_param(start_off, uint, 0644);
 MODULE_PARM_DESC(start_off,
 		 "Set to 1 to switch off OLED display after it is attached");
 
-enum oled_pack_mode{
+enum oled_pack_mode {
 	PACK_MODE_G1,
 	PACK_MODE_G50,
 	PACK_MODE_LAST
diff --git a/drivers/staging/autofs/dirhash.c b/drivers/staging/autofs/dirhash.c
index 8f3e2b8..d3f42c8 100644
--- a/drivers/staging/autofs/dirhash.c
+++ b/drivers/staging/autofs/dirhash.c
@@ -30,7 +30,7 @@ void autofs_update_usage(struct autofs_dirhash *dh,
 			 struct autofs_dir_ent *ent)
 {
 	autofs_delete_usage(ent);   /* Unlink from current position */
-	autofs_init_usage(dh,ent);  /* Relink at queue tail */
+	autofs_init_usage(dh, ent);  /* Relink at queue tail */
 }
 
 struct autofs_dir_ent *autofs_expire(struct super_block *sb,
@@ -45,17 +45,18 @@ struct autofs_dir_ent *autofs_expire(struct super_block *sb,
 		struct path path;
 		int umount_ok;
 
-		if ( list_empty(&dh->expiry_head) || sbi->catatonic )
+		if (list_empty(&dh->expiry_head) || sbi->catatonic)
 			return NULL;	/* No entries */
 		/* We keep the list sorted by last_usage and want old stuff */
-		ent = list_entry(dh->expiry_head.next, struct autofs_dir_ent, exp);
+		ent = list_entry(dh->expiry_head.next,
+						struct autofs_dir_ent, exp);
 		if (jiffies - ent->last_usage < timeout)
 			break;
 		/* Move to end of list in case expiry isn't desirable */
 		autofs_update_usage(dh, ent);
 
 		/* Check to see that entry is expirable */
-		if ( ent->ino < AUTOFS_FIRST_DIR_INO )
+		if (ent->ino < AUTOFS_FIRST_DIR_INO)
 			return ent; /* Symlinks are always expirable */
 
 		/* Get the dentry for the autofs subdirectory */
@@ -63,14 +64,15 @@ struct autofs_dir_ent *autofs_expire(struct super_block *sb,
 
 		if (!path.dentry) {
 			/* Should only happen in catatonic mode */
-			printk("autofs: dentry == NULL but inode range is directory, entry %s\n", ent->name);
+			printk(KERN_DEBUG "autofs: dentry == NULL but inode \
+				range is directory, entry %s\n", ent->name);
 			autofs_delete_usage(ent);
 			continue;
 		}
 
 		if (!path.dentry->d_inode) {
 			dput(path.dentry);
-			printk("autofs: negative dentry on expiry queue: %s\n",
+			printk(KERN_DEBUG "autofs: negative dentry on expiry queue: %s\n",
 			       ent->name);
 			autofs_delete_usage(ent);
 			continue;
@@ -80,14 +82,16 @@ struct autofs_dir_ent *autofs_expire(struct super_block *sb,
 		   point to the mounted-on-top root. */
 		if (!S_ISDIR(path.dentry->d_inode->i_mode) ||
 		    !d_mountpoint(path.dentry)) {
-			DPRINTK(("autofs: not expirable (not a mounted directory): %s\n", ent->name));
+			DPRINTK(("autofs: not expirable \
+				(not a mounted directory): %s\n", ent->name));
 			continue;
 		}
 		path.mnt = mnt;
 		path_get(&path);
 		if (!follow_down(&path)) {
 			path_put(&path);
-			DPRINTK(("autofs: not expirable (not a mounted directory): %s\n", ent->name));
+			DPRINTK(("autofs: not expirable\
+			(not a mounted directory): %s\n", ent->name));
 			continue;
 		}
 		while (d_mountpoint(path.dentry) && follow_down(&path))
@@ -96,30 +100,37 @@ struct autofs_dir_ent *autofs_expire(struct super_block *sb,
 		path_put(&path);
 
 		if (umount_ok) {
-			DPRINTK(("autofs: signaling expire on %s\n", ent->name));
+			DPRINTK(("autofs: signaling expire on %s\n",
+								ent->name));
 			return ent; /* Expirable! */
 		}
-		DPRINTK(("autofs: didn't expire due to may_umount: %s\n", ent->name));
+
+		DPRINTK(("autofs: didn't expire due to may_umount: %s\n",
+								ent->name));
 	}
 	return NULL;		/* No expirable entries */
 }
 
-void autofs_initialize_hash(struct autofs_dirhash *dh) {
+void autofs_initialize_hash(struct autofs_dirhash *dh)
+{
 	memset(&dh->h, 0, AUTOFS_HASH_SIZE*sizeof(struct autofs_dir_ent *));
 	INIT_LIST_HEAD(&dh->expiry_head);
 }
 
-struct autofs_dir_ent *autofs_hash_lookup(const struct autofs_dirhash *dh, struct qstr *name)
+struct autofs_dir_ent *autofs_hash_lookup(const struct autofs_dirhash *dh,
+						struct qstr *name)
 {
 	struct autofs_dir_ent *dhn;
 
 	DPRINTK(("autofs_hash_lookup: hash = 0x%08x, name = ", name->hash));
-	autofs_say(name->name,name->len);
+	autofs_say(name->name, name->len);
 
-	for ( dhn = dh->h[(unsigned) name->hash % AUTOFS_HASH_SIZE] ; dhn ; dhn = dhn->next ) {
-		if ( name->hash == dhn->hash &&
+	for (dhn = dh->h[(unsigned) name->hash % AUTOFS_HASH_SIZE];
+		dhn;
+		dhn = dhn->next) {
+		if (name->hash == dhn->hash &&
 		     name->len == dhn->len &&
-		     !memcmp(name->name, dhn->name, name->len) )
+		     !memcmp(name->name, dhn->name, name->len))
 			break;
 	}
 
@@ -131,9 +142,9 @@ void autofs_hash_insert(struct autofs_dirhash *dh, struct autofs_dir_ent *ent)
 	struct autofs_dir_ent **dhnp;
 
 	DPRINTK(("autofs_hash_insert: hash = 0x%08x, name = ", ent->hash));
-	autofs_say(ent->name,ent->len);
+	autofs_say(ent->name, ent->len);
 
-	autofs_init_usage(dh,ent);
+	autofs_init_usage(dh, ent);
 	if (ent->dentry)
 		dget(ent->dentry);
 
@@ -141,19 +152,19 @@ void autofs_hash_insert(struct autofs_dirhash *dh, struct autofs_dir_ent *ent)
 	ent->next = *dhnp;
 	ent->back = dhnp;
 	*dhnp = ent;
-	if ( ent->next )
+	if (ent->next)
 		ent->next->back = &(ent->next);
 }
 
 void autofs_hash_delete(struct autofs_dir_ent *ent)
 {
 	*(ent->back) = ent->next;
-	if ( ent->next )
+	if (ent->next)
 		ent->next->back = ent->back;
 
 	autofs_delete_usage(ent);
 
-	if ( ent->dentry )
+	if (ent->dentry)
 		dput(ent->dentry);
 	kfree(ent->name);
 	kfree(ent);
@@ -176,37 +187,37 @@ struct autofs_dir_ent *autofs_hash_enum(const struct autofs_dirhash *dh,
 	bucket = (*ptr >> 16) - 1;
 	ecount = *ptr & 0xffff;
 
-	if ( bucket < 0 ) {
+	if (bucket < 0)
 		bucket = ecount = 0;
-	} 
 
 	DPRINTK(("autofs_hash_enum: bucket %d, entry %d\n", bucket, ecount));
 
 	ent = last ? last->next : NULL;
 
-	if ( ent ) {
+	if (ent) {
 		ecount++;
 	} else {
-		while  ( bucket < AUTOFS_HASH_SIZE ) {
+		while  (bucket < AUTOFS_HASH_SIZE) {
 			ent = dh->h[bucket];
-			for ( i = ecount ; ent && i ; i-- )
+			for (i = ecount ; ent && i ; i--)
 				ent = ent->next;
-			
+
 			if (ent) {
 				ecount++; /* Point to *next* entry */
 				break;
 			}
-			
+
 			bucket++; ecount = 0;
 		}
 	}
 
 #ifdef DEBUG
-	if ( !ent )
-		printk("autofs_hash_enum: nothing found\n");
+	if (!ent)
+		printk(KERN_DEBUG "autofs_hash_enum: nothing found\n");
 	else {
-		printk("autofs_hash_enum: found hash %08x, name", ent->hash);
-		autofs_say(ent->name,ent->len);
+		printk(KERN_DEBUG "autofs_hash_enum: found hash %08x, name",
+								ent->hash);
+		autofs_say(ent->name, ent->len);
 	}
 #endif
 
@@ -221,9 +232,9 @@ void autofs_hash_dputall(struct autofs_dirhash *dh)
 	int i;
 	struct autofs_dir_ent *ent;
 
-	for ( i = 0 ; i < AUTOFS_HASH_SIZE ; i++ ) {
-		for ( ent = dh->h[i] ; ent ; ent = ent->next ) {
-			if ( ent->dentry ) {
+	for (i = 0 ; i < AUTOFS_HASH_SIZE ; i++) {
+		for (ent = dh->h[i] ; ent ; ent = ent->next) {
+			if (ent->dentry) {
 				dput(ent->dentry);
 				ent->dentry = NULL;
 			}
@@ -238,10 +249,10 @@ void autofs_hash_nuke(struct autofs_sb_info *sbi)
 	int i;
 	struct autofs_dir_ent *ent, *nent;
 
-	for ( i = 0 ; i < AUTOFS_HASH_SIZE ; i++ ) {
-		for ( ent = sbi->dirhash.h[i] ; ent ; ent = nent ) {
+	for (i = 0 ; i < AUTOFS_HASH_SIZE ; i++) {
+		for (ent = sbi->dirhash.h[i] ; ent ; ent = nent) {
 			nent = ent->next;
-			if ( ent->dentry )
+			if (ent->dentry)
 				dput(ent->dentry);
 			kfree(ent->name);
 			kfree(ent);
-- 
1.7.1

