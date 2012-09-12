Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab2IMAny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:43:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36222 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab2ILXal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:30:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, CF Adad <cfadad@rocketmail.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 019/108] ASoC: omap-mcbsp: Fix 6pin mux configuration
Date: Wed, 12 Sep 2012 16:28:17 -0700
Message-Id: <20120912232452.550987668@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -745,7 +745,7 @@ int omap_mcbsp_6pin_src_mux(struct omap_
 {
 	const char *signal, *src;
 
-	if (mcbsp->pdata->mux_signal)
+	if (!mcbsp->pdata->mux_signal)
 		return -EINVAL;
 
 	switch (mux) {


