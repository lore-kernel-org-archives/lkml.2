Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab1CRPvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:51:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46490 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075Ab1CRPvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:51:05 -0400
Date: Fri, 18 Mar 2011 09:51:02 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Jiri Slaby <jslaby@suse.cz>
Cc: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/1] SPI: dw_spi, fix PPC build
Message-ID: <20110318155102.GA22790@angua.secretlab.ca>
References: <1300441277-23961-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1300441277-23961-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 10:41:17AM +0100, Jiri Slaby wrote:
> Currently, build on PPC dies with:
> In file included from drivers/spi/dw_spi_mmio.c:16:
> include/linux/spi/dw_spi.h:147: error: field ‘tx_sgl’ has incomplete type
> include/linux/spi/dw_spi.h:149: error: field ‘rx_sgl’ has incomplete type
> 
> Add linux/scatterlist.h include to dw_spi.h, because we need to know
> the contents of the structure.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>

Applied, thanks.

g.

> ---
>  include/linux/spi/dw_spi.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/spi/dw_spi.h b/include/linux/spi/dw_spi.h
> index 6cd10f6..fb0bce5 100644
> --- a/include/linux/spi/dw_spi.h
> +++ b/include/linux/spi/dw_spi.h
> @@ -2,6 +2,7 @@
>  #define DW_SPI_HEADER_H
>  
>  #include <linux/io.h>
> +#include <linux/scatterlist.h>
>  
>  /* Bit fields in CTRLR0 */
>  #define SPI_DFS_OFFSET			0
> -- 
> 1.7.4.1
> 
> 
