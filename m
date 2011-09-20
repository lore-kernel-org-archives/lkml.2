Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab1ITWKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 18:10:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41880 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1ITWKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 18:10:09 -0400
Subject: Re: [PATCH] tg3: fix VLAN tagging regression
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Kasper Pedersen <kernel@kasperkp.dk>
Cc: Jesse Gross <jesse@nicira.com>, Matt Carlson <mcarlson@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4E790C5E.5000000@kasperkp.dk>
References: <4E78FC38.7040903@kasperkp.dk>
	 <20110920210929.GA9652@mcarlson.broadcom.com>
	 <CAEP_g=9V=5zHqwz710TSuRSqTdo1kqkKF2VEEV6K3Tv1zupegg@mail.gmail.com>
	 <4E790C5E.5000000@kasperkp.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 00:08:53 +0200
Message-ID: <1316556533.5832.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 20 septembre 2011 à 23:57 +0200, Kasper Pedersen a écrit :
> On 09/20/2011 11:27 PM, Jesse Gross wrote:
> 
> > On Tue, Sep 20, 2011 at 2:09 PM, Matt Carlson <mcarlson@broadcom.com> wrote:
> >> On Tue, Sep 20, 2011 at 01:48:56PM -0700, Kasper Pedersen wrote:
> >>> commit 92cd3a17ce9c719abb4c28dee3438e0c641f8de4
> >>>     tg3: Simplify tx bd assignments
> >>>
> >>> broke VLAN tagging on outbound packets.
> >>> It ifdef'ed BCM_KERNEL_SUPPORTS_8021Q, but this
> >>> is not set anywhere. So vlan never gets set, and
> >>> all packets are sent with vlan=0.
> >>>
> >>> Change to use the CONFIG_VLAN_xxx defines instead.
> >>> Tested on BCM5721 rev 11.
> >>>
> >>> Signed-off-by: Kasper Pedersen <kernel@kasperkp.dk>
> >>
> >> Yes.  This is correct.
> >>
> >> Acked-by: Matt Carlson <mcarlson@broadcom.com>
> > 
> > Actually, please don't do this.  Those config #define's refer to the
> > 802.1q module that creates vlan devices only.  The rest of the network
> > stack has code for dealing with vlan packets that is not protected by
> > config guards, so there's no reason that drivers should be.  The
> > correct thing to do here is just drop the test altogether and
> > unconditionally include the code.
> > 
> 
> 
> currently testing, and will post a just-remove-ifdef in a few hours,
> assuming it behaves as expected on a no-802.1q-module config.
> 
> 
> tg3 has one more place where this is done, and it looks as if the code
> in that location doesn't quite mesh with the comment.

Thanks for finding this bug, this hit me last day on a BCM5755M but I
had no time to investigate.


