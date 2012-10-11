Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934105Ab2JKBVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:21:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56384 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933502Ab2JKBVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:21:08 -0400
X-Sasl-enc: hfVXnlUE5iuEj7QPYcjV9Z/7ECa59szZY6MniB4X2hmj 1349918466
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Florian Zumbiehl <florz@florz.de>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 055/120] drm/savage: re-add busmaster enable, regression fix
Date: Thu, 11 Oct 2012 10:00:07 +0900
Message-Id: <20121011005835.745206945@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
 


