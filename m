Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab2JJX0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:26:38 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58789 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932365Ab2JJWxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:53:39 -0400
X-Sasl-enc: xveX1ZqjS3pI9pzEFJ+L0tfYODzBW1JdCdV8bHF7hzIS 1349909617
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 017/133] lguest: fix occasional crash in example launcher.
Date: Thu, 11 Oct 2012 07:50:43 +0900
Message-Id: <20121010224857.559624025@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rusty Russell <rusty@rustcorp.com.au>

commit ca16f580a5db7e60bfafe59a50bb133bd3347491 upstream.

We usually got away with ->next on the final entry being NULL, but it
finally bit me.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/lguest/lguest.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/lguest/lguest.c
+++ b/tools/lguest/lguest.c
@@ -1299,6 +1299,7 @@ static struct device *new_device(const c
 	dev->feature_len = 0;
 	dev->num_vq = 0;
 	dev->running = false;
+	dev->next = NULL;
 
 	/*
 	 * Append to device list.  Prepending to a single-linked list is


