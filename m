Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab1JXUWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 16:22:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41580 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab1JXUWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 16:22:37 -0400
Date: Mon, 24 Oct 2011 21:21:18 +0100
From: Mark Einon <mark.einon@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Mark Einon <mark.einon@gmail.com>, Greg KH <greg@kroah.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH staging 3/6] et131x: fix error paths in et131x_pci_setup.
Message-ID: <20111024202116.GC3851@msilap.einon>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
 <20111023093651.GA22285@kroah.com>
 <20111023094231.GA3409@msilap.einon>
 <20111023171135.GC28657@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Description: =?ISO-8859-1?Q?=20=1B?=
Content-Disposition: inline
In-Reply-To: <20111023171135.GC28657@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 07:11:35PM +0200, Francois Romieu wrote:
> Wrong status code and unbalanced phy_connect.
> 
> Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
> ---
[...]
> @@ -5448,9 +5424,11 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
>  	 */
>  	pci_set_drvdata(pdev, netdev);
>  	pci_save_state(adapter->pdev);
> +out:
> +	return rc;
>  
> -	return result;
> -
> +err_phy_disconnect:
> +	phy_disconnect(adapter->phydev);
>  err_mdio_unregister:
>  	mdiobus_unregister(adapter->mii_bus);
>  err_mdio_free_irq:
> @@ -5468,8 +5446,7 @@ err_release_res:
>  	pci_release_regions(pdev);
>  err_disable:
>  	pci_disable_device(pdev);
> -err_out:
> -	return result;
> +	goto out;
>  }
>  
>  static SIMPLE_DEV_PM_OPS(et131x_pm_ops, et131x_suspend, et131x_resume);

Patch looks good, but again, could you remove the backwards jumping goto.
