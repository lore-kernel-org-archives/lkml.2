Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab0DVUVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:21:05 -0400
Received: from kroah.org ([198.145.64.141]:59742 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757960Ab0DVUA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:29 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:10 2010
Message-Id: <20100422195410.907067324@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Yong Wang <yong.y.wang@intel.com>, Dmitry Torokhov <dtor@mail.ru>
Subject: [061/139] Input: sparse-keymap - free the right keymap on error
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yong Wang <yong.y.wang@linux.intel.com>

commit 88fcf710c13bd41f2b98c5411e4f21ab98da4fb4 upstream.

'map' is allocated in sparse_keymap_setup() and it it the one that should
be freed on error instead of 'keymap'.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/sparse-keymap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/sparse-keymap.c
+++ b/drivers/input/sparse-keymap.c
@@ -161,7 +161,7 @@ int sparse_keymap_setup(struct input_dev
 	return 0;
 
  err_out:
-	kfree(keymap);
+	kfree(map);
 	return error;
 
 }


