Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab1AGOju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 09:39:50 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:36611 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753610Ab1AGOjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 09:39:48 -0500
From: Anand Gadiyar <gadiyar@ti.com>
References: <20101223171859.f6842045.sfr@canb.auug.org.au><4D139517.3010608@ti.com><AANLkTi=pTNg2iWN+=uEv=CyZHHCoddF51pmmCMjPeMUF@mail.gmail.com><4ce0f816f951f24ca3de9c84d9f70842@mail.gmail.com><AANLkTimA5UOVn6+xe0ofV1F3_XhAP0daBvOAX2k1u_dU@mail.gmail.com><AANLkTimzQ1PHN986fqPF0yjd1M+390nSUDYJ65pu0z_f@mail.gmail.com><4D271E0E.8050401@ti.com>
 <AANLkTikLQRHyp-TS_idEp5Fr74qC3vDoMqqsAA2v_oV8@mail.gmail.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <AANLkTikLQRHyp-TS_idEp5Fr74qC3vDoMqqsAA2v_oV8@mail.gmail.com>
Thread-Index: AcuudWR1Xlw+U8igQiWrhgS2G9lpfwAAkg5w
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Date: Fri, 7 Jan 2011 20:09:45 +0530
Message-ID: <c822ad4569a9dc865b5ccf39e12c828b@mail.gmail.com>
Subject: RE: linux-next: manual merge of the usb tree with the omap tree
To: Ming Lei <tom.leiming@gmail.com>
Cc: Benoit Cousson <b-cousson@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Walmsley <paul@pwsan.com>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei wrote:
> 2011/1/7 Anand Gadiyar <gadiyar@ti.com>:
> > Hi Ming Lei,
> >
> > I'm able to reproduce this on my panda, and I have it working as of
> > linux-next-20101221 (the last version I tested last year) and failing
> > on linux-next-20101227 (which was the very next linux-next release).
> >
> > Not sure why, but my Panda manages to get the VID:PID of the hub as
> > well, while yours does not even get there.
> >
> > I may need a few more hours to debug this, unless someone beats me
> > to it. ;)
>
> Is it caused by the below?
>
> [   46.580200] ehci-omap ehci-omap.0: failed to get ehci port0 regulator
>

Nope. We don't set up any regulators for the PHY on Panda (at least not
yet).

And the working case (next-20101221) has the same log.

I suspect the PHY doesn't get reset for the proper duration; I'm looking
for something in that area. (Another option is to bisect between the two
versions, but I'm not sure if that's any easier).

- Anand
