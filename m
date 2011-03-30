Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab1C3BAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 21:00:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53645 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751360Ab1C3BAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 21:00:12 -0400
Date: Wed, 30 Mar 2011 10:00:20 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Collins <collinsd@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org
Subject: Re: [PATCH v2 2/2] regulator: Propagate uA_load requirements up
 supply chain
Message-ID: <20110330010016.GB2853@opensource.wolfsonmicro.com>
References: <1301356355-7546-1-git-send-email-collinsd@codeaurora.org>
 <1301356432-7586-2-git-send-email-collinsd@codeaurora.org>
 <20110329084458.GD29330@opensource.wolfsonmicro.com>
 <4D9203EF.4060303@codeaurora.org>
 <20110329212010.GA30482@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110329212010.GA30482@opensource.wolfsonmicro.com>
X-Cookie: Courage is your greatest present need.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 06:20:10AM +0900, Mark Brown wrote:
> On Tue, Mar 29, 2011 at 09:08:15AM -0700, David Collins wrote:

> > I agree that it would be beneficial to change regulator_dev.supply from
> > type struct regulator_dev * to type struct regulator *.  However, I think
> > that going that route will be a major undertaking with a lot of details to

> Hrm, it doesn't look too bad - as far as I can see it should just be
> fairly direct refactorings of each of get, put, enable and disable?

I had a look at this, it all looks very straightforward apart from get
where we need to either do a dance to set up a supply mapping or
restructure to expose the core get operation internally without map
lookups (the latter I think) and that doesn't seem terribly invasive.
I may actually try coding it up next time I'm sitting in front of an
appropriate test system.
