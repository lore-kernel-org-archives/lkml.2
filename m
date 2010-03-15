Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937065Ab0COW7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 18:59:51 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48094 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937040Ab0COW7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 18:59:50 -0400
Subject: Re: dma_sync_sg_for_cpu applied to a single scatterlist element
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1003151721190.1332-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1003151721190.1332-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Mar 2010 18:59:45 -0400
Message-ID: <1268693985.2853.62.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-15 at 17:30 -0400, Alan Stern wrote:
> This is addressed to James Bottomley as he is the author of
> Documentation/DMA-API.txt, but anyone else who can contribute is
> invited to do so.
> 
> Suppose a scatter-gather transfer with multiple scatterlist elements
> has been mapped via dma_map_sg().  Is it then valid to call 
> dma_sync_sg_for_cpu() with the "sg" argument pointing to one of the 
> mapped scatterlist elements (not necessarily the first one) and the 
> "nelems" argument set to 1?

It's not the design of the API, but I'm guessing, given the way the API
works on most arch's that it will work.  However, if you just want a
single element sync'd, won't dma_sync_single_for_cpu do that
transparently (as in just feed in the address and length from the sg
list), without mucking with the sg API?

James


