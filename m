Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202Ab2KOVgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:36:39 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:61612 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2KOVgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:36:38 -0500
Date: Thu, 15 Nov 2012 19:07:48 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, ulisses@profusion.mobi, marcel@holtmann.org,
        Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
Subject: Re: [ 01/82] Bluetooth: Always compile SCO and L2CAP in Bluetooth
 Core
Message-ID: <20121115210748.GB3358@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Ben Hutchings <ben@decadent.org.uk>,
	David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, ulisses@profusion.mobi,
	marcel@holtmann.org,
	Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
References: <20121114053933.726869752@decadent.org.uk>
 <20121114053933.935584768@decadent.org.uk>
 <20121114212426.GA1866@joana>
 <20121114.163044.2287972932330697472.davem@davemloft.net>
 <20121114213819.GT13292@decadent.org.uk>
 <1353009872.4867.68.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353009872.4867.68.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

* Ben Hutchings <ben@decadent.org.uk> [2012-11-15 20:04:32 +0000]:

> On Wed, 2012-11-14 at 21:38 +0000, Ben Hutchings wrote:
> > On Wed, Nov 14, 2012 at 04:30:44PM -0500, David Miller wrote:
> > > From: Gustavo Padovan <gustavo@padovan.org>
> > > Date: Wed, 14 Nov 2012 19:24:26 -0200
> > > 
> > > > Hi Ben,
> > > > 
> > > > * Ben Hutchings <ben@decadent.org.uk> [2012-11-14 05:39:34 +0000]:
> > > > 
> > > >> 3.2-stable review patch.  If anyone has any objections, please let me know.
> > > >> 
> > > >> ------------------
> > > >> 
> > > >> From: Ulisses Furquim <ulisses@profusion.mobi>
> > > >> 
> > > >> commit f1e91e1640d808d332498a6b09b2bcd01462eff9 upstream.
> > > >> 
> > > >> The handling of SCO audio links and the L2CAP protocol are essential to
> > > >> any system with Bluetooth thus are always compiled in from now on.
> > > > 
> > > > I wonder if this could not break any kind of script or code people have that
> > > > refer directly to the sco and l2cap modules. Also I don't see this change as
> > > > really necessary for 3.2.
> > > 
> > > Agreed, I wish this had not been merged into -stable, I would have never
> > > submitted a patch like this myself.
> > 
> > This is required by:
> > 
> > commit ff03261adc8b4bdd8291f1783c079b53a892b429
> > Author: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
> > Date:   Thu Aug 23 21:32:44 2012 -0300
> > 
> >     Bluetooth: Fix sending a HCI Authorization Request over LE links
> >     
> >     commit d8343f125710fb596f7a88cd756679f14f4e77b9 upstream.
> > 
> > which was already applied.
> 
> So, do you think it's better to revert that in 3.2, or to go ahead with
> this?

I suggest you to revert it. There is a much simpler solution if revert, fix
the patch and apply it again. No need to push this module merge patch here.

The problem seems to be only a missing EXPORT_SYMBOL of the smp.c method. That
should fix it. If you want me to fix that just ask me.

	Gustavo
