Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263Ab1CPEzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 00:55:49 -0400
Received: from sh.osrg.net ([192.16.179.4]:58768 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab1CPEzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 00:55:45 -0400
Date: Wed, 16 Mar 2011 13:55:32 +0900
To: oakad@yahoo.com
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
        maximlevitsky@gmail.com, James.Bottomley@HansenPartnership.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] scatterlist: new helper functions
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <403815.22502.qm@web37607.mail.mud.yahoo.com>
References: <20110316113527C.fujita.tomonori@lab.ntt.co.jp>
	<403815.22502.qm@web37607.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110316135528U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 16 Mar 2011 13:55:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011 21:18:14 -0700 (PDT)
Alex Dubov <oakad@yahoo.com> wrote:

> 
> > 
> > I don't think so.
> > 
> > Splitting (or merging) a request and playing with sg lists
> > inside a
> > driver is a bad idea. Such should be done in the block
> > layer.
> > 
> > I still don't see why the block layer can't do that for the
> > driver.
> > 
> > I believe that the helper functions for such should not be
> > added.
> > 
> 
> 
> In a particular case of flash-like devices, letting the block layer
> split requests into memory sequential blocks too often results in
> unnecessary fragmentation of writes/erases.

Why?

Why can't the block layer split a request in the way the driver wants
to do?

That is, why can't the driver tell the block layer how to split a
request?


> If only one sg entry is requested from the block layer, it will be (more
> often than not) only 1 or 2 pages in length, even if total size of
> prospective write request spans multiple erase blocks.

In this case, what does the driver do? Why can't the block layer do
the same?


> So there are really only two options for legacy memorystick driver:
> 1. Play with scatterlists explicitly.
> 2. Make it an MTD backend, rather then stand-alone block device.
> 
> The second option makes more sense, but it is not necessarily the optimal
> approach for implementation of this particular media format.
> 
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
