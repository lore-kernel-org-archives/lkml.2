Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2KYP2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 10:28:55 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:15420 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751610Ab2KYP2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 10:28:53 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+1pfA4ZJHw75yhwtPVcP0kvSQCgRFzp30=
Date: Sun, 25 Nov 2012 10:28:45 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Axel Lin <axel.lin@ingics.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] ARM: Dove: Convert to DT GPIO and pinctrl
Message-ID: <20121125152845.GV15800@titan.lakedaemon.net>
References: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1353317996-20841-4-git-send-email-sebastian.hesselbarth@gmail.com>
 <20121124023942.GO15800@titan.lakedaemon.net>
 <20121124080240.3f600e89@skate>
 <20121124150004.GQ15800@titan.lakedaemon.net>
 <20121124191024.4b5d5b4c@skate>
 <20121124185906.GT15800@titan.lakedaemon.net>
 <50B1F842.2080500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B1F842.2080500@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2012 at 11:51:46AM +0100, Sebastian Hesselbarth wrote:
> On 11/24/2012 07:59 PM, Jason Cooper wrote:
> >On Sat, Nov 24, 2012 at 07:10:24PM +0100, Thomas Petazzoni wrote:
> >>On Sat, 24 Nov 2012 10:00:04 -0500, Jason Cooper wrote:
> >>>Yes, so that's what I thought happened.  This would have made orion/dt
> >>>depend upon mvebu/everything.  It already had two other dependencies.
> >>>Not ideal.
> >>>
> >>>The good thing is, the build is not broken.  Once v3.8-rc1 drops with
> >>>all of our stuff merged, I'll post a fixup patch adding this back in.
> >>
> >>It unfortunately means that Dove will be basically unbootable in
> >>3.8-rc1, as the driver will not be clk_get()ing its gatable clock, and
> >>the clock driver will disable it. Maybe we can just live with it, I
> >>don't know.
> >
> >Yes, I thought as much after I sent this reply.  Definitely a choice of
> >the lesser of two evils.  As long as we don't break the build or have
> >horrendous merge conflicts, I think it's tolerable.
> >
> >Any one who is booting -rc1's is typically bug hunting.  This means
> >Sebastian, who has been CC'd on all of this.  I don't want to rely on
> >this in the future, but doing it once due to the circumstances is
> >something I'm comfortable answering to.
> 
> sorry for the late answer. I merged all pull reqs in the order posted
> on top of latest linux/master. Thomas is right, removing the clk_gate
> from pinctrl potentially could have broken boot on dove. I tried it and
> it _does_ boot, because the clk used by pinctrl is optional in pinctrl-dove
> and there is no pinhog/device touching the register clocked by the clock.
> 
> As soon as I 'cat pinconf-groups' in debugfs, the register is read and
> my cubox hangs as expected.
> 
> So, finally a fixup patch for 3.8-rc1 is ok for me.

Great!  I'm glad to hear it's not as bad as I feared.

thx,

Jason.
