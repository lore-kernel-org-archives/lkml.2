Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab1IUMtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 08:49:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40729 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab1IUMtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 08:49:52 -0400
Date: Wed, 21 Sep 2011 13:49:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Drake <dsd@laptop.org>
Cc: grant.likely@secretlab.ca, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Subject: Re: [PATCH 1/3] mfd: allow mfd_cell association with device tree
 node
Message-ID: <20110921124936.GA25620@sirena.org.uk>
References: <20110921120148.4A81E9D401D@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921120148.4A81E9D401D@zog.reactivated.net>
X-Cookie: Yow!  Am I having fun yet?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 01:01:48PM +0100, Daniel Drake wrote:

> @@ -37,6 +38,9 @@ struct mfd_cell {
>  	void			*platform_data;
>  	size_t			pdata_size;
>  
> +	/* association with device tree node (optional) */
> +	struct device_node	*of_node;
> +

This doesn't seem great as it means that the mfd_cells can't be static
data, they have to be allocated per device.  Why can't the MFD cells get
at the OF node by using the parent device in the same way as they
(mostly) get platform data at the minute?
