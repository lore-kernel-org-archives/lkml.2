Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab2JJXNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:13:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57031 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758076Ab2JJXCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:02:05 -0400
X-Sasl-enc: bwTtJcKQKP7QLfWTikkdMQSZM0eMiXHqu7czMetU1mgq 1349910124
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Florian Zumbiehl <florz@florz.de>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 037/122] drm/savage: re-add busmaster enable, regression fix
Date: Thu, 11 Oct 2012 07:53:23 +0900
Message-Id: <20121010225344.822316790@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Zumbiehl <florz@florz.de>

commit df86b5765a48d5f557489577652bd6df145b0e1b upstream.

466e69b8b03b8c1987367912782bc12988ad8794 dropped busmaster enable from the
global drm code and moved it to the individual drivers, but missed the savage
driver. So, this re-adds busmaster enable to the savage driver, fixing the
regression.

Signed-off-by: Florian Zumbiehl <florz@florz.de>
Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/savage/savage_bci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/savage/savage_bci.c
+++ b/drivers/gpu/drm/savage/savage_bci.c
@@ -547,6 +547,8 @@ int savage_driver_load(struct drm_device
 
 	dev_priv->chipset = (enum savage_family)chipset;
 
+	pci_set_master(dev->pdev);
+
 	return 0;
 }
 


