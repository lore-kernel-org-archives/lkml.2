Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab2KMNMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:12:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57671 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751499Ab2KMNMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:12:21 -0500
Date: Tue, 13 Nov 2012 13:12:19 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: arizona: Move chip reset to before register patch
Message-ID: <20121113131219.GA29198@opensource.wolfsonmicro.com>
References: <20121112175648.GA29044@opensource.wolfsonmicro.com> <20121113055618.GC18224@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113055618.GC18224@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 02:56:20PM +0900, Mark Brown wrote:
> On Mon, Nov 12, 2012 at 05:56:48PM +0000, Charles Keepax wrote:
> > In the absence of a physical reset line the chip is reset by writing the
> > first register, this was done after the register patch was applied which
> > negates the settings applied in the register patch.
> > 
> > This patch moves the reset to take place before the register patch is
> > applied.
> 
> No, we should never write to the chip until we have successfully
> identified it.  Do a sync or similar instead (we should be triggering
> this very soon afterwards via runtime PM anyway).

In that case I would be inclined to seperate out the chip
identification and the register patch doing the reset in between.
Is this something that would sound reasonable or would you rather
just add a sync after the reset?
