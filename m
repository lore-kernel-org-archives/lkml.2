Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068Ab2EWOE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:04:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53310 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2EWOE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:04:57 -0400
Date: Wed, 23 May 2012 07:04:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Staging: ipack/bridges/tpci200: remove
 TPCI200_SHORTNAME constant
Message-ID: <20120523140451.GA8088@kroah.com>
References: <1337332208-26057-1-git-send-email-siglesias@igalia.com>
 <1337332208-26057-3-git-send-email-siglesias@igalia.com>
 <20120519003724.GA10111@kroah.com>
 <1337768001.3666.6.camel@fourier.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1337768001.3666.6.camel@fourier.local.igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 12:13:21PM +0200, Samuel Iglesias Gonsálvez wrote:
> On Fri, 2012-05-18 at 17:37 -0700, Greg Kroah-Hartman wrote:
> [...]
> > >  	if (dev->slot >= TPCI200_NB_SLOT) {
> > > -		pr_info("Slot [%s %d:%d] doesn't exist! Last tpci200 slot is %d.\n",
> > > -			TPCI200_SHORTNAME, dev->bus_nr, dev->slot,
> > > -			TPCI200_NB_SLOT-1);
> > > +		pr_info("Slot [%d:%d] doesn't exist! Last tpci200 slot is %d.\n",
> > > +			dev->bus_nr, dev->slot, TPCI200_NB_SLOT-1);
> > 
> > All of these should really be dev_err() calls, right?
> > 
> > You should have no pr_* calls at all in any driver, and probably none in
> > the ipack core as well, care to fix them all up?
> 
> Yes, I will fix it in the next bunch of patches. I don't forget it.
> 
> By the way, sometime ago, you suggested me to use the ics interface for
> giving the bus number if there is no HW boundary of the number of them.
> However, I searched the source code and I didn't find any reference to
> the ics interface. Can you tell me where is it declared?

My appologies, I should have said "idr" interface, there is a reason why
you couldn't find any "ics" code :)

Sorry about that,

greg k-h
