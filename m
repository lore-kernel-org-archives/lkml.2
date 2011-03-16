Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab1CPCgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:36:22 -0400
Received: from sh.osrg.net ([192.16.179.4]:55164 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab1CPCgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:36:20 -0400
Date: Wed, 16 Mar 2011 11:35:35 +0900
To: akpm@linux-foundation.org
Cc: maximlevitsky@gmail.com, fujita.tomonori@lab.ntt.co.jp,
        James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
        oakad@yahoo.com
Subject: Re: [PATCH 1/4] scatterlist: new helper functions
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20110315174459.54b02f99.akpm@linux-foundation.org>
References: <20110307064900X.fujita.tomonori@lab.ntt.co.jp>
	<1299464437.24051.13.camel@maxim-laptop>
	<20110315174459.54b02f99.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110316113527C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 16 Mar 2011 11:35:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011 17:44:59 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > > This restriction is due to hardware specification or the software
> > > design (e.g. memstick layer)? If it is due to the latter, why can't
> > > you fix that?
> > 
> > Yes.
> > I already tried addressing some shortcomings of memstick layer, no no, I
> > don't want to deal with its author, Alex Dubov again.
> > I think this code tries to be too clever/complex for the range of
> > devices/speeds it supports, but I rather leave it as is.
> > 
> 
> I have to say, these aren't very good reasons for a particular
> implementation!

Agreed. We need to fix it.


> > To be honest, the code in question is for >5 year old memstick standard
> > cards, thats hardly anybody uses.
> > It works, it is more or less simple, its not performance bound, its
> > testd, and thus I want to keep it as is _for_ now.
> > 
> > 
> > Why I break sg lists into chunks?
> > Because unlike vast majority of block devices, I need to do FTL in the
> > driver, thus its easier to work on eraseblock boundary.
> > Also unlike anything else, you can't just read/write a sector from a
> > memorystick (especially the legacy one), you have to perform full dance
> > of commands.
> > 
> > Not to mention error handling (like if you failed to write to block, you
> > must try to choose another one, etc...)
> > 
> > (Of course writes follow same rules as raw nand flash, thats is writes
> > only clear bits, and you can erase a eraseblock only).
> 
> hm.  If you think there's little likelihood that other drivers will
> need the new sg functions in the future then perhaps they should be
> made private to the memstick driver, rather than bloating everyone's
> kernels.  Which is, I think, the exact opposite of what I suggested
> last year :(
> 
> Fujita-san, you've gone all quiet.  Do you believe that these functions
> should be added to the sg API?

I don't think so.

Splitting (or merging) a request and playing with sg lists inside a
driver is a bad idea. Such should be done in the block layer.

I still don't see why the block layer can't do that for the driver.

I believe that the helper functions for such should not be added.
