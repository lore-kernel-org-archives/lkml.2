Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab0DTUnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 16:43:09 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:47498 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab0DTUnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 16:43:06 -0400
Date: Tue, 20 Apr 2010 13:42:58 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Greg KH <gregkh@suse.de>
Cc: stefani@seibold.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, andi@firstfloor.org,
       alan@lxorguk.ukuu.org.uk, tytso@mit.edu
Subject: Re: [PATCH 0/4] enhanced reimplemention of the kfifo API
Message-ID: <20100420204258.GK7651@ovro.caltech.edu>
References: <1271794000-18897-1-git-send-email-stefani@seibold.net>
 <20100420201642.GA32373@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100420201642.GA32373@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Tue, 20 Apr 2010 13:43:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 01:16:42PM -0700, Greg KH wrote:
> On Tue, Apr 20, 2010 at 10:06:36PM +0200, stefani@seibold.net wrote:
> > From: Stefani Seibold <stefani@seibold.net>
> > 
> > This is a complete reimplementation of the new kfifo API, which is now 
> > really generic, type save and type definable. 
> > 
> > The API is still stable, no code which use the current  kfifo API must 
> > be modified!
> > 
> > Here are the results of the text section usage:
> > 
> > Example 1:
> >                         kfifo_put/_get  kfifo_in/out    current kfifo
> > dynamic allocated       0x000002a8      0x00000291      0x00000299
> > in place                0x00000291      0x0000026e      0x00000273
> > 
> > kfifo.c                 new             old
> > text section size       0x00000be5      0x000008b2
> > 
> > As you can see, kfifo_put/kfifo_get creates a little bit more code than 
> > kfifo_in/kfifo_out, but it is much faster (the code is inline).
> > 
> > The code is complete hand crafted and optimized. The text section size is as 
> > small as possible. You get all the fifo handling in only 3 kb. This includes 
> > type safe fix size records, dynamic records and DMA handling.
> > 
> > This should be the final version. All requested features are implemented.
> > 
> > Note: Most features of this API doesn't have any users. All functions which
> > are not used in the next 9 months will be removed. So, please adapt your
> > drivers and other sources as soon as possible to the new API and post it. 
> > 
> > This are the features which are currently not used in the kernel:
> > 
> > kfifo_to_user()
> > kfifo_from_user()
> > kfifo_dma_....() macros
> > kfifo_esize()
> > kfifo_recsize()
> > kfifo_put()
> > kfifo_get()
> > the fixed size record elements, exclude "unsigned char" fifo's and
> > the variable size records fifo's
> 
> If you have features that have no users, why add them?  Do you think
> that some drivers need/want these features?
> 

As a user who has been following this patch set for quite a while, I
have uses in my drivers for the kfifo_*_user() functions as well as well
as the kfifo_dma_*() functions.

I'm not especially comfortable developing against changes that aren't
upstream, especially the "core infrastructure" type changes. This is the
reason I haven't ported to the updated kfifo API yet. I hunch other
"small time" developers have the same worries.

Unfortunately, my drivers are not upstream, as they're for very custom
hardware, and would not be useful on anything outside of my lab. I'm
happy to send the source to anyone interested.

Ira
