Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030783Ab2CITsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:48:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030740Ab2CITsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:48:06 -0500
Message-Id: <20120309190206.109287422@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Javier Martin <javier.martin@vista-silicon.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 47/95] ASoC: i.MX SSI: Fix DSP_A format.
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Martin <javier.martin@vista-silicon.com>

commit 5ed80a75b248bfaf840ea6b38f941edcf6ee7dc7 upstream.

According to i.MX27 Reference Manual (p 1593) TXBIT0 bit selects
whether the most significant or the less significant part of the
data word written to the FIFO is transmitted.

As DSP_A is the same as DSP_B with a data offset of 1 bit, it
doesn't make any sense to remove TXBIT0 bit here.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/imx/imx-ssi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/imx/imx-ssi.c
+++ b/sound/soc/imx/imx-ssi.c
@@ -112,7 +112,7 @@ static int imx_ssi_set_dai_fmt(struct sn
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
 		/* data on rising edge of bclk, frame high 1clk before data */
-		strcr |= SSI_STCR_TFSL | SSI_STCR_TEFS;
+		strcr |= SSI_STCR_TFSL | SSI_STCR_TXBIT0 | SSI_STCR_TEFS;
 		break;
 	}
 


