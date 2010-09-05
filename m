Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab0IEJvZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 05:51:25 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:57976 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab0IEJvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 05:51:23 -0400
MIME-Version: 1.0
Date: Sun, 05 Sep 2010 04:51:19 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <felipe.balbi@nokia.com>, Anand Gadiyar <gadiyar@ti.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] USB: otg: twl4030: fix phy initialization
In-Reply-To: <AANLkTi=4J5u4SEh5jSPxObceWdAom51R+H_j8oApG5PG@mail.gmail.com>
References: <1283443098-15262-1-git-send-email-tom.leiming@gmail.com> <ee6a42fe148f72518d475ff3838fc32a@secure211.sgcpanel.com> <AANLkTimts7SjE9EKrmsSkynWsQc_VtJUVVigrFs2VtrK@mail.gmail.com> <AANLkTikiFbw6xz5jbvgPR5-X5mZxDkOjLdFuc=vG10qK@mail.gmail.com> <1fb6fc37cd0f017043d5c124bca4bb1a@secure211.sgcpanel.com> <AANLkTi=4J5u4SEh5jSPxObceWdAom51R+H_j8oApG5PG@mail.gmail.com>
Message-ID: <7c720d238d9d5ba6f483cdd7303315e4@secure211.sgcpanel.com>
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

On Sun, 5 Sep 2010 14:42:51 +0800, Ming Lei <tom.leiming@gmail.com> wrote:
> issue #1:(musb device not work with cable connected with PC)
>         -twl->asleep is set as zero in .probe since bootloader has not
> powerdown phy
>         -EVENT_VBUS returned from twl4030_usb_linkstat since usb cable
> is connected with PC
>         -twl4030_phy_resume is called but does nothing since
> twl->asleep is zero
>         -the following are not called to initialize otg phy:
>                  twl4030_phy_power / twl4030_i2c_access /
>                  twl4030_usb_set_mode
>         -so musb device mode does not work

ok, I see. So what you could do is enable regulators on probe
based on PHYPWR bit.

> Sorry for disturbing you, hope you have a happy moving, :-)

np, tks :-)

> No, .asleep flag is set according to the current link state,
> instead of the initial state of transceiver. I don't think the patch
> will cause break anything. If you think it will, please describe the
> break in detail.

if we revert that patch, you'll see that usb3v1 ldos are left on
if we never plug/unplug usb cable. AFAIR, the reset state of those
LDOs is ON, so that's why we need that patch.

I'll try to work on it monday judging I'll have laptop and HW
available by then.

-- 
balbi
