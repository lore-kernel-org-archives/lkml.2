Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0JPUDy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 16:03:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52692 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab0JPUDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 16:03:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH] ath9k: Convert to new PCI PM framework
Date: Sat, 16 Oct 2010 22:02:52 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc8-rjw+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
References: <201010160036.17653.rjw@sisk.pl> <AANLkTimdatos1psRnp_Es=q8iOe9aQE_aVARLpm18efb@mail.gmail.com>
In-Reply-To: <AANLkTimdatos1psRnp_Es=q8iOe9aQE_aVARLpm18efb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010162202.52766.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 16, 2010, Luis R. Rodriguez wrote:
> On Fri, Oct 15, 2010 at 3:36 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > The ath9k driver uses the legacy PCI power management (suspend
> > and resume) callbacks that apparently cause intermittent problems
> > to happen (the adapter sometimes doesn't resume correctly on my
> > Acer Ferrari One).  Make it use the new PCI PM and let the PCI core
> > code handle the PCI-specific details of power transitions.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Do you know when these hooks were added?

Well, which ones?  If you're asking about the new framework, it's been there
since 2.6.29 and is a recommended way of implementing PM hooks now.

Please have a look at Documentation/power/pci.txt. :-)

> If it fixes an issue should this go for stable?

I'm not 100% sure it fixes everything yet, although I hasn't been able to
reproduce the problem with it applied, so far.

So, I don't think it's -stable material at this point.  However, it should be
done anyway at one point, so it very well can be done right now, given that I
have the hardware to test it. :-)

Thanks,
Rafael
