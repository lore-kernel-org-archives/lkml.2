Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab1EBKhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 06:37:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:15221 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab1EBKhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 06:37:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,302,1301900400"; 
   d="scan'208";a="686928451"
Subject: Re: [PATCH 2/2] dmaengine: shdma: add runtime- and system-level
 power management
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <damm@opensource.se>
In-Reply-To: <Pine.LNX.4.64.1105021117060.13244@axis700.grange>
References: <Pine.LNX.4.64.1104291901200.17813@axis700.grange>
	 <Pine.LNX.4.64.1104291908090.17813@axis700.grange>
	 <1304323391.1589.9.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1105021056231.13244@axis700.grange>
	 <1304325486.1589.15.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1105021117060.13244@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 15:35:47 +0530
Message-ID: <1304330747.1589.23.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 11:53 +0200, Guennadi Liakhovetski wrote:
> On Mon, 2 May 2011, Koul, Vinod wrote:
> 
> > On Mon, 2011-05-02 at 11:04 +0200, Guennadi Liakhovetski wrote:
> > > On Mon, 2 May 2011, Koul, Vinod wrote:
> > > 
> > > > On Fri, 2011-04-29 at 19:09 +0200, Guennadi Liakhovetski wrote:
> > > > > This patch extends and fixes runtime power management in the shdma
> > > > > driver to support powering down the DMA controller and adds support
> > > > > for system-level suspend and resume.
> > > > > 
> > > > > +
> > > > > +static int sh_dmae_runtime_resume(struct device *dev)
> > > > > +{
> > > > > +	struct sh_dmae_device *shdev = dev_get_drvdata(dev);
> > > > > +
> > > > > +	return sh_dmae_rst(shdev);
> > > > > +}
> > > > > +
> > > > > +#ifdef CONFIG_PM
> > > > This should be removed...
> > > 
> > > You mean, these functions just won't be called, but this way we save a 
> > > couple of bytes if PM is not set, don't we?
> > I meant you dont need to have this, PM is usually part of core options
> > which ppl enable nowadays. Do you run with PM disabled?
> 
> I actually do, but maybe that's not a very important argument. So, if the 
> only difference is a couple of kilobytes in the kernel size, then maybe we 
> can just keep it always enabled. There are no other side-efects to it, 
> right?
Yes, other driver currently do this...

-- 
~Vinod

