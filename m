Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab0CVUsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:48:46 -0400
Received: from dd13538.kasserver.com ([85.13.135.107]:49692 "EHLO
	dd13538.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab0CVUsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:48:45 -0400
X-Greylist: delayed 1928 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Mar 2010 16:48:45 EDT
Date: Mon, 22 Mar 2010 21:16:37 +0100
From: Andreas Bombe <aeb@debian.org>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Memory-mapped I/O barriers, state of affairs?
Message-ID: <20100322201637.GA8476@bombe-desk.opditex>
Mail-Followup-To: Leon Woestenberg <leon.woestenberg@gmail.com>,
	linux-kernel@vger.kernel.org
References: <c384c5ea1003221218o2dfcf445s8b7fd5c08076bdab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c384c5ea1003221218o2dfcf445s8b7fd5c08076bdab@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 08:18:49PM +0100, Leon Woestenberg wrote:
> What is the current solution for that particular problem, i.e. how
> should I make sure host memory writes are committed before I have an
> external DMA device act on it?

The dma_sync_* functions, if you reuse DMA buffers without unmapping,
take care of that.  Otherwise the process of mapping them handles it.

Documentation/DMA-API.txt and Documentation/PCI/PCI-DMA-mapping.txt
document those functions.
