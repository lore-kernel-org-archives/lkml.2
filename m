Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab2HHJRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 05:17:14 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:48389 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab2HHJRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 05:17:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [Regression, post-3.5] System suspend broken on the Mackerel board
Date: Wed, 8 Aug 2012 11:23:04 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: kuninori.morimoto.gx@renesas.com, Magnus Damm <magnus.damm@gmail.com>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
References: <20120801073004.GE15380@linux-sh.org> <201208050002.43465.rjw@sisk.pl> <20120807015551.GB1614@linux-sh.org>
In-Reply-To: <20120807015551.GB1614@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208081123.04850.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 07, 2012, Paul Mundt wrote:
> On Sun, Aug 05, 2012 at 12:02:43AM +0200, Rafael J. Wysocki wrote:
> > On Wednesday, August 01, 2012, Paul Mundt wrote:
> > > Turns out we can just collapse the probe/init stuff anyways, so this
> > > ought to fix it. I've verified that it fixes Morimoto-san's issue, my
> > > expectation is that the mackerel case is likewise getting tripped up but
> > > no one bothered implementing any error detecting logic for gpio_request()
> > > failing, so it doesn't fail gracefully.
> > > 
> > > I'll be pushing this out to Linus shortly:
> > 
> > Thanks, this helped.  Resume works correctly on Mackerel with 3.6-rc1.
> > 
> > However, I'm now seeing a different problem related to system suspend on that,
> > board which is that sh7372_enter_a3sm_common() returns immediately, as though
> > at least one of the wakeup signals was permanently asserted.  This hadn't
> > happened before your last pull request was merged, so I suspect that one
> > of the irqdomain patches might introduce this behavior.
> > 
> Ok, I'll back off the irqdomain selection until we have a chance to test
> it more on the other platforms.

If you mean removing the select from drivers/sh/intc/Kconfig, that alone doesn't
help.  Reverting commit 1d6a21b0a672fb29b01ccf397d478e0541e17716
(sh: intc: initial irqdomain support.) helps, though.

Thanks,
Rafael
