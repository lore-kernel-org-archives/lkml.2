Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563Ab0LHBti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:49:38 -0500
Received: from kroah.org ([198.145.64.141]:48665 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134Ab0LHA77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:59 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:28 2010
Message-Id: <20101208005727.941146265@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>,
        Ari Savolainen <ari.m.savolainen@gmail.com>,
        Jean Delvare <khali@linux-fr.org>, Dave Airlie <airlied@redhat.com>
Subject: [066/289] drm/radeon/kms: register an i2c adapter name for the dp aux bus
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit a5193fe50e7f21c26d22c17c8196420fac1a3ca7 upstream.

This causes the connector to not be added since i2c init fails
for the adapter.  Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=31688

Noticed by Ari Savolainen.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Cc: Ari Savolainen <ari.m.savolainen@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_i2c.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/radeon/radeon_i2c.c
+++ b/drivers/gpu/drm/radeon/radeon_i2c.c
@@ -946,6 +946,7 @@ struct radeon_i2c_chan *radeon_i2c_creat
 	i2c->rec = *rec;
 	i2c->adapter.owner = THIS_MODULE;
 	i2c->dev = dev;
+	sprintf(i2c->adapter.name, "Radeon aux bus %s", name);
 	i2c_set_adapdata(&i2c->adapter, i2c);
 	i2c->adapter.algo_data = &i2c->algo.dp;
 	i2c->algo.dp.aux_ch = radeon_dp_i2c_aux_ch;


