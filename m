Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1HaUhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 16:37:24 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:58642 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab1HaUhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 16:37:21 -0400
Date: Wed, 31 Aug 2011 16:36:51 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: gregkh@suse.de, martyn.welch@ge.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] [RESEND v4] VME Framework Fixes
Message-ID: <20110831203651.GA5339@flamenco.cs.columbia.edu>
References: <1314785146-19163-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314785146-19163-1-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 12:05:43 +0200, Manohar Vanga wrote:
> Hi Greg, Martyn,
> 
> I have reordered the patches to separate the bridge refcounting patch
> for now so that we can make some progress on getting the other patches
> into the tree. I will rework the refcounting patch and send it later.

(snip to 3rd patch comment)

> * staging: vme: make match() driver specific to improve non-VME64x
>     support
> 	Changes based on the moving of the bridge refcounting patch as well
> 	as changes based on comments from Emilio and Greg in the last resend.

I'm confused. AFAICT you should fix things here; as per Greg's post:

On Mon, Aug 29, 2011 at 11:54:03 -0700, Greg KH wrote:
> On Mon, Aug 29, 2011 at 02:40:12PM -0400, Emilio G. Cota wrote:
> > AFAIK currently a vme bridge driver can be freely removed with rmmod
> > even if it has devices under it. The patch avoids this by increasing
> > the refcount of the bridge module every time a device is registered
> > under it.
> >
> > What's the appropriate thing to do when rmmod tries to remove a bridge
> > module?
>
> Let it happen and remove all of the devices under it.
>
> That's the way all other bus drivers in the kernel work, why change this
> type of behavior?

When a bridge is removed, just remove the devices under it. Refcounts
in this case are not necessary; in fact refcounts where used to avoid
a bridge being removed while it had devices under it, which it turns
out was a bad idea.

		Emilio
