Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023Ab2KOVcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:32:09 -0500
Received: from mail-gg0-f174.google.com ([209.85.161.174]:41796 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2KOVcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:32:08 -0500
Date: Thu, 15 Nov 2012 19:04:37 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: David Miller <davem@davemloft.net>
Cc: ben@decadent.org.uk, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        ulisses@profusion.mobi, marcel@holtmann.org,
        vinicius.gomes@openbossa.org, linville@tuxdriver.com,
        johan.hedberg@gmail.com
Subject: Re: [ 01/82] Bluetooth: Always compile SCO and L2CAP in Bluetooth
 Core
Message-ID: <20121115210437.GA3358@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	David Miller <davem@davemloft.net>, ben@decadent.org.uk,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	ulisses@profusion.mobi, marcel@holtmann.org,
	vinicius.gomes@openbossa.org, linville@tuxdriver.com,
	johan.hedberg@gmail.com
References: <20121114.163044.2287972932330697472.davem@davemloft.net>
 <20121114213819.GT13292@decadent.org.uk>
 <1353009872.4867.68.camel@deadeye.wl.decadent.org.uk>
 <20121115.151341.694285418420091290.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121115.151341.694285418420091290.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

* David Miller <davem@davemloft.net> [2012-11-15 15:13:41 -0500]:

> From: Ben Hutchings <ben@decadent.org.uk>
> Date: Thu, 15 Nov 2012 20:04:32 +0000
> 
> > On Wed, 2012-11-14 at 21:38 +0000, Ben Hutchings wrote:
> >> On Wed, Nov 14, 2012 at 04:30:44PM -0500, David Miller wrote:
> >> > From: Gustavo Padovan <gustavo@padovan.org>
> >> > Date: Wed, 14 Nov 2012 19:24:26 -0200
> >> > 
> >> > > Hi Ben,
> >> > > 
> >> > > * Ben Hutchings <ben@decadent.org.uk> [2012-11-14 05:39:34 +0000]:
> >> > > 
> >> > >> 3.2-stable review patch.  If anyone has any objections, please let me know.
> >> > >> 
> >> > >> ------------------
> >> > >> 
> >> > >> From: Ulisses Furquim <ulisses@profusion.mobi>
> >> > >> 
> >> > >> commit f1e91e1640d808d332498a6b09b2bcd01462eff9 upstream.
> >> > >> 
> >> > >> The handling of SCO audio links and the L2CAP protocol are essential to
> >> > >> any system with Bluetooth thus are always compiled in from now on.
> >> > > 
> >> > > I wonder if this could not break any kind of script or code people have that
> >> > > refer directly to the sco and l2cap modules. Also I don't see this change as
> >> > > really necessary for 3.2.
> >> > 
> >> > Agreed, I wish this had not been merged into -stable, I would have never
> >> > submitted a patch like this myself.
> >> 
> >> This is required by:
> >> 
> >> commit ff03261adc8b4bdd8291f1783c079b53a892b429
> >> Author: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
> >> Date:   Thu Aug 23 21:32:44 2012 -0300
> >> 
> >>     Bluetooth: Fix sending a HCI Authorization Request over LE links
> >>     
> >>     commit d8343f125710fb596f7a88cd756679f14f4e77b9 upstream.
> >> 
> >> which was already applied.
> > 
> > So, do you think it's better to revert that in 3.2, or to go ahead with
> > this?
> 
> I can't believe that just turning on bluetooth is going to force
> enable these sub-protocols too, that's simply rediculous.  That
> change should have never gone into the tree.

I think you should go and try to understand our subsystem better, if one
wants use bluetooth on linux he/she needs HCI core, L2CAP and SCO. Those were
three different modules in the past, but at some point we concluded it does not
makes sense to have the split. L2CAP for example is needed for every bluetooth
usage out there, it is really part of the core. It useless to load the
bluetooth core module without l2cap and sco. There is a technical decision
behind this that we, the bluetooth folk, think it is better this way.

> Do I _REALLY_ have to go back to validating all the bluetooth stuff by
> hand when John Linville sends me pull requests?  Seriously?
> 
> I thought we were beyond that kind of bullshit after the coding style
> fiasco.
> 
> Actually I have a better idea, how about John stops pulling the
> bluetooth stuff into his tree, and instead the bluetooth folks have to
> submit their changes individually to the netdev list.  I like that
> scheme better.

We will no put our stuff in netdev. I'll keep pushing patches to
bluetooth-next, our community needs this tree.

	Gustavo
