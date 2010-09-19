Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab0ISM45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 08:56:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58608 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab0ISMzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 08:55:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fkVKU35+xTuIKFmB2JyLvjvoXN7UrY5VECd07qdetVrhfNdim2xZepN6EJstSb9vod
         Q9KYMbq4jNxLPu0h2G4OksSkdzyYNqxrGrgzChRailJ9P7NbNUpvrZNiUpipUYadUGml
         IpoOouBYtDe+lgYGJM+e29QLf1zNYEWJjTiIE=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] pcmcia: ds: fix device_register() error handling
Date: Sun, 19 Sep 2010 16:54:58 +0400
Message-Id: <1284900898-24495-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device_register() fails then call put_device().
See comment to device_register.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 compile tested.

 drivers/pcmcia/ds.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 100c441..b56f5a6 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -582,10 +582,12 @@ static struct pcmcia_device *pcmcia_device_add(struct pcmcia_socket *s,
 	pcmcia_device_query(p_dev);
 
 	if (device_register(&p_dev->dev))
-		goto err_unreg;
+		goto err_put_device;
 
 	return p_dev;
 
+ err_put_device:
+	put_device(&p_dev->dev);
  err_unreg:
 	mutex_lock(&s->ops_mutex);
 	list_del(&p_dev->socket_device_list);
-- 
1.7.0.4

