Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab1D1IdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:33:17 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58117 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab1D1IdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 04:33:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BcDC5r7d+STVXlNKlGVLeBQWbX+cJlgM+rDoZOzctvt3xFQAsLXW+oZW//9UGmlo6s
         LxSLB/za54ByKBFuCR1Fr8ChyrZCi9kApLo6A2TcLvor8p3jLMMTyPfV+5PCkqJ8I890
         z66a5pogzsjuOJmlzS6EDXswhg4q0UREavdIE=
From: Lifeng Sun <lifongsun@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Lifeng Sun <lifongsun@gmail.com>
Subject: [PATCH 4/5] char driver: inappropriate ioctl operation should return ENOTTY
Date: Thu, 28 Apr 2011 16:32:35 +0800
Message-Id: <1303979556-30494-1-git-send-email-lifongsun@gmail.com>
X-Mailer: git-send-email 1.7.5.rc1
In-Reply-To: <1303977891-29280-1-git-send-email-lifongsun@gmail.com>
References: <1303977891-29280-1-git-send-email-lifongsun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioctl() calls against a character special file with an inappropriate
ioctl operation are incorrectly returning EINVAL rather than ENOTTY:

  [ENOTTY]
      Inappropriate I/O control operation.

These drivers do not seem to be actively maintained from my brief
investigation. Apologies to the maintainers that I have missed.

Signed-off-by: Lifeng Sun <lifongsun@gmail.com>
---
 drivers/char/generic_nvram.c |    2 +-
 drivers/char/genrtc.c        |    2 +-
 drivers/char/lp.c            |    2 +-
 drivers/char/nwflash.c       |    2 +-
 drivers/char/ppdev.c         |    2 +-
 drivers/char/raw.c           |    4 ++--
 drivers/char/viotape.c       |   20 +++++++++++++++-----
 7 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/char/generic_nvram.c b/drivers/char/generic_nvram.c
index 0e941b5..95278e9 100644
--- a/drivers/char/generic_nvram.c
+++ b/drivers/char/generic_nvram.c
@@ -111,7 +111,7 @@ static int nvram_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		nvram_sync();
 		break;
 	default:
-		return -EINVAL;
+		return -ENOTTY;
 	}
 
 	return 0;
diff --git a/drivers/char/genrtc.c b/drivers/char/genrtc.c
index f773a9d..6f4c3da 100644
--- a/drivers/char/genrtc.c
+++ b/drivers/char/genrtc.c
@@ -330,7 +330,7 @@ static int gen_rtc_ioctl(struct file *file,
 	    }
 	}
 
-	return -EINVAL;
+	return -ENOTTY;
 }
 
 static long gen_rtc_unlocked_ioctl(struct file *file, unsigned int cmd,
diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index 97c3edb..2ff32c8 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -650,7 +650,7 @@ static int lp_do_ioctl(unsigned int minor, unsigned int cmd,
 			break;
 
 		default:
-			retval = -EINVAL;
+			retval = -ENOTTY;
 	}
 	return retval;
 }
diff --git a/drivers/char/nwflash.c b/drivers/char/nwflash.c
index a12f524..45b7a7a 100644
--- a/drivers/char/nwflash.c
+++ b/drivers/char/nwflash.c
@@ -115,7 +115,7 @@ static long flash_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		gbWriteBase64Enable = 0;
 		gbWriteEnable = 0;
 		mutex_unlock(&flash_mutex);
-		return -EINVAL;
+		return -ENOTTY;
 	}
 	mutex_unlock(&flash_mutex);
 	return 0;
diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
index f176dba..8dce214 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -622,7 +622,7 @@ static int pp_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	default:
 		pr_debug(CHRDEV "%x: What? (cmd=0x%x)\n", minor, cmd);
-		return -EINVAL;
+		return -ENOTTY;
 	}
 
 	/* Keep the compiler happy */
diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index b4b9d5a..a992bf1 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -231,7 +231,7 @@ static long raw_ctl_ioctl(struct file *filp, unsigned int command,
 		return 0;
 	}
 
-	return -EINVAL;
+	return -ENOTTY;
 }
 
 #ifdef CONFIG_COMPAT
@@ -273,7 +273,7 @@ static long raw_ctl_compat_ioctl(struct file *file, unsigned int cmd,
 		return 0;
 	}
 
-	return -EINVAL;
+	return -ENOTTY;
 }
 #endif
 
diff --git a/drivers/char/viotape.c b/drivers/char/viotape.c
index ad6e64a..c2d173b 100644
--- a/drivers/char/viotape.c
+++ b/drivers/char/viotape.c
@@ -520,10 +520,7 @@ static int viotap_ioctl(struct inode *inode, struct file *file,
 	struct viot_devinfo_struct devi;
 	struct mtop mtc;
 	u32 myOp;
-	struct op_struct *op = get_op_struct();
-
-	if (op == NULL)
-		return -ENOMEM;
+	struct op_struct *op = NULL;
 
 	get_dev_info(file->f_path.dentry->d_inode, &devi);
 
@@ -615,6 +612,11 @@ static int viotap_ioctl(struct inode *inode, struct file *file,
 			chg_state(devi.devno, VIOT_IDLE, file);
 		}
 
+		op = get_op_struct();
+		if (op == NULL) {
+			ret = -ENOMEM;
+			goto free_op;
+		}
 		init_completion(&op->com);
 		hvrc = HvCallEvent_signalLpEventFast(viopath_hostLp,
 				HvLpEvent_Type_VirtualIo,
@@ -637,6 +639,11 @@ static int viotap_ioctl(struct inode *inode, struct file *file,
 		goto free_op;
 
 	case MTIOCGET:
+		op = get_op_struct();
+		if (op == NULL) {
+			ret = -ENOMEM;
+			goto free_op;
+		}
 		ret = -EIO;
 		init_completion(&op->com);
 		hvrc = HvCallEvent_signalLpEventFast(viopath_hostLp,
@@ -667,15 +674,18 @@ static int viotap_ioctl(struct inode *inode, struct file *file,
 		return ret;
 	case MTIOCPOS:
 		printk(VIOTAPE_KERN_WARN "Got an (unsupported) MTIOCPOS\n");
+		ret = -ENOTTY;
 		break;
 	default:
 		printk(VIOTAPE_KERN_WARN "got an unsupported ioctl 0x%0x\n",
 				cmd);
+		ret = -ENOTTY;
 		break;
 	}
 
 free_op:
-	free_op_struct(op);
+	if (op)
+		free_op_struct(op);
 	up(&reqSem);
 	return ret;
 }
-- 
1.7.5.rc1

