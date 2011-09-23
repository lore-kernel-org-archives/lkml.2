Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab1IWWr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:47:58 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:12628 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab1IWWr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:47:57 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-132.messagelabs.com!1316818057!39551331!13
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fscache/object.c: local functions should be static
Date: Fri, 23 Sep 2011 15:46:58 -0700
User-Agent: KMail/1.9.9
CC: <linux-cachefs@redhat.com>, <dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109231546.58222.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiets the sparse noise:

warning: symbol 'fscache_dequeue_object' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Howells <dhowells@redhat.com>

---

diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index b6b897c..250881d 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -834,7 +834,7 @@ static void fscache_enqueue_dependents(struct fscache_object *object)
  * remove an object from whatever queue it's waiting on
  * - the caller must hold object->lock
  */
-void fscache_dequeue_object(struct fscache_object *object)
+static void fscache_dequeue_object(struct fscache_object *object)
 {
 	_enter("{OBJ%x}", object->debug_id);
 
