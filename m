Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab2JNPEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:04:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46389 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754643Ab2JNOnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:01 -0400
Message-Id: <20121014143547.026476773@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:11 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 098/147] lguest: fix occasional crash in example launcher.
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rusty Russell <rusty@rustcorp.com.au>

commit ca16f580a5db7e60bfafe59a50bb133bd3347491 upstream.

We usually got away with ->next on the final entry being NULL, but it
finally bit me.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/virtual/lguest/lguest.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/virtual/lguest/lguest.c b/Documentation/virtual/lguest/lguest.c
index f759f4f..fd2f922 100644
--- a/Documentation/virtual/lguest/lguest.c
+++ b/Documentation/virtual/lguest/lguest.c
@@ -1299,6 +1299,7 @@ static struct device *new_device(const char *name, u16 type)
 	dev->feature_len = 0;
 	dev->num_vq = 0;
 	dev->running = false;
+	dev->next = NULL;
 
 	/*
 	 * Append to device list.  Prepending to a single-linked list is


