Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966Ab0HKX6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:58:19 -0400
Received: from kroah.org ([198.145.64.141]:40254 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758814Ab0HKX6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:12 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:54:59 2010
Message-Id: <20100811235459.364979969@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [042/111] drm/i915: Use RSEN instead of HTPLG for tfp410 monitor detection.
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Müller <dave.mueller@gmx.ch>

commit f458823b864c6def488f951a79986fa205aba4f1 upstream.

Presence detection of a digital monitor seems not to be reliable using
the HTPLG bit.

Dave Müller <dave.mueller@gmx.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/dvo_tfp410.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/dvo_tfp410.c
+++ b/drivers/gpu/drm/i915/dvo_tfp410.c
@@ -214,7 +214,7 @@ static enum drm_connector_status tfp410_
 	uint8_t ctl2;
 
 	if (tfp410_readb(dvo, TFP410_CTL_2, &ctl2)) {
-		if (ctl2 & TFP410_CTL_2_HTPLG)
+		if (ctl2 & TFP410_CTL_2_RSEN)
 			ret = connector_status_connected;
 		else
 			ret = connector_status_disconnected;


