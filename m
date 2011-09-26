Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1IZWwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 18:52:21 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:55502 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab1IZWwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 18:52:20 -0400
Date: Mon, 26 Sep 2011 18:51:59 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: gregkh@suse.de, martyn.welch@ge.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: vme: add struct vme_dev for VME devices
Message-ID: <20110926225159.GA13175@flamenco.cs.columbia.edu>
References: <1317029238-13357-1-git-send-email-manohar.vanga@cern.ch>
 <1317029238-13357-2-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317029238-13357-2-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 11:27:15 +0200, Manohar Vanga wrote:
(snip)
> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> index 810fe1f..76e08f3 100644
> --- a/drivers/staging/vme/vme.c
> +++ b/drivers/staging/vme/vme.c
(snip)
> @@ -1358,26 +1355,29 @@ int vme_register_bridge(struct vme_bridge *bridge)
>  	 * specification.
>  	 */
>  	for (i = 0; i < VME_SLOTS_MAX; i++) {
> -		bridge->dev[i] = kzalloc(sizeof(struct device), GFP_KERNEL);
> +		bridge->dev[i] = kzalloc(sizeof(struct vme_dev), GFP_KERNEL);
>  		if (!bridge->dev[i]) {
>  			retval = -ENOMEM;
>  			goto err_devalloc;
>  		}
> -		dev = bridge->dev[i];
> -		memset(dev, 0, sizeof(struct device));
> -
> -		dev->parent = bridge->parent;
> -		dev->bus = &vme_bus_type;
> -		dev->release = vme_dev_release;
> +		vdev = bridge->dev[i];
> +		memset(vdev, 0, sizeof(struct vme_dev));

minor nit, in fact removed in patch 2: memset here is redundant
(see kzalloc above).

The rest looks good.

		Emilio
