Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab1DJVbm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 17:31:42 -0400
Received: from mail.perches.com ([173.55.12.10]:4633 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758039Ab1DJVbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 17:31:37 -0400
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] staging: Remove unnecessary semicolons when for (foo) {...};
Date: Sun, 10 Apr 2011 14:31:34 -0700
Message-Id: <0dff76dea629df4131d6e3f1144f1308b6a61ea3.1302470807.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1302470807.git.joe@perches.com>
References: <cover.1302470807.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Done via perl script:

$ cat remove_semi_for.pl
my $match_balanced_parentheses = qr/(\((?:[^\(\)]++|(?-1))*\))/;
my $match_balanced_braces      = qr/(\{(?:[^\{\}]++|(?-1))*\})/;

foreach my $file (@ARGV) {
    my $f;
    my $text;
    my $oldtext;

    next if ((-d $file));

    open($f, '<', $file)
	or die "$P: Can't open $file for read\n";
    $oldtext = do { local($/) ; <$f> };
    close($f);

    next if ($oldtext eq "");

    $text = $oldtext;

    my $count = 0;
    do {
	$count = 0;
	$count += $text =~ s@\b(for\s*${match_balanced_parentheses}\s*)${match_balanced_braces}\s*;@"$1$3"@egx;
    } while ($count > 0);

    if ($text ne $oldtext) {
	my $newfile = $file;

	open($f, '>', $newfile)
	    or die "$P: Can't open $newfile for write\n";
	print $f $text;
	close($f);
    }
}

$

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/comedi/drivers/pcl724.c            |    2 +-
 drivers/staging/comedi/drivers/pcm3724.c           |    2 +-
 drivers/staging/vt6655/ioctl.c                     |    6 +++---
 drivers/staging/vt6655/wmgr.c                      |    2 +-
 drivers/staging/vt6655/wpactl.c                    |    4 ++--
 drivers/staging/vt6656/ioctl.c                     |    6 +++---
 drivers/staging/vt6656/wmgr.c                      |    2 +-
 drivers/staging/vt6656/wpactl.c                    |    4 ++--
 .../arch/arm/mach-omap2/cyashalomap_kernel.c       |    2 +-
 9 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl724.c b/drivers/staging/comedi/drivers/pcl724.c
index 396a058..61b075d 100644
--- a/drivers/staging/comedi/drivers/pcl724.c
+++ b/drivers/staging/comedi/drivers/pcl724.c
@@ -209,7 +209,7 @@ static int pcl724_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 					 subdev_8255_cb,
 					 (unsigned long)(dev->iobase +
 							 SIZE_8255 * i));
-	};
+	}
 
 	return 0;
 }
diff --git a/drivers/staging/comedi/drivers/pcm3724.c b/drivers/staging/comedi/drivers/pcm3724.c
index 7fb3c27..f5c0bd1 100644
--- a/drivers/staging/comedi/drivers/pcm3724.c
+++ b/drivers/staging/comedi/drivers/pcm3724.c
@@ -301,7 +301,7 @@ static int pcm3724_attach(struct comedi_device *dev,
 		subdev_8255_init(dev, dev->subdevices + i, subdev_8255_cb,
 				 (unsigned long)(dev->iobase + SIZE_8255 * i));
 		((dev->subdevices) + i)->insn_config = subdev_3724_insn_config;
-	};
+	}
 	return 0;
 }
 
diff --git a/drivers/staging/vt6655/ioctl.c b/drivers/staging/vt6655/ioctl.c
index a74833d..8cf88c3 100644
--- a/drivers/staging/vt6655/ioctl.c
+++ b/drivers/staging/vt6655/ioctl.c
@@ -312,7 +312,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
             if (!pBSS->bActive)
                 continue;
             cbListCount++;
-        };
+        }
         sList.uItem = cbListCount;
         if (copy_to_user(pReq->data, &sList, sizeof(SBSSIDList))) {
 			result = -EFAULT;
@@ -606,7 +606,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
             if (!pNode->bActive)
                 continue;
             cbListCount++;
-        };
+        }
 
         sNodeList.uItem = cbListCount;
         if (copy_to_user(pReq->data, &sNodeList, sizeof(SNodeList))) {
@@ -657,7 +657,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
     		    if (jj >= pNodeList->uItem)
     		        break;
     		}
-		};
+		}
         if (copy_to_user(pReq->data, pNodeList, sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)))) {
 			result = -EFAULT;
 			break;
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index 71f7726..ab289c3 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -3179,7 +3179,7 @@ s_vMgrFormatTIM(
             }
             wEndIndex = ii;
         }
-    };
+    }
 
 
     // Round start index down to nearest even number
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index 78e326c..c328f95 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -653,7 +653,7 @@ static int wpa_get_scan(PSDevice pDevice,
 
          }
 
-    };
+    }
 
   kfree(ptempBSS);
 
@@ -679,7 +679,7 @@ static int wpa_get_scan(PSDevice pDevice,
         if (!pBSS->bActive)
             continue;
         count++;
-    };
+    }
 
     pBuf = kcalloc(count, sizeof(struct viawget_scan_result), (int)GFP_ATOMIC);
 
diff --git a/drivers/staging/vt6656/ioctl.c b/drivers/staging/vt6656/ioctl.c
index 12be316..cfe9c95 100644
--- a/drivers/staging/vt6656/ioctl.c
+++ b/drivers/staging/vt6656/ioctl.c
@@ -307,7 +307,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
             if (!pBSS->bActive)
                 continue;
             cbListCount++;
-        };
+        }
         sList.uItem = cbListCount;
         if (copy_to_user(pReq->data, &sList, sizeof(SBSSIDList))) {
 			result = -EFAULT;
@@ -594,7 +594,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
             if (!pNode->bActive)
                 continue;
             cbListCount++;
-        };
+        }
 
         sNodeList.uItem = cbListCount;
         if (copy_to_user(pReq->data, &sNodeList, sizeof(SNodeList))) {
@@ -645,7 +645,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
     		    if (jj >= pNodeList->uItem)
     		        break;
     		}
-		};
+		}
         if (copy_to_user(pReq->data, pNodeList, sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)))) {
 			result = -EFAULT;
 			break;
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 938e582..d67748f 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -3167,7 +3167,7 @@ s_vMgrFormatTIM(
             }
             wEndIndex = (WORD)ii;
         }
-    };
+    }
 
 
     // Round start index down to nearest even number
diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
index dabcb6e..d22e773 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -660,7 +660,7 @@ static int wpa_get_scan(PSDevice pDevice,
 
          }
 
-    };
+    }
 
   kfree(ptempBSS);
 
@@ -673,7 +673,7 @@ static int wpa_get_scan(PSDevice pDevice,
         if (!pBSS->bActive)
             continue;
         count++;
-    };
+    }
 
     pBuf = kcalloc(count, sizeof(struct viawget_scan_result), (int)GFP_ATOMIC);
 
diff --git a/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c b/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c
index 21cdb06..e575dcd 100644
--- a/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c
+++ b/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c
@@ -768,7 +768,7 @@ uint32_t cy_as_hal_processor_hw_init(void)
 		cy_as_hal_print_message(KERN_INFO "%s virt_addr=%x\n",
 					gpio_vma_tab[i].name,
 					(u32)gpio_vma_tab[i].virt_addr);
-	};
+	}
 
 	/*
 	 * force OMAP_GPIO_126  to rleased state,
-- 
1.7.4.2.g597a6.dirty

