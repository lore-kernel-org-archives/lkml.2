Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161135Ab2KNKs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:48:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60427 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932836Ab2KNKsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:48:55 -0500
Date: Wed, 14 Nov 2012 10:48:54 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: arizona: Move chip reset to before register patch
Message-ID: <20121114104854.GB23525@opensource.wolfsonmicro.com>
References: <20121112175648.GA29044@opensource.wolfsonmicro.com> <20121113055618.GC18224@opensource.wolfsonmicro.com> <20121113131219.GA29198@opensource.wolfsonmicro.com> <20121114012007.GD4415@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114012007.GD4415@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 10:20:09AM +0900, Mark Brown wrote:
> On Tue, Nov 13, 2012 at 01:12:19PM +0000, Charles Keepax wrote:
> > On Tue, Nov 13, 2012 at 02:56:20PM +0900, Mark Brown wrote:
> 
> > > No, we should never write to the chip until we have successfully
> > > identified it.  Do a sync or similar instead (we should be triggering
> > > this very soon afterwards via runtime PM anyway).
> 
> > In that case I would be inclined to seperate out the chip
> > identification and the register patch doing the reset in between.
> > Is this something that would sound reasonable or would you rather
> > just add a sync after the reset?
> 
> Just do a sync, make sure that we mark the map as dirty when we do the
> reset via register write and it'll not have any effect anyway.  We
> should also check if we've got the LDO and use that for reset too
> actually...

The way the code is layed out at the moment if we don't
successfully get the LDO we won't get as far as the register
write reset. Meaning that if we can do the reset by cycling the
power on the LDO is there any point in having the option to do
the reset via a register write later?
