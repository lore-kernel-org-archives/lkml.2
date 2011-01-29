Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab1A2Iur (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 03:50:47 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51989 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab1A2Iuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 03:50:46 -0500
Subject: Re: [PATCH 7/7] zram/xvmalloc: combine duplicate block delete code
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110128150155.GH2062@linux.vnet.ibm.com>
References: <20110128145602.GA2062@linux.vnet.ibm.com>
	 <20110128150155.GH2062@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sat, 29 Jan 2011 10:50:38 +0200
Message-ID: <1296291038.30654.11.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 09:01 -0600, Robert Jennings wrote:
> This patch eliminates duplicate code.  The remove_block_head function
> is a special case of remove_block which can be contained in remove_block
> without confusion.
> 
> The portion of code in remove_block_head which was noted as "DEBUG ONLY"
> is now mandatory.  Doing this provides consistent management of the double
> linked list of blocks under a freelist and makes this consolidation
> of delete block code safe.  The first and last blocks will have NULL
> pointers in their previous and next page pointers respectively.
> 
> Additionally, any time a block is removed from a free list the next and
> previous pointers will be set to NULL to avoid misuse outside xvmalloc.
> 
> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>

Looks OK to me but we should really get Nitin's ACK for this.

Reviewed-by: Pekka Enberg <penberg@kernel.org>

