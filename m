Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab2JJXQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:16:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37150 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757887Ab2JJXBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:01:32 -0400
X-Sasl-enc: lemwspLUCCpPRY1TurPRkTs7L0ljELtTUunPFB5/iRbJ 1349910091
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 021/122] lguest: fix occasional crash in example launcher.
Date: Thu, 11 Oct 2012 07:53:07 +0900
Message-Id: <20121010225341.940527993@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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


