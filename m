Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab1LMVTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 16:19:55 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58217 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab1LMVTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 16:19:52 -0500
MIME-Version: 1.0
In-Reply-To: <4EE5A8A0.2010206@bitmer.com>
References: <1323105820-25946-1-git-send-email-felipe.contreras@nokia.com>
	<1323105820-25946-3-git-send-email-felipe.contreras@nokia.com>
	<CAMP44s3Szzm9iXxghXfNCBjKyUw-nRrG1aEeweKnRCidaxmxEA@mail.gmail.com>
	<4EDF5231.6080309@bitmer.com>
	<CAMP44s0a6hcORZn8wDxHUJKxs=wjAmkhRfiT9kEA_MoDYeAmfg@mail.gmail.com>
	<4EE5A8A0.2010206@bitmer.com>
Date: Tue, 13 Dec 2011 23:19:52 +0200
Message-ID: <CAMP44s1Zz7CqxRM6PeNT3GN9GbCLy+0smgk6_-9kSjghY33Xuw@mail.gmail.com>
Subject: Re: [PATCH 2/2] Revert "ARM: RX-51: Enable isp1704 power on/off"
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>,
        Heikki Krogerus <heikki.krogerus@nokia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 9:09 AM, Jarkko Nikula <jarkko.nikula@bitmer.com> wrote:
> Indeed yes. I checked that in 3.0 it still works but not in 3.1 so some
> non isp1704_charger change has broke it as there hasn't been changes on it.

Actually it's broken in 3.0 as well, try this configuration:

	# CONFIG_USB_MUSB_HOST is not set
	# CONFIG_USB_MUSB_PERIPHERAL is not set
	CONFIG_USB_MUSB_OTG=y
	CONFIG_USB_GADGET_MUSB_HDRC=y
	CONFIG_USB_MUSB_HDRC_HCD=y

	CONFIG_USB_GADGET_SELECTED=y
	# CONFIG_USB_GADGET_FUSB300 is not set
	# CONFIG_USB_GADGET_OMAP is not set
	# CONFIG_USB_GADGET_R8A66597 is not set
	# CONFIG_USB_GADGET_PXA_U2O is not set
	# CONFIG_USB_GADGET_M66592 is not set
	# CONFIG_USB_GADGET_DUMMY_HCD is not set

I will try to find where the issues started to happen, but it's a bit
difficult because all this USB Kconfig stuff is completely messed up.

*Sigh*

-- 
Felipe Contreras
