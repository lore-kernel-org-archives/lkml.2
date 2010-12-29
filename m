Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab0L2Gvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 01:51:48 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59942 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab0L2Gvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 01:51:47 -0500
Date: Tue, 28 Dec 2010 23:51:44 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 3/3] spi_topcliff_pch: fix resource leak issue
Message-ID: <20101229065144.GE8172@angua.secretlab.ca>
References: <1293449027-3219-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1293449027-3219-2-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1293449027-3219-3-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293449027-3219-3-git-send-email-tomoya-linux@dsn.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 08:23:47PM +0900, Tomoya MORINAGA wrote:
> In case spi_register_master fails in probe function,
> pch_spi_free_resources is not called.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Ditto for patch 2.  This looks like a bug fix, please respin to apply
without patch #1

Thanks,
g.

> ---
>  drivers/spi/spi_topcliff_pch.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/spi/spi_topcliff_pch.c b/drivers/spi/spi_topcliff_pch.c
> index a796eaf..e806e31 100644
> --- a/drivers/spi/spi_topcliff_pch.c
> +++ b/drivers/spi/spi_topcliff_pch.c
> @@ -1125,6 +1125,7 @@ static int pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  err_spi_reg_master:
>  	for (j = 0; j < i; j++)
>  		spi_unregister_master(master[j]);
> +	pch_spi_free_resources(board_dat);
>  err_spi_get_resources:
>  err_spi_alloc_master:
>  	for (j = 0; j < i; j++)
> -- 
> 1.6.0.6
> 
