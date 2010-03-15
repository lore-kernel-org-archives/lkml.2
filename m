Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937152Ab0COXRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:17:12 -0400
Received: from sh.osrg.net ([192.16.179.4]:45944 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937118Ab0COXRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:17:08 -0400
Date: Tue, 16 Mar 2010 08:16:51 +0900
To: stern@rowland.harvard.edu
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org
Subject: Re: dma_sync_sg_for_cpu applied to a single scatterlist element
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <Pine.LNX.4.44L0.1003151721190.1332-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1003151721190.1332-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100316081620R.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 16 Mar 2010 08:16:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010 17:30:19 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> This is addressed to James Bottomley as he is the author of
> Documentation/DMA-API.txt, but anyone else who can contribute is
> invited to do so.
> 
> Suppose a scatter-gather transfer with multiple scatterlist elements
> has been mapped via dma_map_sg().  Is it then valid to call 
> dma_sync_sg_for_cpu() with the "sg" argument pointing to one of the 
> mapped scatterlist elements (not necessarily the first one) and the 
> "nelems" argument set to 1?

As James said, probably it works. As long as passed scatterlist
elements points to mapped regions, it works.

However, I think that the latest DMA-API.txt makes it clear that only
dma_sync_single_for_{cpu|device} supports a partial sync. So it's not
recommended, I guess.
