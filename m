Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab2LBOD2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 09:03:28 -0500
Received: from 8bytes.org ([85.214.48.195]:45529 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab2LBOD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 09:03:27 -0500
Date: Sun, 2 Dec 2012 15:03:23 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: joerg.roedel@amd.com, iommu@lists.linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        scottwood@freescale.com, timur@freescale.com
Subject: Re: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes required
 by fsl PAMU driver.
Message-ID: <20121202140323.GO30633@8bytes.org>
References: <1353419697-31269-1-git-send-email-Varun.Sethi@freescale.com>
 <1353419697-31269-4-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353419697-31269-4-git-send-email-Varun.Sethi@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sun Dec  2 15:03:25 2012
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50bb5fad22971063944881
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, we need to work out a good abstraction for this.

On Tue, Nov 20, 2012 at 07:24:56PM +0530, Varun Sethi wrote:
> Added the following domain attributes required by FSL PAMU driver:
> 1. Subwindows field added to the iommu domain geometry attribute.

Are the Subwindows mapped with full size or do you map only parts of the
subwindows?

> +	 * This attribute indicates number of DMA subwindows supported by
> +	 * the geometry. If there is a single window that maps the entire
> +	 * geometry, attribute must be set to "1". A value of "0" implies
> +	 * that this mechanism is not used at all(normal paging is used).
> +	 * Value other than* "0" or "1" indicates the actual number of
> +	 * subwindows.
> +	 */

This semantic is ugly, how about a feature detection mechanism?

> +struct iommu_stash_attribute {
> +	u32 	cpu;	/* cpu number */
> +	u32 	cache;	/* cache to stash to: L1,L2,L3 */
>  };
>  
>  struct iommu_domain {
> @@ -60,6 +95,14 @@ struct iommu_domain {
>  enum iommu_attr {
>  	DOMAIN_ATTR_MAX,
>  	DOMAIN_ATTR_GEOMETRY,
> +	/* Set the IOMMU hardware stashing
> +	 * parameters.
> +	 */
> +	DOMAIN_ATTR_STASH,
> +	/* Explicity enable/disable DMA for a
> +         * particular memory window.
> +         */
> +	DOMAIN_ATTR_ENABLE,
>  };

When you add implementation specific attributes please add some
indication to the names that it is only for PAMU. DOMAIN_ATTR_STASH
sounds too generic.


	Joerg


