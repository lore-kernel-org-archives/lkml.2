Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab2CZKpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:45:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:50540 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757222Ab2CZKpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:45:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="81621474"
Subject: Re: [PATCH linux-next] dmaengine: add context parameter fixups
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Fabio Estevam <festevam@gmail.com>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        paul.gortmaker@windriver.com, dan.j.williams@intel.com,
        samuel@sortiz.org, lrg@ti.com, perex@perex.cz, tiwai@suse.de,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, fabio.estevam@freescale.com,
        alsa-devel@alsa-project.org
In-Reply-To: <20120326103354.GD3098@opensource.wolfsonmicro.com>
References: <1332511242-30241-1-git-send-email-alexandre.bounine@idt.com>
	 <CAOMZO5B-Zutv-xwqLCAgNMO8A3Kyg4uWqS41koo-yoS4mGB1TQ@mail.gmail.com>
	 <1332740082.19804.15.camel@vkoul-udesk3>
	 <20120326094200.GA3098@opensource.wolfsonmicro.com>
	 <1332755670.19804.91.camel@vkoul-udesk3>
	 <20120326103354.GD3098@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Mar 2012 16:18:26 +0530
Message-ID: <1332758906.19804.97.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 11:33 +0100, Mark Brown wrote:
> On Mon, Mar 26, 2012 at 03:24:30PM +0530, Vinod Koul wrote:
> 
> > Now either I drop these from 3.4 or merge Linus's tree and apply
> > Alexandre's fix (as that is the right fix rather than one in asoc tree)
> > And since this was required for RIO patches which are still WIP, I think
> > I am leaning towards former.
> 
> Gah, WTF is going on here?  Has this API change not been sent to Linus
> already, and what is wrong with the changes which Fabio sent?  I've
> already applied Fabio's change on the understanding that this API change
> done and dusted.
> 
> It seems better to do a minimal fix at this point rather than churning
> things again...

The change is technically correct, so don't worry it wont break
anything, and API is frozen and not changing.

But we don't want the clients to use this additional parameter or be
exposed to it if not required. Every client is expected to use the
dmaengine wrappers for prepare and not invoke .device_ callbacks.


-- 
~Vinod

