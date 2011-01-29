Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1A2IsV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 03:48:21 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52406 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab1A2IsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 03:48:20 -0500
Subject: Re: [PATCH 3/7] [v2] zram/xvmalloc: free bit block insertion
 optimization
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110128145853.GD2062@linux.vnet.ibm.com>
References: <20110128145602.GA2062@linux.vnet.ibm.com>
	 <20110128145853.GD2062@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sat, 29 Jan 2011 10:48:18 +0200
Message-ID: <1296290898.30654.7.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 08:58 -0600, Robert Jennings wrote:
> This change is in a conditional block which is entered only when there is
> an existing data block on the freelist where the insert has taken place.
> 
> The new block is pushed onto the freelist stack and this conditional block
> is updating links in the prior stack head to point to the new stack head.
> After this conditional block the first-/second-level indices are updated
> to indicate that there is a free block at this location.
> 
> This patch adds an immediate return from the conditional block to avoid
> setting bits again to indicate a free block on this freelist. The bits
> would already be set because there was an existing free block on this
> freelist.
> 
> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>

