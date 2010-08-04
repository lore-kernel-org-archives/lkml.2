Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab0HDOTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:19:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:44660 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758041Ab0HDOTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:19:07 -0400
Date: Wed, 4 Aug 2010 23:18:16 +0900
To: Joerg.Roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, subrata@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, Linuxppc-dev@ozlabs.org,
        grant.likely@secretlab.ca, James.Bottomley@suse.de,
        brking@linux.vnet.ibm.com, tj@kernel.org, rcj@linux.vnet.ibm.com,
        devilbis@us.ibm.com, santil@us.ibm.com, sleddog@us.ibm.com,
        sachinp@linux.vnet.ibm.com, dipraksh@linux.vnet.ibm.com
Subject: Re: 2.6.35-stable/ppc64/p7: Badness at lib/dma-debug.c:902, Call
 Trace	& Instruction Dump during boot
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100804131634.GX26098@amd.com>
References: <1280746270.15317.16.camel@subratamodak.linux.ibm.com>
	<20100802205404C.fujita.tomonori@lab.ntt.co.jp>
	<20100804131634.GX26098@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100804231727H.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 04 Aug 2010 23:18:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010 15:16:34 +0200
"Roedel, Joerg" <Joerg.Roedel@amd.com> wrote:

> On Mon, Aug 02, 2010 at 07:55:03AM -0400, FUJITA Tomonori wrote:
> > I guess that this driver does a partial sync with
> > dma_sync_single_for_* API. dma-debug can't handle it properly. It's
> > likely that this is a false warning.
> 
> If this turns out to be true it is not trivial to fix. I prepare a patch
> to test for you.

I've not looked at the details of this driver, but there are drivers
that do such. So dma-debug needs to be fixed anyway; you can't assume
that a DMA address that dma_map_single returned is passed to
dma_sync_single_for API.
