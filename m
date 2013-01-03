Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3ACQF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 11:05:26 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18832 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3ACQFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 11:05:22 -0500
Date: Thu, 3 Jan 2013 19:04:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Cyril Roelandt <tipecaml@gmail.com>,
        spi-devel-general@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] spi: fix return value check in hspi_probe().
Message-ID: <20130103160455.GO7247@mwanda>
References: <1355271894-5284-1-git-send-email-tipecaml@gmail.com>
 <1355271894-5284-6-git-send-email-tipecaml@gmail.com>
 <87txrsqf7f.wl%kuninori.morimoto.gx@renesas.com>
 <20121219151154.937EC3E0AD7@localhost>
 <20121219163914.GN5032@mwanda>
 <20121222095620.83E243E07FA@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121222095620.83E243E07FA@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2012 at 09:56:20AM +0000, Grant Likely wrote:
> On Wed, 19 Dec 2012 19:39:14 +0300, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Wed, Dec 19, 2012 at 03:11:54PM +0000, Grant Likely wrote:
> > > On Tue, 11 Dec 2012 16:36:27 -0800 (PST), Kuninori Morimoto <kuninori.morimoto.gx@renesas.com> wrote:
> > > > 
> > > > Hi
> > > > 
> > > > > According to its documentation, clk_get() returns a "valid IS_ERR() condition
> > > > > containing errno", so we should call IS_ERR() rather than a NULL check.
> > > > > 
> > > > > Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> > > > 
> > > > Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> > > 
> > > Applied, thanks.
> > 
> > In another thread, we were just talking about who clk_get() can
> > return a NULL if !CONFIG_HAVE_CLK.  That might change to match the
> > documentation later...  Not sure.
> 
> So what is the solution here? Will the dummy clk_get() be changed, or is
> there more work needed on the drivers?
> 

This driver can't function without a clk.  It should select that at
build time instead of testing for it at probe.  Just checking for
IS_ERR() will NOT cause a NULL dereference so the patch is ok in
that respect.  I'm not sure if this can be build without
CONFIG_HAVE_CLK.

regards,
dan carpenter

