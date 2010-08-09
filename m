Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0HIKhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 06:37:46 -0400
Received: from smtp.nokia.com ([192.100.122.233]:63224 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab0HIKhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 06:37:45 -0400
Date: Mon, 9 Aug 2010 13:36:18 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        "Tereshonkov Roman (Nokia-D/Helsinki)" <roman.tereshonkov@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Brownell <david-b@pacbell.net>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi: omap2_mcspi: make use of dev_vdbg()
Message-ID: <20100809103618.GE11340@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1275563341-31078-1-git-send-email-felipe.balbi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1275563341-31078-1-git-send-email-felipe.balbi@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 09 Aug 2010 10:36:27.0196 (UTC) FILETIME=[B8A6AFC0:01CB37AE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 01:09:01PM +0200, Balbi Felipe (Nokia-D/Helsinki) wrote:
>From: Felipe Balbi <felipe.balbi@nokia.com>
>
>dev_vdbg() is only compiled when VERBOSE is defined, so
>there's no need to wrap dev_dbg() on #ifdef VERBOSE .. #endif
>as we can use dev_vdbg() directly.
>
>Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
>---

ping, any comments to this one ? It's been pending for quite a long 
time.

> drivers/spi/omap2_mcspi.c |   36 +++++++++---------------------------
> 1 files changed, 9 insertions(+), 27 deletions(-)
>
>diff --git a/drivers/spi/omap2_mcspi.c b/drivers/spi/omap2_mcspi.c
>index b3a94ca..d703927 100644
>--- a/drivers/spi/omap2_mcspi.c
>+++ b/drivers/spi/omap2_mcspi.c
>@@ -489,10 +489,8 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
> 					dev_err(&spi->dev, "TXS timed out\n");
> 					goto out;
> 				}
>-#ifdef VERBOSE
>-				dev_dbg(&spi->dev, "write-%d %02x\n",
>+				dev_vdbg(&spi->dev, "write-%d %02x\n",
> 						word_len, *tx);
>-#endif
> 				__raw_writel(*tx++, tx_reg);
> 			}
> 			if (rx != NULL) {
>@@ -506,10 +504,8 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
> 				    (l & OMAP2_MCSPI_CHCONF_TURBO)) {
> 					omap2_mcspi_set_enable(spi, 0);
> 					*rx++ = __raw_readl(rx_reg);
>-#ifdef VERBOSE
>-					dev_dbg(&spi->dev, "read-%d %02x\n",
>+					dev_vdbg(&spi->dev, "read-%d %02x\n",
> 						    word_len, *(rx - 1));
>-#endif
> 					if (mcspi_wait_for_reg_bit(chstat_reg,
> 						OMAP2_MCSPI_CHSTAT_RXS) < 0) {
> 						dev_err(&spi->dev,
>@@ -522,10 +518,8 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
> 				}
>
> 				*rx++ = __raw_readl(rx_reg);
>-#ifdef VERBOSE
>-				dev_dbg(&spi->dev, "read-%d %02x\n",
>+				dev_vdbg(&spi->dev, "read-%d %02x\n",
> 						word_len, *(rx - 1));
>-#endif
> 			}
> 		} while (c);
> 	} else if (word_len <= 16) {
>@@ -542,10 +536,8 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
> 					dev_err(&spi->dev, "TXS timed out\n");
> 					goto out;
> 				}
>-#ifdef VERBOSE
>-				dev_dbg(&spi->dev, "write-%d %04x\n",
>+				dev_vdbg(&spi->dev, "write-%d %04x\n",
> 						word_len, *tx);
>-#endif
> 				__raw_writel(*tx++, tx_reg);
> 			}
> 			if (rx != NULL) {
>@@ -559,10 +551,8 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
> 				    (l & OMAP2_MCSPI_CHCONF_TURBO)) {
> 					omap2_mcspi_set_enable(spi, 0);
> 					*rx++ = __raw_readl(rx_reg);
>-#ifdef VERBOSE
>-					dev_dbg(&spi->dev, "read-%d %04x\n",
>+					dev_vdbg(&spi->dev, "read-%d %04x\n",
> 						    word_len, *(rx - 1));
>-#endif
> 					if (mcspi_wait_for_reg_bit(chstat_reg,
> 						OMAP2_MCSPI_CHSTAT_RXS) < 0) {
> 						dev_err(&spi->dev,
>@@ -575,10 +565,8 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
> 				}
>
> 				*rx++ = __raw_readl(rx_reg);
>-#ifdef VERBOSE
>-				dev_dbg(&spi->dev, "read-%d %04x\n",
>+				dev_vdbg(&spi->dev, "read-%d %04x\n",
> 						word_len, *(rx - 1));
>-#endif
> 			}
> 		} while (c);
> 	} else if (word_len <= 32) {
>@@ -595,10 +583,8 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
> 					dev_err(&spi->dev, "TXS timed out\n");
> 					goto out;
> 				}
>-#ifdef VERBOSE
>-				dev_dbg(&spi->dev, "write-%d %08x\n",
>+				dev_vdbg(&spi->dev, "write-%d %08x\n",
> 						word_len, *tx);
>-#endif
> 				__raw_writel(*tx++, tx_reg);
> 			}
> 			if (rx != NULL) {
>@@ -612,10 +598,8 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
> 				    (l & OMAP2_MCSPI_CHCONF_TURBO)) {
> 					omap2_mcspi_set_enable(spi, 0);
> 					*rx++ = __raw_readl(rx_reg);
>-#ifdef VERBOSE
>-					dev_dbg(&spi->dev, "read-%d %08x\n",
>+					dev_vdbg(&spi->dev, "read-%d %08x\n",
> 						    word_len, *(rx - 1));
>-#endif
> 					if (mcspi_wait_for_reg_bit(chstat_reg,
> 						OMAP2_MCSPI_CHSTAT_RXS) < 0) {
> 						dev_err(&spi->dev,
>@@ -628,10 +612,8 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
> 				}
>
> 				*rx++ = __raw_readl(rx_reg);
>-#ifdef VERBOSE
>-				dev_dbg(&spi->dev, "read-%d %08x\n",
>+				dev_vdbg(&spi->dev, "read-%d %08x\n",
> 						word_len, *(rx - 1));
>-#endif
> 			}
> 		} while (c);
> 	}
>-- 
>1.7.1

-- 
balbi

DefectiveByDesign.org
