Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab1EDTrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:47:39 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:39844 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476Ab1EDTri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:47:38 -0400
Date: Wed, 4 May 2011 21:47:30 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Michal Simek <monstr@monstr.eu>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Wolfram Sang <w.sang@pengutronix.de>,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH v4] uio/pdrv_genirq: Add OF support
Message-ID: <20110504194730.GA2820@local>
References: <1304319115-32745-1-git-send-email-monstr@monstr.eu>
 <20110503203412.GA2119@pengutronix.de>
 <20110503221440.GB2737@local>
 <4DC152F3.2050500@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC152F3.2050500@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 03:21:55PM +0200, Michal Simek wrote:
> Hans J. Koch wrote:
> >On Tue, May 03, 2011 at 10:34:12PM +0200, Wolfram Sang wrote:
> >>On Mon, May 02, 2011 at 08:51:55AM +0200, Michal Simek wrote:
> >>>Adding OF binding to genirq.
> >>>Version string is setup to the "devicetree".
> >>>
> >>>Compatible string is not setup for now but you can add your
> >>>custom compatible string to uio_of_genirq_match structure.
> >>>
> >>>For example with "vendor,device" compatible string:
> >>>static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
> >>>	{ .compatible = "vendor,device", },
> >>>	{ /* empty for now */ },
> >>>};
> >>>
> >>>Signed-off-by: Michal Simek <monstr@monstr.eu>
> >>[...]
> >>
> >>>+		/* alloc uioinfo for one device */
> >>>+		uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
> >>kfree in remove?
> >
> >Oh yes. Missed that one. It should probably look like the "bad0" case in probe().
> 
> Yes, freeing uioinfo in uio_pdrv_genirq_remove make sense for CONFIG_OF.
> 
> Please correct me if I am wrong dev.of_node is not NULL for OF. I
> think yes that's why I would prefer to use this construct instead of
> #ifdef CONFIG_OF.
> 
> 	if (pdev->dev.of_node)
> 		kfree(pdev->dev.platform_data);

Huh? You didn't allocate platform_data, so you shouldn't free it.
It's uioinfo you allocated.

Thanks,
Hans
