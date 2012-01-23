Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab2AWTk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:40:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab2AWTk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:40:27 -0500
Date: Mon, 23 Jan 2012 11:40:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] staging: zsmalloc: zsmalloc memory allocation
 library
Message-Id: <20120123114025.afd48d17.akpm@linux-foundation.org>
In-Reply-To: <4F1DADA0.4030300@vflare.org>
References: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com>
	<1326149520-31720-2-git-send-email-sjenning@linux.vnet.ibm.com>
	<20120120141232.a7572919.akpm@linux-foundation.org>
	<4F1DADA0.4030300@vflare.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012 13:57:36 -0500
Nitin Gupta <ngupta@vflare.org> wrote:

> > afacit this code should be added to core mm/.  Addition of code like
> > this to core mm/ will be fiercely resisted on principle!  Hence the
> > (currently missing) justifications for adding it had best be good ones.
> > 
> 
> 
> I don't think this code should ever get into mm/ since its just a driver
> specific allocator.

Like mm/mempool.c and mm/dmapool.c ;)

> However its used by more than one driver (zcache and
> zram) so it may be moved to lib/ or drivers/zsmalloc atmost?

I'd need to take another look at the code, but if the allocator is a
good and useful thing then we want other kernel code to use it where
possible and appropriate. Putting it in mm/ or lib/ says "hey, use this".

The code is extensively poking around in MM internals, especially the
pageframe fields.  So I'd say it's a part of MM (in mm/) rather than a
clean client of MM, which would place it in lib/.


btw, kmap_atomic() already returns void*, so casting its return value
is unneeded.

