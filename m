Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab1BIXmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 18:42:39 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53839 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab1BIXmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 18:42:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E8ErUhTxtz7gHkGzoaImMx0SjB5caxk3ha4fpzpeQeuyurm06F7mQbEd0qN2lny03A
         va+rsXnVydXfIiuOx1HoXQatZ7cPWMVWcriOAMnPP8c6UcdtcYE7gko/Lh8y8/KfprDG
         IBtQPtbrUg+KVVuh3f5QJUBxTq/ZdPaltp4AI=
Date: Wed, 9 Feb 2011 15:42:31 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] misc: add CARMA DATA-FPGA Access Driver
Message-ID: <20110209234231.GA5707@core.coreip.homeip.net>
References: <1297208267-27087-1-git-send-email-iws@ovro.caltech.edu>
 <1297208267-27087-2-git-send-email-iws@ovro.caltech.edu>
 <20110209083325.GA7256@core.coreip.homeip.net>
 <20110209173532.GB21766@ovro.caltech.edu>
 <20110209182740.GC23867@core.coreip.homeip.net>
 <20110209233544.GA5303@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110209233544.GA5303@ovro.caltech.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 03:35:45PM -0800, Ira W. Snyder wrote:
> On Wed, Feb 09, 2011 at 10:27:40AM -0800, Dmitry Torokhov wrote:
> 
> [ snip stuff I've already fixed in the next version ]
> 
> > > 
> > > The requirement is that the device stay open during reconfiguration.
> > > This provides for that. Readers just block for as long as the device is
> > > not producing data.
> > 
> > OK, you still need to make sure you do not touch free/used buffer while
> > device is disabled. Also, you need to kick readers if you unbind the
> > driver, so maybe a new flag priv->exists should be introduced and
> > checked.
> > 
> 
> I don't understand what you mean by "kick readers if you unbind the
> driver". The kernel automatically increases the refcount on a module
> when a process is using the module. This shows up in the "Used by"
> column of lsmod's output.
> 
> The kernel will not let you rmmod a module with a non-zero refcount. You
> cannot get into the situation where you have rmmod'ed the module and a
> reader is still blocking in read()/poll().

However you can still unbind the driver from the device by writing into
driver's sysfs 'unbind' attribute.

See drivers/base/bus.c::driver_unbind().

Thanks.

-- 
Dmitry
