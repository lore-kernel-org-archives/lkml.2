Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1FULrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 07:47:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50440 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751374Ab1FULrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 07:47:11 -0400
Date: Tue, 21 Jun 2011 12:47:09 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 1/8] regmap: Add generic non-memory mapped register
	access API
Message-ID: <20110621114709.GA12691@opensource.wolfsonmicro.com>
References: <20110620124608.GB31140@opensource.wolfsonmicro.com> <1308574489-31322-1-git-send-email-broonie@opensource.wolfsonmicro.com> <4DFFD486.7020901@metafoo.de> <20110621001438.GD1905@opensource.wolfsonmicro.com> <4DFFE9C1.5060003@metafoo.de> <20110621012429.GB4322@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621012429.GB4322@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 02:24:30AM +0100, Mark Brown wrote:
> On Tue, Jun 21, 2011 at 02:45:53AM +0200, Lars-Peter Clausen wrote:
> > On 06/21/2011 02:14 AM, Mark Brown wrote:
> 
> > > I like init, especially considering the plan to add cache support as
> > > there's more work in setting that up once you start doing the advanced
> > > caches.
> 
> > If you take a look at other kernel apis _alloc is usually used if the structure
> > is allocated (and initialized) inside the function and _init is used when the
> > function initializes an already existing structure. And it also matches better
> 
> That more applies to split alloc/init models - here there's a single
> operation that does both.  To me alloc() generally means that it just
> allocates a structure and leaves initialization still to be done while.
> 
> > with regmap_free.
> 
> That's true.

In the soc-cache code we use _init and _exit respectively.  Might be
worth considering instead of _free?

Thanks,
Dimitris
