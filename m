Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657Ab0FEQFH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 12:05:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48515 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933637Ab0FEQFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 12:05:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=urKlyTrH6Tj5dDv1AUnitpFPhJXVYtCMmxpcId0eO7npH10G2gYVWlsIzETA9aTcRp
         +djcGVE34rBH69Uf59ZN7aum7OVS8peGVHTeF10tBLi0IYiGDfgthg3gXxVw0QCy1mIj
         l57l8MZympbZMT7ur766oodfdHEj+xUFfnY94=
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Cc: linux-kernel@vger.kernel.org,
       Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: [PATCH 1/7] Remove linux version ifdef.
Date: Sat,  5 Jun 2010 18:04:19 +0200
Message-Id: <1275753865-5435-2-git-send-email-riccardo.magliocchetti@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275753865-5435-1-git-send-email-riccardo.magliocchetti@gmail.com>
References: <1275753865-5435-1-git-send-email-riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
---
 drivers/staging/xgifb/XGI_accel.c   |  215 -----------------------------------
 drivers/staging/xgifb/XGI_accel.h   |   13 --
 drivers/staging/xgifb/XGI_main.h    |  116 +------------------
 drivers/staging/xgifb/XGI_main_26.c |   28 -----
 drivers/staging/xgifb/vb_ext.c      |    5 -
 drivers/staging/xgifb/vb_init.c     |    5 -
 drivers/staging/xgifb/vb_setmode.c  |    6 -
 7 files changed, 2 insertions(+), 386 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_accel.c b/drivers/staging/xgifb/XGI_accel.c
index 86ec342..c42b00d 100644
--- a/drivers/staging/xgifb/XGI_accel.c
+++ b/drivers/staging/xgifb/XGI_accel.c
@@ -16,7 +16,6 @@
  */
 
 //#include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -37,27 +36,12 @@
 #include <linux/agp_backend.h>
 
 #include <linux/types.h>
-/*
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-#include <linux/XGIfb.h>
-#else
-#include <video/XGIfb.h>
-#endif
-*/
 #include <asm/io.h>
 
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
 #endif
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-#include <video/fbcon.h>
-#include <video/fbcon-cfb8.h>
-#include <video/fbcon-cfb16.h>
-#include <video/fbcon-cfb24.h>
-#include <video/fbcon-cfb32.h>
-#endif
-
 #include "osdef.h"
 #include "vgatypes.h"
 #include "vb_struct.h"
@@ -108,11 +92,9 @@ static const int XGIPatALUConv[] =
     0xFF,       /* dest = 0xFF;         1,      GXset,          0xF */
 };
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,34)
 static const unsigned char myrops[] = {
    	3, 10, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
    };
-#endif
 
 /* 300 series */
 #if 0
@@ -326,8 +308,6 @@ void XGIfb_syncaccel(void)
 
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,34)  /* --- KERNEL 2.5.34 and later --- */
-
 int fbcon_XGI_sync(struct fb_info *info)
 {
     if(!XGIfb_accel) return 0;
@@ -399,198 +379,3 @@ void fbcon_XGI_copyarea(struct fb_info *info, const struct fb_copyarea *area)
 
 }
 
-#endif
-
-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,33)  /* ------ KERNEL <2.5.34 ------ */
-
-void fbcon_XGI_bmove(struct display *p, int srcy, int srcx,
-			    int dsty, int dstx, int height, int width)
-{
-        int xdir, ydir;
-	CRITFLAGS
-
-	if(!xgi_video_info.accel) {
-	    switch(xgi_video_info.video_bpp) {
-	    case 8:
-#ifdef FBCON_HAS_CFB8
-	       fbcon_cfb8_bmove(p, srcy, srcx, dsty, dstx, height, width);
-#endif
-	       break;
-	    case 16:
-#ifdef FBCON_HAS_CFB16
-	       fbcon_cfb16_bmove(p, srcy, srcx, dsty, dstx, height, width);
-#endif
-	       break;
-	    case 32:
-#ifdef FBCON_HAS_CFB32
-	       fbcon_cfb32_bmove(p, srcy, srcx, dsty, dstx, height, width);
-#endif
-	       break;
-            }
-	    return;
-	}
-
-	srcx *= fontwidth(p);
-	srcy *= fontheight(p);
-	dstx *= fontwidth(p);
-	dsty *= fontheight(p);
-	width *= fontwidth(p);
-	height *= fontheight(p);
-
-	if(srcx < dstx) xdir = 0;
-	else            xdir = 1;
-	if(srcy < dsty) ydir = 0;
-	else            ydir = 1;
-
-
-	   CRITBEGIN
-	   XGI310SetupForScreenToScreenCopy(xdir, ydir, 3, 0, -1);
-	   XGI310SubsequentScreenToScreenCopy(srcx, srcy, dstx, dsty, width, height);
-	   CRITEND
-	   XGI310Sync();
-#if 0
-	   printk(KERN_INFO "XGI_bmove sx %d sy %d dx %d dy %d w %d h %d\n",
-		srcx, srcy, dstx, dsty, width, height);
-#endif
-
-}
-
-
-static void fbcon_XGI_clear(struct vc_data *conp, struct display *p,
-			int srcy, int srcx, int height, int width, int color)
-{
-	CRITFLAGS
-
-	srcx *= fontwidth(p);
-	srcy *= fontheight(p);
-	width *= fontwidth(p);
-	height *= fontheight(p);
-
-
-	   CRITBEGIN
-	   XGI310SetupForSolidFill(color, 3, 0);
-	   XGI310SubsequentSolidFillRect(srcx, srcy, width, height);
-	   CRITEND
-	   XGI310Sync();
-
-}
-
-void fbcon_XGI_clear8(struct vc_data *conp, struct display *p,
-			int srcy, int srcx, int height, int width)
-{
-	u32 bgx;
-
-	if(!xgi_video_info.accel) {
-#ifdef FBCON_HAS_CFB8
-	    fbcon_cfb8_clear(conp, p, srcy, srcx, height, width);
-#endif
-	    return;
-	}
-
-	bgx = attr_bgcol_ec(p, conp);
-	fbcon_XGI_clear(conp, p, srcy, srcx, height, width, bgx);
-}
-
-void fbcon_XGI_clear16(struct vc_data *conp, struct display *p,
-			int srcy, int srcx, int height, int width)
-{
-	u32 bgx;
-	if(!xgi_video_info.accel) {
-#ifdef FBCON_HAS_CFB16
-	    fbcon_cfb16_clear(conp, p, srcy, srcx, height, width);
-#endif
-	    return;
-	}
-
-	bgx = ((u_int16_t*)p->dispsw_data)[attr_bgcol_ec(p, conp)];
-	fbcon_XGI_clear(conp, p, srcy, srcx, height, width, bgx);
-}
-
-void fbcon_XGI_clear32(struct vc_data *conp, struct display *p,
-			int srcy, int srcx, int height, int width)
-{
-	u32 bgx;
-
-	if(!xgi_video_info.accel) {
-#ifdef FBCON_HAS_CFB32
-	    fbcon_cfb32_clear(conp, p, srcy, srcx, height, width);
-#endif
-	    return;
-	}
-
-	bgx = ((u_int32_t*)p->dispsw_data)[attr_bgcol_ec(p, conp)];
-	fbcon_XGI_clear(conp, p, srcy, srcx, height, width, bgx);
-}
-
-void fbcon_XGI_revc(struct display *p, int srcx, int srcy)
-{
-	CRITFLAGS
-
-	if(!xgi_video_info.accel) {
-	    switch(xgi_video_info.video_bpp) {
-	    case 16:
-#ifdef FBCON_HAS_CFB16
-	       fbcon_cfb16_revc(p, srcx, srcy);
-#endif
-	       break;
-	    case 32:
-#ifdef FBCON_HAS_CFB32
-	       fbcon_cfb32_revc(p, srcx, srcy);
-#endif
-	       break;
-            }
-	    return;
-	}
-
-	srcx *= fontwidth(p);
-	srcy *= fontheight(p);
-
-
-	   CRITBEGIN
-	   XGI310SetupForSolidFill(0, 0x0a, 0);
-	   XGI310SubsequentSolidFillRect(srcx, srcy, fontwidth(p), fontheight(p));
-	   CRITEND
-	   XGI310Sync();
-
-}
-
-#ifdef FBCON_HAS_CFB8
-struct display_switch fbcon_XGI8 = {
-	setup:			fbcon_cfb8_setup,
-	bmove:			fbcon_XGI_bmove,
-	clear:			fbcon_XGI_clear8,
-	putc:			fbcon_cfb8_putc,
-	putcs:			fbcon_cfb8_putcs,
-	revc:			fbcon_cfb8_revc,
-	clear_margins:		fbcon_cfb8_clear_margins,
-	fontwidthmask:		FONTWIDTH(4)|FONTWIDTH(8)|FONTWIDTH(12)|FONTWIDTH(16)
-};
-#endif
-#ifdef FBCON_HAS_CFB16
-struct display_switch fbcon_XGI16 = {
-	setup:			fbcon_cfb16_setup,
-	bmove:			fbcon_XGI_bmove,
-	clear:			fbcon_XGI_clear16,
-	putc:			fbcon_cfb16_putc,
-	putcs:			fbcon_cfb16_putcs,
-	revc:			fbcon_XGI_revc,
-	clear_margins:		fbcon_cfb16_clear_margins,
-	fontwidthmask:		FONTWIDTH(4)|FONTWIDTH(8)|FONTWIDTH(12)|FONTWIDTH(16)
-};
-#endif
-#ifdef FBCON_HAS_CFB32
-struct display_switch fbcon_XGI32 = {
-	setup:			fbcon_cfb32_setup,
-	bmove:			fbcon_XGI_bmove,
-	clear:			fbcon_XGI_clear32,
-	putc:			fbcon_cfb32_putc,
-	putcs:			fbcon_cfb32_putcs,
-	revc:			fbcon_XGI_revc,
-	clear_margins:		fbcon_cfb32_clear_margins,
-	fontwidthmask:		FONTWIDTH(4)|FONTWIDTH(8)|FONTWIDTH(12)|FONTWIDTH(16)
-};
-#endif
-
-#endif /* KERNEL VERSION */
-
-
diff --git a/drivers/staging/xgifb/XGI_accel.h b/drivers/staging/xgifb/XGI_accel.h
index 04e1267..090d693 100644
--- a/drivers/staging/xgifb/XGI_accel.h
+++ b/drivers/staging/xgifb/XGI_accel.h
@@ -491,21 +491,8 @@ void XGIfb_syncaccel(void);
 
 extern struct video_info xgi_video_info;
 
-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,33)
-void fbcon_XGI_bmove(struct display *p, int srcy, int srcx, int dsty,
-                     int dstx, int height, int width);
-void fbcon_XGI_revc(struct display *p, int srcy, int srcx);
-void fbcon_XGI_clear8(struct vc_data *conp, struct display *p, int srcy,
-                      int srcx, int height, int width);
-void fbcon_XGI_clear16(struct vc_data *conp, struct display *p, int srcy,
-                       int srcx, int height, int width);
-void fbcon_XGI_clear32(struct vc_data *conp, struct display *p, int srcy,
-                       int srcx, int height, int width);
-#endif
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,34)
 extern int XGIfb_accel;
 void fbcon_XGI_fillrect(struct fb_info *info, const struct fb_fillrect *rect);
 void fbcon_XGI_copyarea(struct fb_info *info, const struct fb_copyarea *area);
-#endif
 
 #endif
diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index 4f4171e..6d3a870 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -42,17 +42,10 @@
 
 
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,8)
 #define XGI_IOTYPE1 void __iomem
 #define XGI_IOTYPE2 __iomem
 #define XGIINITSTATIC static
-#else
-#define XGI_IOTYPE1 unsigned char
-#define XGI_IOTYPE2
-#define XGIINITSTATIC
-#endif
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 static struct pci_device_id __devinitdata xgifb_pci_table[] = {
 
 	{ PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
@@ -63,7 +56,7 @@ static struct pci_device_id __devinitdata xgifb_pci_table[] = {
 };
 
 MODULE_DEVICE_TABLE(pci, xgifb_pci_table);
-#endif
+
 /* To be included in fb.h */
 #ifndef FB_ACCEL_XGI_GLAMOUR_2
 #define FB_ACCEL_XGI_GLAMOUR_2  40	/* XGI 315, 650, 740		*/
@@ -300,11 +293,7 @@ MODULE_DEVICE_TABLE(pci, xgifb_pci_table);
 /* ------------------- Global Variables ----------------------------- */
 
 /* Fbcon variables */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 static struct fb_info* fb_info;
-#else
-static struct fb_info XGI_fb_info;
-#endif
 
 
 static int    video_type = FB_TYPE_PACKED_PIXELS;
@@ -336,12 +325,8 @@ static struct fb_var_screeninfo default_var = {
 	.vsync_len	= 0,
 	.sync		= 0,
 	.vmode		= FB_VMODE_NONINTERLACED,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	.reserved	= {0, 0, 0, 0, 0, 0}
-#endif
 };
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 static struct fb_fix_screeninfo XGIfb_fix = {
 	.id		= "XGI",
 	.type		= FB_TYPE_PACKED_PIXELS,
@@ -350,28 +335,6 @@ static struct fb_fix_screeninfo XGIfb_fix = {
 };
 static char myid[20];
 static u32 pseudo_palette[17];
-#endif
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-static struct display XGI_disp;
-
-static struct display_switch XGIfb_sw;
-
-static struct {
-	u16 blue, green, red, pad;
-} XGI_palette[256];
-
-static union {
-#ifdef FBCON_HAS_CFB16
-	u16 cfb16[16];
-#endif
-#ifdef FBCON_HAS_CFB32
-	u32 cfb32[16];
-#endif
-} XGI_fbcon_cmap;
-
-static int XGIfb_inverse = 0;
-#endif
 
 /* display status */
 static int XGIfb_off = 0;
@@ -380,9 +343,6 @@ static int XGIfb_forcecrt1 = -1;
 static int XGIvga_enabled = 0;
 static int XGIfb_userom = 0;
 //static int XGIfb_useoem = -1;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-static int currcon = 0;
-#endif
 
 /* global flags */
 static int XGIfb_registered;
@@ -530,17 +490,9 @@ struct _XGIbios_mode {
 
 /* mode-related variables */
 #ifdef MODULE
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 static int xgifb_mode_idx = 1;
 #else
-static int XGIfb_mode_idx = MODE_INDEX_NONE;  /* Don't use a mode by default if we are a module */
-#endif
-#else
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 static int xgifb_mode_idx = -1;               /* Use a default mode if we are inside the kernel */
-#else
-static int XGIfb_mode_idx = -1;
-#endif
 #endif
 u8  XGIfb_mode_no  = 0;
 u8  XGIfb_rate_idx = 0;
@@ -648,17 +600,6 @@ static const struct _chswtable {
 	{ 0,      0,      ""       , ""       }
 };
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-/* Offscreen layout */
-typedef struct _XGI_GLYINFO {
-	unsigned char ch;
-	int fontwidth;
-	int fontheight;
-	u8 gmask[72];
-	int ngmask;
-} XGI_GLYINFO;
-#endif
-
 typedef struct _XGI_OH {
 	struct _XGI_OH *poh_next;
 	struct _XGI_OH *poh_prev;
@@ -851,51 +792,6 @@ XGIINITSTATIC int __init XGIfb_setup(char *options);
 
 
 
-/* fbdev routines */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-       int	XGIfb_init(void);
-static int      XGIfb_get_fix(struct fb_fix_screeninfo *fix,
-			      int con,
-			      struct fb_info *info);
-static int      XGIfb_get_var(struct fb_var_screeninfo *var,
-			      int con,
-			      struct fb_info *info);
-static int      XGIfb_set_var(struct fb_var_screeninfo *var,
-			      int con,
-			      struct fb_info *info);
-static void     XGIfb_crtc_to_var(struct fb_var_screeninfo *var);
-static int      XGIfb_get_cmap(struct fb_cmap *cmap,
-			       int kspc,
-			       int con,
-			       struct fb_info *info);
-static int      XGIfb_set_cmap(struct fb_cmap *cmap,
-			       int kspc,
-			       int con,
-			       struct fb_info *info);
-static int      XGIfb_update_var(int con,
-				 struct fb_info *info);
-static int      XGIfb_switch(int con,
-			     struct fb_info *info);
-static void     XGIfb_blank(int blank,
-			    struct fb_info *info);
-static void     XGIfb_set_disp(int con,
-			       struct fb_var_screeninfo *var,
-                               struct fb_info *info);
-static int      XGI_getcolreg(unsigned regno, unsigned *red, unsigned *green,
-			      unsigned *blue, unsigned *transp,
-			      struct fb_info *fb_info);
-static void     XGIfb_do_install_cmap(int con,
-                                      struct fb_info *info);
-static void     XGI_get_glyph(struct fb_info *info,
-                              XGI_GLYINFO *gly);
-static int 	XGIfb_mmap(struct fb_info *info, struct file *file,
-		           struct vm_area_struct *vma);
-static int      XGIfb_ioctl(struct inode *inode, struct file *file,
-		       	    unsigned int cmd, unsigned long arg, int con,
-		       	    struct fb_info *info);
-#endif
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 XGIINITSTATIC int __init xgifb_init(void);
 static int      XGIfb_set_par(struct fb_info *info);
 static int      XGIfb_blank(int blank,
@@ -913,16 +809,8 @@ extern void     cfb_imageblit(struct fb_info *info,
 #endif
 extern int      fbcon_XGI_sync(struct fb_info *info);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,15)
 static int XGIfb_ioctl(struct fb_info *info, unsigned int cmd,
 			    unsigned long arg);
-#else
-static int      XGIfb_ioctl(struct inode *inode,
-	 		    struct file *file,
-		       	    unsigned int cmd,
-			    unsigned long arg,
-		       	    struct fb_info *info);
-#endif
 
 /*
 extern int	XGIfb_mode_rate_to_dclock(VB_DEVICE_INFO *XGI_Pr,
@@ -935,7 +823,7 @@ extern int      XGIfb_mode_rate_to_ddata(VB_DEVICE_INFO *XGI_Pr, PXGI_HW_DEVICE_
 			 unsigned int *hsync_len, unsigned int *vsync_len,
 			 unsigned int *sync, unsigned int *vmode);
 */
-#endif
+
 			extern   BOOLEAN  XGI_SearchModeID( USHORT ModeNo,USHORT  *ModeIdIndex, PVB_DEVICE_INFO );
 static int      XGIfb_get_fix(struct fb_fix_screeninfo *fix, int con,
 			      struct fb_info *info);
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 867012b..8681e0f 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1350,11 +1350,7 @@ static int XGIfb_set_par(struct fb_info *info)
 //	printk("XGIfb: inside set_par\n");
         if((err = XGIfb_do_set_var(&info->var, 1, info)))
 		return err;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,10)
-	XGIfb_get_fix(&info->fix, info->currcon, info);
-#else
 	XGIfb_get_fix(&info->fix, -1, info);
-#endif
 //	printk("XGIfb:end of set_par\n");
 	return 0;
 }
@@ -1610,15 +1606,8 @@ static int XGIfb_blank(int blank, struct fb_info *info)
 }
 
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,15)
 static int XGIfb_ioctl(struct fb_info *info, unsigned int cmd,
 			    unsigned long arg)
-#else
-static int XGIfb_ioctl(struct inode *inode, struct file *file,
-		       unsigned int cmd, unsigned long arg,
-		       struct fb_info *info)
-#endif
-
 {
 	DEBUGPRN("inside ioctl");
 	switch (cmd) {
@@ -1786,9 +1775,6 @@ static struct fb_ops XGIfb_ops = {
 	.fb_fillrect  = fbcon_XGI_fillrect,
 	.fb_copyarea  = fbcon_XGI_copyarea,
 	.fb_imageblit = cfb_imageblit,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,15)
-	.fb_cursor    = soft_cursor,
-#endif
 	.fb_sync      = fbcon_XGI_sync,
 	.fb_ioctl     =	XGIfb_ioctl,
 //	.fb_mmap      =	XGIfb_mmap,
@@ -2963,14 +2949,8 @@ int __devinit xgifb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	XGIfb_registered = 0;
 
 	memset(&XGIhw_ext, 0, sizeof(HW_DEVICE_EXTENSION));
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,3))
 	  fb_info = framebuffer_alloc(sizeof(struct fb_info), &pdev->dev);
 	  if(!fb_info) return -ENOMEM;
-#else
-	  XGI_fb_info = kmalloc( sizeof(struct fb_info), GFP_KERNEL);
-	  if(!XGI_fb_info) return -ENOMEM;
-	  memset(XGI_fb_info, 0,  sizeof(struct fb_info));
-#endif
 
   	xgi_video_info.chip_id = pdev->device;
 	  pci_read_config_byte(pdev, PCI_REVISION_ID,&xgi_video_info.revision_id);
@@ -3538,11 +3518,7 @@ static void __devexit xgifb_remove(struct pci_dev *pdev)
 	/* Unregister the framebuffer */
 //	if(xgi_video_info.registered) {
 		unregister_framebuffer(fb_info);
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,3))
 		framebuffer_release(fb_info);
-#else
-		kfree(fb_info);
-#endif
 //	}
 
 	pci_set_drvdata(pdev, NULL);
@@ -3558,7 +3534,6 @@ static struct pci_driver xgifb_driver = {
 
 XGIINITSTATIC int __init xgifb_init(void)
 {
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,8)
 #ifndef MODULE
 	char *option = NULL;
 
@@ -3566,15 +3541,12 @@ XGIINITSTATIC int __init xgifb_init(void)
 		return -ENODEV;
 	XGIfb_setup(option);
 #endif
-#endif
 	return(pci_register_driver(&xgifb_driver));
 }
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,8)
 #ifndef MODULE
 module_init(xgifb_init);
 #endif
-#endif
 
 /*****************************************************/
 /*                      MODULE                       */
diff --git a/drivers/staging/xgifb/vb_ext.c b/drivers/staging/xgifb/vb_ext.c
index 49b39ee..91568fa 100644
--- a/drivers/staging/xgifb/vb_ext.c
+++ b/drivers/staging/xgifb/vb_ext.c
@@ -27,11 +27,6 @@
 #include <asm/io.h>
 #include <linux/types.h>
 #include "XGIfb.h"
-/*#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-#include <video/XGIfb.h>
-#else
-#include <linux/XGIfb.h>
-#endif*/
 #endif
 
 
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index b85ca9b..66405f7 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -7,11 +7,6 @@
 #include <linux/types.h>
 #include <linux/delay.h> /* udelay */
 #include "XGIfb.h"
-/*#if LINUX_VERSxION_CODE >= KERNEL_VERSION(2,5,0)
-#include <video/XGIfb.h>
-#else
-#include <linux/XGIfb.h>
-#endif */
 #endif
 
 #ifdef WIN2000
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index bd7f738..1b5fecf 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -18,13 +18,7 @@
 #ifdef LINUX_KERNEL
 #include <asm/io.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include "XGIfb.h"
-/*#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-#include <video/XGIfb.h>
-#else
-#include <linux/XGIfb.h>
-#endif*/
 #endif
 
 #ifdef WIN2000
-- 
1.7.1

