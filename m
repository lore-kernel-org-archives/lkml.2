Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab1BXMIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 07:08:21 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42082 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751754Ab1BXMIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 07:08:20 -0500
Date: Thu, 24 Feb 2011 12:10:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Airlie <airlied@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Intel GMA500 staging driver
Message-ID: <20110224121042.6fa3fe37@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTimPpr+OugTiPpYxNyS78vqActuURw-tnxJVxi18@mail.gmail.com>
References: <20110222121704.19437.4650.stgit@localhost.localdomain>
	<AANLkTimPpr+OugTiPpYxNyS78vqActuURw-tnxJVxi18@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So where do we want to go my opinion is
> 
> a) remove all userspace interfaces and simplify ttm memory management usage.

Some of them appear to be valid/sensible ones for querying mode data and
config bits. I'm slowly pruning out the rest

> b) add support to hook this up to the dumb ioctl so we can do trivial
> generic front buffer allocation, so then a libkms + dumb kms
> modesetting driver can work on it.

What sort of dumb ioctl do you have in mind ?

> c) figure out how to add interface for acceleration users. Whether TTM
> fence interfaces are required etc.

The fencing seems to be solely for the various capture/acceleration bits
for video as far as I can tell.

It seems we need two things - issue a 2D command and stuff for
transferring objects, although it's not clear that the latter is needed.

The old X 2D code is at:
http://git.moblin.org/cgit.cgi/deprecated/xf86-video-psb/


> We could probably just add a GEM style buffer allocation interface but
> we'd probably need to do a lot of RE first to figure out what best
> suits the hardware, I'm pretty sure I've haven't heard any glowing
> praise that the current interface suits the hw or is maintainable.

Nor me

I'll push the 2D bits to the tree but disabled (right now they go pop and
I've not pinned down what register or other incantation I've missed
somewhere) so there is a better view of what is needed.

Alan
