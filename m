Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab0FIWQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:16:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753975Ab0FIWQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:16:50 -0400
Date: Wed, 9 Jun 2010 15:15:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: TAMUKI Shoichi <tamuki@linet.gr.jp>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Blanchard <anton@samba.org>,
       Andi Kleen <andi@firstfloor.org>, Andy Green <andy@warmcat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] panic: keep blinking in spite of long spin timer
 mode
Message-Id: <20100609151552.d1a8ca8d.akpm@linux-foundation.org>
In-Reply-To: <201006061319.AA01345@tamuki.linet.gr.jp>
References: <20100603153016.cbe6ff0c.akpm@linux-foundation.org>
	<201006061319.AA01345@tamuki.linet.gr.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 Jun 2010 22:19:18 +0900
TAMUKI Shoichi <tamuki@linet.gr.jp> wrote:

> Hello,
> 
> Thank you for the review.
> 
> On Thu, 3 Jun 2010 15:30:16 -0700 Andrew Morton wrote:
> 
> > > +	panicblink=	[KNL] The speed of panic blink (default is 12 wpm)
> > > +			The period of panic blink can be computed by the
> > > +			formula T = 7200 / W, where T is the period in milli-
> > > +			seconds, W is the speed in wpm (words per minute).
> > > +			Should be 5 or less when running under a hypervisor
> > 
> > Nobody will know what "wpm" means.  What is a "word" in this context?
> > Unclear.
> > 
> > How about "bpm": "blinks per minute".  That's nice and direct.
> 
> The current explanation of panicblink= still makes no sense, indeed.
> 
> "bpm" seems to be nice and direct, but the range at a practicable
> blinking speed will be 8.33 to 833 bpm.  That is too wide and the step
> size is too small for the speed of panic blink.  That will be hard to
> deal with.
> 
> OTOH, the range at a practicable blinking speed in "wpm" fits in 1 to
> 100.  I think that will sit well with us.
> 
> Now, I need to explain what "wpm" means and what a "word" in the con-
> text is:
> 
> The speed of morse code is measured in wpm, which defines the speed of
> morse transmission as the timing needed to send the word "PARIS" a
> given number of times per minute.
> 
> The time for one (minimum) unit can be computed by the formula T =
> 1200 / W, where T is the unit time in milliseconds, W is the speed in
> wpm.  The panic blink here is assumed as a word of infinite length to
> which "T" continues (i.e. "TTTTTTTT...").  The letter "T" represents
> three units long and the short gap (between letters) also represents
> three units long.  The period of panic blink thus can be computed by
> the formula T = 7200 / W.

Morse code?  Kidding?

Sorry, no.  Nobody who uses this feature will know what what
"words per minute" means.  It's nutty!

Please remind me why we're making this configurable at all.  Can't we
just hardwire the thing to 1Hz or something?  Add an
im_using_a_hypervisor boot option or something, if necessary?

