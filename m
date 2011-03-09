Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab1CIR0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:26:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51214 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756900Ab1CIR0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:26:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FmG/LPUF80scP1oUJRVJNdIwYlXngsMYu679KQp+SfP9sy7bgej5zGaDW6U/k7RYiA
         mBn2qBlmQrmiytxi8j3NdrrQ4LUirnJRDeKMADh5ZhdnfGlxl5iwbiGGGqialmJcaYWY
         bxx7BK2YqMZ5ybFpsceaPwSl90W4X9eInIy7k=
Subject: Re: [PATCH 1/4] scatterlist: new helper functions
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        linux-kernel@vger.kernel.org, oakad@yahoo.com
In-Reply-To: <1299464437.24051.13.camel@maxim-laptop>
References: <1299212213-4255-2-git-send-email-maximlevitsky@gmail.com>
	 <20110306162859E.fujita.tomonori@lab.ntt.co.jp>
	 <1299424470.22378.9.camel@maxim-laptop>
	 <20110307064900X.fujita.tomonori@lab.ntt.co.jp>
	 <1299464437.24051.13.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Mar 2011 19:24:55 +0200
Message-ID: <1299691495.27835.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 04:20 +0200, Maxim Levitsky wrote:
> On Mon, 2011-03-07 at 06:49 +0900, FUJITA Tomonori wrote:
> > On Sun, 06 Mar 2011 17:14:30 +0200
> > Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > 
> > > On Sun, 2011-03-06 at 16:29 +0900, FUJITA Tomonori wrote:
> > > > On Fri,  4 Mar 2011 06:16:50 +0200
> > > > Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > > > 
> > > > > While developing memstick driver for legacy memsticks
> > > > > I found the need in few helpers that I think should be
> > > > > in common scatterlist library
> > > > > 
> > > > > The functions that were added:
> > > > > 
> > > > > * sg_nents/sg_total_len - iterate over scatterlist to figure
> > > > > out total length of memory it covers / number of entries.
> > > > 
> > > > You should invent a data structure per I/O request, something like
> > > > msb_request structure. Then you can store nents and total_len in
> > > > that.
> > > > 
> > > > That's what block subsystems and drivers do. I took a look at your
> > > > driver but I can't see why your driver can't do the same.
> > > I also need to break the request into small grained chunks.
> > > If I invent such structure, I will end up writing these helpers for it.
> > > 
> > > The I have this lifetime of a request:
> > > 
> > > I get arbitary sized request from block layer (I can of course control
> > > maximum size/number of segments in it, etc).
> > > 
> > > I break it into eraseblock sized chunks, and for each I translate the
> > > the LBA, into flash address.
> > > 
> > > Then I break it into flash page sized requests (512 bytes), and yet its
> > > better not to assume that such requests always contained in one sg
> > > entry.
> > > 
> > > Worse than that, I have to pass an sg list that spans always one 512
> > > page to lowlevel driver, because thats how Alex defined the interface.
> > 
> > This restriction is due to hardware specification or the software
> > design (e.g. memstick layer)? If it is due to the latter, why can't
> > you fix that?
> 
> Yes.
> I already tried addressing some shortcomings of memstick layer, no no, I
> don't want to deal with its author, Alex Dubov again.
> I think this code tries to be too clever/complex for the range of
> devices/speeds it supports, but I rather leave it as is.
> 
> 
> To be honest, the code in question is for >5 year old memstick standard
> cards, thats hardly anybody uses.
> It works, it is more or less simple, its not performance bound, its
> testd, and thus I want to keep it as is _for_ now.
> 
> 
> Why I break sg lists into chunks?
> Because unlike vast majority of block devices, I need to do FTL in the
> driver, thus its easier to work on eraseblock boundary.
> Also unlike anything else, you can't just read/write a sector from a
> memorystick (especially the legacy one), you have to perform full dance
> of commands.
> 
> Not to mention error handling (like if you failed to write to block, you
> must try to choose another one, etc...)
> 
> (Of course writes follow same rules as raw nand flash, thats is writes
> only clear bits, and you can erase a eraseblock only).
> 
> 
> 
> > 
> > Why can't the block layer split requests for you? It's better to let
> > the block layer handle that.
> You mean tell it not to give me more that one eraseblock to handle?
> Could you explain that a bit more?
> 
> 
> Anyway, could we merge the code?
> I would happy to improve it later, but currently merge window is very
> close, and the code is more or less agreed upon everyone, and written
> more that 1/2 of year ago.
> 
> Andrew Morton, could you help me with this, Please?
Ping (I really worry about this).

> 
> 
> Best regards,
> 	Maxim Levitsky
> 
> > 
> > 
> > > Folks, really what the status of this, when to expect it to be merged?
> > > 
> > > If you think some of helper functions don't belong to scatterlist.c,
> > > just tell me to move them back to ms_block.c.
> > > 
> > > Andrew, please note again that richoh lowlevel driver doesn't need any
> > > helper functions, its patch is standalone and thus should be merged
> > > regardless.
> > 
> > I think that we need to make the design of the driver easily
> > understandable to kernel developers and maintainable by them. I don't
> > think that this is 'standalone or not' issue.
> > 
> > Adding a doc about why the driver is designed in such odd way would be
> > helpful. But I still think that we could design the driver in a better
> > way.
> 
> 


