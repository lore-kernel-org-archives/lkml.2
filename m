Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab1JQVdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:33:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54201 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754147Ab1JQVdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:33:06 -0400
Date: Mon, 17 Oct 2011 22:33:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Grant Likely <grant@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] gpio/samsung: Complain loudly if we don't know the SoC
Message-ID: <20111017213303.GA3366@opensource.wolfsonmicro.com>
References: <1318885455-905-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACxGe6vqUjayFVu1wNUYN_zjngKJcXkzzcxcGn4bwkHG7xv2yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6vqUjayFVu1wNUYN_zjngKJcXkzzcxcGn4bwkHG7xv2yg@mail.gmail.com>
X-Cookie: Courage is your greatest present need.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 03:07:47PM -0600, Grant Likely wrote:
> On Mon, Oct 17, 2011 at 3:04 PM, Mark Brown

> > If we don't know the SoC type then we won't add any chips which is rather
> > unfortunate as neither GPIO nor pinmux APIs will work, breaking lots of
> > different subsystems. Logging at least provides a hint to the user as to
> > what's gone wrong.

> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> Be Bolder!  May as well use WARN() and be really obnoxious.  :-)

Actually what's really unfortunate here is that in most configurations
this will cause a catastrophic failure to boot so we never get far
enough to see the logging at all.  We really need aSCREAM_THROUGH_DEBUG_LL()
or whatever.  Or to fix these things to dump via that route if we don't
have the console up yet, which is going to be more practical.
