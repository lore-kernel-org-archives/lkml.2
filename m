Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab1KXFrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 00:47:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53014 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab1KXFru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 00:47:50 -0500
Date: Thu, 24 Nov 2011 07:47:31 +0200
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Vinod Koul <vinod.koul@intel.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "rmallon@gmail.com" <rmallon@gmail.com>,
        Rafal Prylowski <prylowski@metasoft.pl>
Subject: Re: [PATCH 2/2] dma/ep93xx_dma: prevent ep93xx_dma_tasklet() to
 access empty list
Message-ID: <20111124054731.GB2621@mwesterb-mobl.ger.corp.intel.com>
References: <19bcd0ee953116fd71bc1c705636c5fec80608cb.1321990466.git.mika.westerberg@iki.fi>
 <707c0a5c61bd597ceed3871fc3528f687ac0fcff.1321990466.git.mika.westerberg@iki.fi>
 <ADE657CA350FB648AAC2C43247A983F001F3E96DA6B7@AUSP01VMBX24.collaborationhost.net>
 <1322046034.1516.254.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322046034.1516.254.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 04:30:34PM +0530, Vinod Koul wrote:
> 
> will you still hit the problem if you do a proper check in tasklet for 
> a) if list is empty
> b) if _get_active_desc() returns valid desc
> and the _get_active_desc() returns NULL on not finding active desc

No, with the above the problem goes away.

> The point is by adding a flag you are avoiding the condition hence it is
> working for you whereas on other approach you exit gracefully without
> crashing in all the cases (including potentially uncovered ones)

Ok I see.

I'll prepare a new version where ep93xx_dma_get_active() returns NULL in case
of empty active list, and handle it properly in callers.
