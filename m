Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab2IMAQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:16:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49817 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932492Ab2ILXhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:37:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, CF Adad <cfadad@rocketmail.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 16/85] ASoC: omap-mcbsp: Fix 6pin mux configuration
Date: Wed, 12 Sep 2012 16:35:59 -0700
Message-Id: <20120912233543.437055131@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

commit d0db84e713eaaccea2a435e1625fb3150b335f4a upstream.

The check for the mux_signal callback was wrong which prevents us to
configure the 6pin port's FSR/CLKR signal mux.

Reported-by: CF Adad <cfadad@rocketmail.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/omap/mcbsp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/omap/mcbsp.c
+++ b/sound/soc/omap/mcbsp.c
@@ -691,7 +691,7 @@ int omap_mcbsp_6pin_src_mux(struct omap_
 {
 	const char *signal, *src;
 
-	if (mcbsp->pdata->mux_signal)
+	if (!mcbsp->pdata->mux_signal)
 		return -EINVAL;
 
 	switch (mux) {


