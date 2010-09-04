Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab0IDVYl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 17:24:41 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:50783 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab0IDVYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 17:24:38 -0400
MIME-Version: 1.0
Date: Sat, 04 Sep 2010 16:24:39 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <felipe.balbi@nokia.com>, Anand Gadiyar <gadiyar@ti.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] USB: otg: twl4030: fix phy initialization
In-Reply-To: <AANLkTikiFbw6xz5jbvgPR5-X5mZxDkOjLdFuc=vG10qK@mail.gmail.com>
References: <1283443098-15262-1-git-send-email-tom.leiming@gmail.com> <ee6a42fe148f72518d475ff3838fc32a@secure211.sgcpanel.com> <AANLkTimts7SjE9EKrmsSkynWsQc_VtJUVVigrFs2VtrK@mail.gmail.com> <AANLkTikiFbw6xz5jbvgPR5-X5mZxDkOjLdFuc=vG10qK@mail.gmail.com>
Message-ID: <1fb6fc37cd0f017043d5c124bca4bb1a@secure211.sgcpanel.com>
User-Agent: RoundCube Webmail/0.3.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 4 Sep 2010 23:36:39 +0800, Ming Lei <tom.leiming@gmail.com> wrote:
> Considered bit PHYPWD of PHY_PWR_CTRL is zero at default,
> say, OTG phy is not put into power down after system poweron,
> so 2.6.36-rc3 will make musb device mode broken if bootloader
> doesn't touch  PHYPWD of PHY_PWR_CTRL.
> 
> Could you ack the patch if no further objections or give other
> suggestions?

I don't see why that patch should cause problems with device
mode. Fact is that transceiver is only "asleep" when PHYPWD
bit is true and without setting that flag correctly we were
leaving phy's LDOs powered on for nothing when we were
booting without a USB cable connected.

If you don't explain exactly what is the problem you see
(besides the WARN) it's to help any further, specially now
that I'm 100% without HW to test against. I'm also in a
big hurry packing a buch of stuff for moving to another
appartment, so if there isn't enough information, I can't
be of any help.

Still, I would NACK you patch because I don't think it's
approaching the correct problem. If you only see that WARN,
you could start by chaging the code so that:

if (!regulator_is_enabled(twl->usb3v1)
    regulator_enable(twl->usb3v1);

and similarly for the regulator_disable() call, then check
whether there are any other problems. If there are, we will
take it from there.

All in all, I doubt that patch would cause break anything
since it's just checking the initial state from the
transceiver itself to set a flag in the driver structure,
that's all.

-- 
balbi
