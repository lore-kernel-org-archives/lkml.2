Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab0HPQ0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:26:40 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:34752 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829Ab0HPQ0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:26:38 -0400
Date: Mon, 16 Aug 2010 18:26:36 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 7/16] drivers/staging: Use available error codes
Message-ID: <Pine.LNX.4.64.1008161826140.19313@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

An error code is stored in a variable, but 0 is returned instead.  Use the
variable instead of 0.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
local idexpression x;
constant C;
@@

if (...) { ...
  x = -C
  ... when != x
(
  return <+...x...+>;
|
  return NULL;
|
  return;
|
* return ...;
)
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This changes the semantics and is not tested.

 drivers/staging/lirc/lirc_sasem.c |    2 +-
 drivers/staging/sep/sep_driver.c  |    4 ++--
 drivers/staging/vt6655/iwctl.c    |    2 +-
 drivers/staging/vt6656/iwctl.c    |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lirc/lirc_sasem.c b/drivers/staging/lirc/lirc_sasem.c
index 73166c3..856487e 100644
--- a/drivers/staging/lirc/lirc_sasem.c
+++ b/drivers/staging/lirc/lirc_sasem.c
@@ -512,7 +512,7 @@ exit:
 	mutex_unlock(&context->ctx_lock);
 
 	mutex_unlock(&disconnect_lock);
-	return 0;
+	return retval;
 }
 
 /**
diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index ecbde34..604965c 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -844,7 +844,7 @@ static int sep_lock_kernel_pages(struct sep_device *sep,
 	*page_array_ptr = 0;
 end_function:
 	dbg("SEP Driver:<-------- sep_lock_kernel_pages end\n");
-	return 0;
+	return error;
 }
 
 /*
@@ -972,7 +972,7 @@ end_function_with_error1:
 	kfree(page_array);
 end_function:
 	dbg("SEP Driver:<-------- sep_lock_user_pages end\n");
-	return 0;
+	return error;
 }
 
 
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 4322761..4009c0b 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -1900,7 +1900,7 @@ int iwctl_siwgenie(struct net_device *dev,
 	}
 
 	out://not completely ...not necessary in wpa_supplicant 0.5.8
-	return 0;
+	return ret;
 }
 
 int iwctl_giwgenie(struct net_device *dev,
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 016b8e7..8fb6518 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1726,7 +1726,7 @@ int iwctl_siwgenie(struct net_device *dev,
 	}
 
 	out://not completely ...not necessary in wpa_supplicant 0.5.8
-	return 0;
+	return ret;
 }
 
 int iwctl_giwgenie(struct net_device *dev,
