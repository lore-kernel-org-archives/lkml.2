Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab1CFPOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 10:14:38 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33416 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab1CFPOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 10:14:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=M76KK9kKWpLGEc6Wmnj6iuNiIJpJO/0qfdL6gQpcnYbqnS0NXPGPBYpkW7+4wns87v
         qItC9SGp0WgaNTCEkcS+ISjHrt1pAmytUnLar2emZSSy5Gc4zob1VBfg0C/CbFcIs0R3
         LcbZzOhVKpL02BKcNYtUgkJPZnj38eKOPfh6A=
Subject: Re: [PATCH 1/4] scatterlist: new helper functions
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        linux-kernel@vger.kernel.org, oakad@yahoo.com
In-Reply-To: <20110306162859E.fujita.tomonori@lab.ntt.co.jp>
References: <1299212213-4255-1-git-send-email-maximlevitsky@gmail.com>
	 <1299212213-4255-2-git-send-email-maximlevitsky@gmail.com>
	 <20110306162859E.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Mar 2011 17:14:30 +0200
Message-ID: <1299424470.22378.9.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-03-06 at 16:29 +0900, FUJITA Tomonori wrote:
> On Fri,  4 Mar 2011 06:16:50 +0200
> Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > While developing memstick driver for legacy memsticks
> > I found the need in few helpers that I think should be
> > in common scatterlist library
> > 
> > The functions that were added:
> > 
> > * sg_nents/sg_total_len - iterate over scatterlist to figure
> > out total length of memory it covers / number of entries.
> 
> You should invent a data structure per I/O request, something like
> msb_request structure. Then you can store nents and total_len in
> that.
> 
> That's what block subsystems and drivers do. I took a look at your
> driver but I can't see why your driver can't do the same.
I also need to break the request into small grained chunks.
If I invent such structure, I will end up writing these helpers for it.

The I have this lifetime of a request:

I get arbitary sized request from block layer (I can of course control
maximum size/number of segments in it, etc).

I break it into eraseblock sized chunks, and for each I translate the
the LBA, into flash address.

Then I break it into flash page sized requests (512 bytes), and yet its
better not to assume that such requests always contained in one sg
entry.

Worse than that, I have to pass an sg list that spans always one 512
page to lowlevel driver, because thats how Alex defined the interface.
 
Thats why I coded it this way.

Folks, really what the status of this, when to expect it to be merged?

If you think some of helper functions don't belong to scatterlist.c,
just tell me to move them back to ms_block.c.

Andrew, please note again that richoh lowlevel driver doesn't need any
helper functions, its patch is standalone and thus should be merged
regardless.

Best regards,
	Maxim Levitsky

