Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab0J0PlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:41:01 -0400
Received: from bunsen.bytemark.co.uk ([80.68.81.6]:54279 "EHLO
	bunsen.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab0J0Pk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:40:58 -0400
Date: Wed, 27 Oct 2010 11:40:46 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: Re: [PATCH 27/30] staging/vme: rework the bus model
Message-ID: <20101027154046.GT10869@flamenco.cs.columbia.edu>
References: <1287729412-24356-1-git-send-email-cota@braap.org>
 <1287729412-24356-28-git-send-email-cota@braap.org>
 <20101022232707.GA1370@braap.org>
 <4CC568F6.2070207@ge.com>
 <20101026010218.GO10869@flamenco.cs.columbia.edu>
 <4CC7EDE5.6040009@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC7EDE5.6040009@ge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 10:16:21 +0100, Martyn Welch wrote:
> On 26/10/10 02:02, Emilio G. Cota wrote:
> > On Mon, Oct 25, 2010 at 12:24:38 +0100, Martyn Welch wrote:
> >> On 23/10/10 00:27, Emilio G. Cota wrote:
> >>>> * installing drivers even before the bridges they need are present
> >>>>   seems counter-intuitive and wrong.
> >>
> >> There are plenty of instances where a driver can be loaded before the
> >> bus is probed or a device is even present. When the bus become
> >> available, the probe routine will be run.
> > 
> > That would be acceptable if and only if no other alternative was available.
> > 
> > It doesn't make any sense to constrain ourselves to installing
> > drivers only BEFORE loading bridge drivers.
> > 
> 
> I have no idea what your doing, but that simply isn't the case. Your
> right - that really would not make any sense, however I'm happily
> loading the bridge drivers before any VME device drivers here.

/me scratches his head and goes back the code again.

I see, so after calling driver_register() the core will initiate
the binding--I was wrongly thinking that binding would only happen
after registering a device with device_register().

In fact I claimed this from what I remembered from the code. But
this was months ago, and my memory is highly unreliable.
Sorry about that :(


However I just remembered something, related to the unique slot
numbers. Let me know if this is correct or not, but in fact
I think this is what triggered me to write a new model.

Imagine the following situation:

- insmod vme_driver1.ko bus=0,0,0 slot=1,2,3

Then two days after I want to install another driver:

- insmod vme_driver2.ko bus=0,0,0 slot=X,Y,Z

Now X,Y,Z cannot be in (1,2,3), because those are understood
as physical slots, even if they're not (this is not VME64x)

So, anytime I need to install a device, I must know the slot
numbers of all other devices--even though there's no
physical meaning to it!

In the model I proposed device id's ("slots") are unique
to each driver.

Does this make sense?

Cheers

		Emilio
