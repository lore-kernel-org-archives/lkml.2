Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab0LSIhR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 03:37:17 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64408 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab0LSIhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 03:37:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H1tNTM07tlTlEvs/bKT5hXXgrd4OvVRqWpjkWAP7nKwZGN6rUHPyYTp73HrMoRcC2D
         gM8LcAD0OntUT9EbVVXhSB84KZudQF2kCBXATU1EiQdql6MNcKAweszWKcslfzKig/iO
         PmpPfQPrEPZIVCQOyyWdn8caoyEWhbnzbDsPo=
Date: Sun, 19 Dec 2010 00:37:09 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Daniel Drake <dsd@laptop.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, pgf@laptop.org,
        James Cameron <quozl@laptop.org>
Subject: Re: [PATCH] psmouse: disable the synaptics extension on OLPC
 machines.
Message-ID: <20101219083709.GE10074@core.coreip.homeip.net>
References: <20101217210939.19b6111a@queued.net>
 <20101218054927.GA14718@core.coreip.homeip.net>
 <20101217221447.375b9977@queued.net>
 <20101218070205.GA15847@core.coreip.homeip.net>
 <AANLkTimmcCB455DKt1jMVsLUTr5GdiUgFQzOWeiio361@mail.gmail.com>
 <20101219082026.GD10074@core.coreip.homeip.net>
 <20101219003214.26f1a6b1@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101219003214.26f1a6b1@queued.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 12:32:14AM -0800, Andres Salomon wrote:
> On Sun, 19 Dec 2010 00:20:27 -0800
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > On Sat, Dec 18, 2010 at 10:00:51AM +0000, Daniel Drake wrote:
> > > On 18 December 2010 07:02, Dmitry Torokhov
> > > <dmitry.torokhov@gmail.com> wrote:
> > > > What about just adding psmouse.proto=exps then?
> > > 
> > > It's not quite that simple either, because we want the same distro
> > > image to work on all versions of XO. XO's can come with either hgpk,
> > > synaptics, or sentelic touchpads. In the sentelic and hgpk cases,
> > > we'd want the "real" drivers to kick in.
> > > 
> > 
> > Hmm, I am confused. HGPK depends on OLPC so your distribution must
> > have it defined. Are there general purpose distributions that enable
> > OLPC?
> 
> 
> Yes, Debian enables CONFIG_OLPC in its 486 kernel (and one of these
> days, I'll open up a bug for them to enable it in their 686 kernel).
> 
> There are 3 types of touchpads in OLPC XO machines (hgpk, synaptics,
> and sentelics).  If the hardware is either hgpk or sentelics, we want
> those extensions to load.  If the hardware is synaptics, we want the
> extension not to load.  Doing this via kernel
> arg doesn't work, as a generic distributions (and even those built
> specifically for OLPC XOs) will not know which touchpad hardware will
> be in use.
> 

It still should be theoretically possible to do it in userspace (playing
with protocol settings via sysfs) but I think in kernel is less painful.
I'll apply the patch.

Thanks for the explanations.

-- 
Dmitry
