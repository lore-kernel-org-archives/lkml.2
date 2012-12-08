Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631Ab2LHBlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 20:41:55 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:45109 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757612Ab2LHBlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 20:41:53 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Cong Ding <dinggnu@gmail.com>
Subject: [PATCH 2/2] tty: remove trailing spaces in tty/vt
Date: Sat,  8 Dec 2012 01:41:24 +0000
Message-Id: <1354930884-20913-2-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
In-Reply-To: <1354930884-20913-1-git-send-email-dinggnu@gmail.com>
References: <1354930884-20913-1-git-send-email-dinggnu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove trailing blank spaces in tty/vt by shell command:
sed 's/\s\+$//g' -i

I have manually reviewed that everything is correct.


Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/tty/vt/consolemap.c |   62 +++++++++++++++++++++---------------------
 drivers/tty/vt/keyboard.c   |    4 +-
 drivers/tty/vt/vc_screen.c  |    2 +-
 drivers/tty/vt/vt.c         |   14 +++++-----
 drivers/tty/vt/vt_ioctl.c   |   24 ++++++++--------
 5 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/tty/vt/consolemap.c b/drivers/tty/vt/consolemap.c
index 248381b..ffb5855 100644
--- a/drivers/tty/vt/consolemap.c
+++ b/drivers/tty/vt/consolemap.c
@@ -58,7 +58,7 @@ static unsigned short translations[][256] = {
     0x00e8, 0x00e9, 0x00ea, 0x00eb, 0x00ec, 0x00ed, 0x00ee, 0x00ef,
     0x00f0, 0x00f1, 0x00f2, 0x00f3, 0x00f4, 0x00f5, 0x00f6, 0x00f7,
     0x00f8, 0x00f9, 0x00fa, 0x00fb, 0x00fc, 0x00fd, 0x00fe, 0x00ff
-  }, 
+  },
   /* VT100 graphics mapped to Unicode */
   {
     0x0000, 0x0001, 0x0002, 0x0003, 0x0004, 0x0005, 0x0006, 0x0007,
@@ -96,7 +96,7 @@ static unsigned short translations[][256] = {
   },
   /* IBM Codepage 437 mapped to Unicode */
   {
-    0x0000, 0x263a, 0x263b, 0x2665, 0x2666, 0x2663, 0x2660, 0x2022, 
+    0x0000, 0x263a, 0x263b, 0x2665, 0x2666, 0x2663, 0x2660, 0x2022,
     0x25d8, 0x25cb, 0x25d9, 0x2642, 0x2640, 0x266a, 0x266b, 0x263c,
     0x25b6, 0x25c0, 0x2195, 0x203c, 0x00b6, 0x00a7, 0x25ac, 0x21a8,
     0x2191, 0x2193, 0x2192, 0x2190, 0x221f, 0x2194, 0x25b2, 0x25bc,
@@ -128,7 +128,7 @@ static unsigned short translations[][256] = {
     0x03a6, 0x0398, 0x03a9, 0x03b4, 0x221e, 0x03c6, 0x03b5, 0x2229,
     0x2261, 0x00b1, 0x2265, 0x2264, 0x2320, 0x2321, 0x00f7, 0x2248,
     0x00b0, 0x2219, 0x00b7, 0x221a, 0x207f, 0x00b2, 0x25a0, 0x00a0
-  }, 
+  },
   /* User mapping -- default to codes for direct font mapping */
   {
     0xf000, 0xf001, 0xf002, 0xf003, 0xf004, 0xf005, 0xf006, 0xf007,
@@ -189,12 +189,12 @@ static void set_inverse_transl(struct vc_data *conp, struct uni_pagedir *p, int
 	int j, glyph;
 	unsigned short *t = translations[i];
 	unsigned char *q;
-	
+
 	if (!p) return;
 	q = p->inverse_translations[i];
 
 	if (!q) {
-		q = p->inverse_translations[i] = (unsigned char *) 
+		q = p->inverse_translations[i] = (unsigned char *)
 			kmalloc(MAX_GLYPH, GFP_KERNEL);
 		if (!q) return;
 	}
@@ -284,7 +284,7 @@ static void update_user_maps(void)
 {
 	int i;
 	struct uni_pagedir *p, *q = NULL;
-	
+
 	for (i = 0; i < MAX_NR_CONSOLES; i++) {
 		if (!vc_cons_allocated(i))
 			continue;
@@ -375,12 +375,12 @@ int con_get_trans_new(ushort __user * arg)
 	for (i=0; i<E_TABSZ ; i++)
 	  __put_user(p[i], arg+i);
 	console_unlock();
-	
+
 	return 0;
 }
 
 /*
- * Unicode -> current font conversion 
+ * Unicode -> current font conversion
  *
  * A font has at most 512 chars, usually 256.
  * But one font position may represent several Unicode chars.
@@ -397,7 +397,7 @@ static void con_release_unimap(struct uni_pagedir *p)
 	u16 **p1;
 	int i, j;
 
-	if (p == dflt) dflt = NULL;  
+	if (p == dflt) dflt = NULL;
 	for (i = 0; i < 32; i++) {
 		if ((p1 = p->uni_pgdir[i]) != NULL) {
 			for (j = 0; j < 32; j++)
@@ -428,12 +428,12 @@ void con_free_unimap(struct vc_data *vc)
 	con_release_unimap(p);
 	kfree(p);
 }
-  
+
 static int con_unify_unimap(struct vc_data *conp, struct uni_pagedir *p)
 {
 	int i, j, k;
 	struct uni_pagedir *q;
-	
+
 	for (i = 0; i < MAX_NR_CONSOLES; i++) {
 		if (!vc_cons_allocated(i))
 			continue;
@@ -489,7 +489,7 @@ con_insert_unipair(struct uni_pagedir *p, u_short unicode, u_short fontpos)
 	}
 
 	p2[unicode & 0x3f] = fontpos;
-	
+
 	p->sum += (fontpos << 20) + unicode;
 
 	return 0;
@@ -531,7 +531,7 @@ int con_clear_unimap(struct vc_data *vc, struct unimapinit *ui)
 	console_unlock();
 	return ret;
 }
-	
+
 int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list)
 {
 	int err = 0, err1, i;
@@ -545,22 +545,22 @@ int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list)
 		console_unlock();
 		return -EIO;
 	}
-	
+
 	if (!ct) {
 		console_unlock();
 		return 0;
 	}
-	
+
 	if (p->refcount > 1) {
 		int j, k;
 		u16 **p1, *p2, l;
-		
+
 		err1 = con_do_clear_unimap(vc, NULL);
 		if (err1) {
 			console_unlock();
 			return err1;
 		}
-		
+
 		/*
 		 * Since refcount was > 1, con_clear_unimap() allocated a
 		 * a new uni_pagedir for this vc.  Re: p != q
@@ -591,7 +591,7 @@ int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list)
 						con_release_unimap(q);
 						kfree(q);
 						console_unlock();
-						return err1; 
+						return err1;
 					}
 				}
 			} else {
@@ -621,7 +621,7 @@ int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list)
 			err = err1;
 		list++;
 	}
-	
+
 	/*
 	 * Merge with fontmaps of any other virtual consoles.
 	 */
@@ -645,7 +645,7 @@ int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list)
  *	Loads the unimap for the hardware font, as defined in uni_hash.tbl.
  *	The representation used was the most compact I could come up
  *	with.  This routine is executed at video setup, and when the
- *	PIO_FONTRESET ioctl is called. 
+ *	PIO_FONTRESET ioctl is called.
  *
  *	The caller must hold the console lock
  */
@@ -668,23 +668,23 @@ int con_set_default_unimap(struct vc_data *vc)
 		}
 		return 0;
 	}
-	
+
 	/* The default font is always 256 characters */
 
 	err = con_do_clear_unimap(vc, NULL);
 	if (err)
 		return err;
-    
+
 	p = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
 	q = dfont_unitable;
-	
+
 	for (i = 0; i < 256; i++)
 		for (j = dfont_unicount[i]; j; j--) {
 			err1 = con_insert_unipair(p, *(q++), i);
 			if (err1)
 				err = err1;
 		}
-			
+
 	if (con_unify_unimap(vc, p)) {
 		dflt = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
 		return err;
@@ -747,7 +747,7 @@ int con_get_unimap(struct vc_data *vc, ushort ct, ushort __user *uct, struct uni
 					if (*p2 < MAX_GLYPH && ect++ < ct) {
 						__put_user((u_short)((i<<11)+(j<<6)+k),
 							   &list->unicode);
-						__put_user((u_short) *p2, 
+						__put_user((u_short) *p2,
 							   &list->fontpos);
 						list++;
 					}
@@ -787,12 +787,12 @@ int conv_uni_to_8bit(u32 uni)
 }
 
 int
-conv_uni_to_pc(struct vc_data *conp, long ucs) 
+conv_uni_to_pc(struct vc_data *conp, long ucs)
 {
 	int h;
 	u16 **p1, *p2;
 	struct uni_pagedir *p;
-  
+
 	/* Only 16-bit codes supported at this time */
 	if (ucs > 0xffff)
 		return -4;		/* Not found */
@@ -807,11 +807,11 @@ conv_uni_to_pc(struct vc_data *conp, long ucs)
 	 */
 	else if ((ucs & ~UNI_DIRECT_MASK) == UNI_DIRECT_BASE)
 		return ucs & UNI_DIRECT_MASK;
-  
+
 	if (!*conp->vc_uni_pagedir_loc)
 		return -3;
 
-	p = (struct uni_pagedir *)*conp->vc_uni_pagedir_loc;  
+	p = (struct uni_pagedir *)*conp->vc_uni_pagedir_loc;
 	if ((p1 = p->uni_pgdir[ucs >> 11]) &&
 	    (p2 = p1[(ucs >> 6) & 0x1f]) &&
 	    (h = p2[ucs & 0x3f]) < MAX_GLYPH)
@@ -825,11 +825,11 @@ conv_uni_to_pc(struct vc_data *conp, long ucs)
  * initialized.  It must be possible to call kmalloc(..., GFP_KERNEL)
  * from this function, hence the call from sys_setup.
  */
-void __init 
+void __init
 console_map_init(void)
 {
 	int i;
-	
+
 	for (i = 0; i < MAX_NR_CONSOLES; i++)
 		if (vc_cons_allocated(i) && !*vc_cons[i].d->vc_uni_pagedir_loc)
 			con_set_default_unimap(vc_cons[i].d);
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 681765b..0946827 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1127,7 +1127,7 @@ static void kbd_bh(unsigned long dummy)
 {
 	unsigned char leds;
 	unsigned long flags;
-	
+
 	spin_lock_irqsave(&led_lock, flags);
 	leds = getleds();
 	spin_unlock_irqrestore(&led_lock, flags);
@@ -1687,7 +1687,7 @@ int vt_do_diacrit(unsigned int cmd, void __user *up, int perm)
 				kfree(buf);
 				return -EFAULT;
 			}
-		} 
+		}
 		spin_lock_irqsave(&kbd_event_lock, flags);
 		if (ct)
 			memcpy(accent_table, buf,
diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index fa7268a..9fde321 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -607,7 +607,7 @@ vcs_open(struct inode *inode, struct file *filp)
 {
 	unsigned int currcons = iminor(inode) & 127;
 	int ret = 0;
-	
+
 	console_lock();
 	if(currcons && !vc_cons_allocated(currcons-1))
 		ret = -ENXIO;
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 8fd8968..5778e8d 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -37,7 +37,7 @@
  *
  *     - Arno Griffioen <arno@usn.nl>
  *     - David Carter <carter@cs.bris.ac.uk>
- * 
+ *
  *   The abstract console driver provides a generic interface for a text
  *   console. It supports VGA text mode, frame buffer based graphical consoles
  *   and special graphics processors that are only accessible through some
@@ -282,7 +282,7 @@ static void notify_update(struct vc_data *vc)
 static inline unsigned short *screenpos(struct vc_data *vc, int offset, int viewed)
 {
 	unsigned short *p;
-	
+
 	if (!viewed)
 		p = (unsigned short *)(vc->vc_origin + offset);
 	else if (!vc->vc_sw->con_screen_pos)
@@ -3943,9 +3943,9 @@ void reset_palette(struct vc_data *vc)
  *  Font switching
  *
  *  Currently we only support fonts up to 32 pixels wide, at a maximum height
- *  of 32 pixels. Userspace fontdata is stored with 32 bytes (shorts/ints, 
- *  depending on width) reserved for each character which is kinda wasty, but 
- *  this is done in order to maintain compatibility with the EGA/VGA fonts. It 
+ *  of 32 pixels. Userspace fontdata is stored with 32 bytes (shorts/ints,
+ *  depending on width) reserved for each character which is kinda wasty, but
+ *  this is done in order to maintain compatibility with the EGA/VGA fonts. It
  *  is up to the actual low-level console-driver convert data into its favorite
  *  format (maybe we should add a `fontoffset' field to the `display'
  *  structure so we won't have to convert the fontdata all the time.
@@ -3984,7 +3984,7 @@ static int con_font_get(struct vc_data *vc, struct console_font_op *op)
 	if (op->data && font.charcount > op->charcount)
 		rc = -ENOSPC;
 	if (!(op->flags & KD_FONT_FLAG_OLD)) {
-		if (font.width > op->width || font.height > op->height) 
+		if (font.width > op->width || font.height > op->height)
 			rc = -ENOSPC;
 	} else {
 		if (font.width != 8)
@@ -4024,7 +4024,7 @@ static int con_font_set(struct vc_data *vc, struct console_font_op *op)
 		int h, i;
 		u8 __user *charmap = op->data;
 		u8 tmp;
-		
+
 		/* If from KDFONTOP ioctl, don't allow things which can be done in userland,
 		   so that we can get rid of this soon */
 		if (!(op->flags & KD_FONT_FLAG_OLD))
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 98ff173..bce5ffb 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -219,15 +219,15 @@ int vt_waitactive(int n)
 
 
 
-static inline int 
+static inline int
 do_fontx_ioctl(int cmd, struct consolefontdesc __user *user_cfd, int perm, struct console_font_op *op)
 {
 	struct consolefontdesc cfdarg;
 	int i;
 
-	if (copy_from_user(&cfdarg, user_cfd, sizeof(struct consolefontdesc))) 
+	if (copy_from_user(&cfdarg, user_cfd, sizeof(struct consolefontdesc)))
 		return -EFAULT;
- 	
+
 	switch (cmd) {
 	case PIO_FONTX:
 		if (!perm)
@@ -259,7 +259,7 @@ do_fontx_ioctl(int cmd, struct consolefontdesc __user *user_cfd, int perm, struc
 	return -EINVAL;
 }
 
-static inline int 
+static inline int
 do_unimap_ioctl(int cmd, struct unimapdesc __user *user_ud, int perm, struct vc_data *vc)
 {
 	struct unimapdesc tmp;
@@ -287,7 +287,7 @@ do_unimap_ioctl(int cmd, struct unimapdesc __user *user_ud, int perm, struct vc_
 
 /*
  * We handle the console-specific ioctl's here.  We allow the
- * capability to modify any console, not just the fg_console. 
+ * capability to modify any console, not just the fg_console.
  */
 int vt_ioctl(struct tty_struct *tty,
 	     unsigned int cmd, unsigned long arg)
@@ -317,7 +317,7 @@ int vt_ioctl(struct tty_struct *tty,
 	perm = 0;
 	if (current->signal->tty == tty || capable(CAP_SYS_TTY_CONFIG))
 		perm = 1;
- 
+
 	switch (cmd) {
 	case TIOCLINUX:
 		ret = tioclinux(tty, arg);
@@ -341,7 +341,7 @@ int vt_ioctl(struct tty_struct *tty,
 			return -EPERM;
 	{
 		unsigned int ticks, count;
-		
+
 		/*
 		 * Generate the tone for the appropriate number of ticks.
 		 * If the time is zero, turn off sound ourselves.
@@ -392,11 +392,11 @@ int vt_ioctl(struct tty_struct *tty,
 #endif
 
 	/* Linux m68k/i386 interface for setting the keyboard delay/repeat rate */
-		
+
 	case KDKBDREP:
 	{
 		struct kbd_repeat kbrep;
-		
+
 		if (!capable(CAP_SYS_TTY_CONFIG))
 			return -EPERM;
 
@@ -623,7 +623,7 @@ int vt_ioctl(struct tty_struct *tty,
 			if (! VT_IS_IN_USE(i))
 				break;
 		uival = i < MAX_NR_CONSOLES ? (i+1) : -1;
-		goto setint;		 
+		goto setint;
 
 	/*
 	 * ioctl(fd, VT_ACTIVATE, num) will cause us to switch to vt # num,
@@ -842,7 +842,7 @@ int vt_ioctl(struct tty_struct *tty,
 					ret = -EINVAL;
 					break;
 				}
-			} else 
+			} else
 				ll = vlin/clin;
 		}
 		if (vcol && ccol) {
@@ -859,7 +859,7 @@ int vt_ioctl(struct tty_struct *tty,
 			ret =  -EINVAL;
 			break;
 		}
-		    
+
 		for (i = 0; i < MAX_NR_CONSOLES; i++) {
 			if (!vc_cons[i].d)
 				continue;
-- 
1.7.4.5

