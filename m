Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab1ELPLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:11:15 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:58150 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228Ab1ELPLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:11:14 -0400
Date: Thu, 12 May 2011 11:11:13 -0400
To: Hu Mingkai-B21284 <B21284@freescale.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: Re: spi_fsl_spi broken when compiled as module by
 b36ece832512c1a0afa54ff0a56d63492a1caf08
Message-ID: <20110512151113.GE21345@caffeine.csclub.uwaterloo.ca>
References: <20110511155211.GA21349@caffeine.csclub.uwaterloo.ca>
 <9389EE59E16E9447AFB481039183BCF4117B10@039-SN1MPN1-005.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9389EE59E16E9447AFB481039183BCF4117B10@039-SN1MPN1-005.039d.mgd.msft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 01:33:55AM +0000, Hu Mingkai-B21284 wrote:
> Please submit a patch to modify it.

OK.  Here it is.

-- 
Len Sorensen

Add missing exports and module license to allow compiling of spi_fsl_*
drivers as modules again.  Originally broken by refactoring of code in
b36ece832512c1a0afa54ff0a56d63492a1caf08.

diff --git a/drivers/spi/spi_fsl_lib.c b/drivers/spi/spi_fsl_lib.c
index ff59f42..d7efaac 100644
--- a/drivers/spi/spi_fsl_lib.c
+++ b/drivers/spi/spi_fsl_lib.c
@@ -48,16 +48,23 @@ u32 mpc8xxx_spi_tx_buf_##type(struct mpc8xxx_spi *mpc8xxx_spi)	\
 }
 
 MPC8XXX_SPI_RX_BUF(u8)
+EXPORT_SYMBOL(mpc8xxx_spi_rx_buf_u8);
 MPC8XXX_SPI_RX_BUF(u16)
+EXPORT_SYMBOL(mpc8xxx_spi_rx_buf_u16);                                                                                                                                                                                                                                       
 MPC8XXX_SPI_RX_BUF(u32)
+EXPORT_SYMBOL(mpc8xxx_spi_rx_buf_u32);                                                                                                                                                                                                                                       
 MPC8XXX_SPI_TX_BUF(u8)
+EXPORT_SYMBOL(mpc8xxx_spi_tx_buf_u8);                                                                                                                                                                                                                                        
 MPC8XXX_SPI_TX_BUF(u16)
+EXPORT_SYMBOL(mpc8xxx_spi_tx_buf_u16);                                                                                                                                                                                                                                       
 MPC8XXX_SPI_TX_BUF(u32)
+EXPORT_SYMBOL(mpc8xxx_spi_tx_buf_u32);                                                                                                                                                                                                                                       
 
 struct mpc8xxx_spi_probe_info *to_of_pinfo(struct fsl_spi_platform_data *pdata)
 {
 	return container_of(pdata, struct mpc8xxx_spi_probe_info, pdata);
 }
+EXPORT_SYMBOL(to_of_pinfo);
 
 void mpc8xxx_spi_work(struct work_struct *work)
 {
@@ -116,6 +123,7 @@ const char *mpc8xxx_spi_strmode(unsigned int flags)
 	}
 	return "CPU";
 }
+EXPORT_SYMBOL(mpc8xxx_spi_strmode);                                                                                                                                                                                                                                          
 
 int mpc8xxx_spi_probe(struct device *dev, struct resource *mem,
 			unsigned int irq)
@@ -168,6 +176,7 @@ int mpc8xxx_spi_probe(struct device *dev, struct resource *mem,
 err:
 	return ret;
 }
+EXPORT_SYMBOL(mpc8xxx_spi_probe);                                                                                                                                                                                                                                            
 
 int __devexit mpc8xxx_spi_remove(struct device *dev)
 {
@@ -188,6 +197,7 @@ int __devexit mpc8xxx_spi_remove(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL(mpc8xxx_spi_remove);                                                                                                                                                                                                                                           
 
 int __devinit of_mpc8xxx_spi_probe(struct platform_device *ofdev)
 {
@@ -234,3 +244,8 @@ err:
 	kfree(pinfo);
 	return ret;
 }
+EXPORT_SYMBOL(of_mpc8xxx_spi_probe);                                                                                                                                                                                                                                         
+
+MODULE_AUTHOR("Kumar Gala");
+MODULE_DESCRIPTION("Freescale SPI/eSPI controller driver library");
+MODULE_LICENSE("GPL");
