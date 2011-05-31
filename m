Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab1EaL2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 07:28:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55034 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab1EaL2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 07:28:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH 2/4] ARM: mxc: migrate mach-mx5 gpio driver to gpio-mxc
Date: Tue, 31 May 2011 13:28:17 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
References: <1306767139-24763-1-git-send-email-shawn.guo@linaro.org> <201105311026.11947.arnd@arndb.de> <20110531103011.GB32096@S2100-06.ap.freescale.net>
In-Reply-To: <20110531103011.GB32096@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105311328.18012.arnd@arndb.de>
X-Provags-ID: V02:K0:aoXhuJ5WxzNPFXtKo5FzyNQOMUFfck6ctMYNRbAGR+K
 K/RN0ICbtscEPOENfB/F8VkPbV8+daT77SIEXfce6RPxX+mIWo
 um3GuXAMiltTzsIpmuV1SgRWGiG545LHsr41tNQ2g3O0QBAxfc
 fEdBp4vG+TDtyUdBLfcRNkVQ3lxK0I1uYQ2ezUyszkHGA/0DR1
 t16oI3UL8Ko94A0B/M0jg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 May 2011, Shawn Guo wrote:
> > Just open-code the mxc_add_mxc_gpio() by moving the individual calls to
> > mxc_add_gpio() into the respective callers. Having a global
> > mxc_add_mxc_gpio() function that does something different for each
> > caller seems entirely pointless to me.
> > 
> Right now, mxc_add_mxc_gpio() is a postcore_initcall.  Moving
> individual mxc_add_gpio() call into irq_init function does not work.
> And I need to find a proper caller for each SoC to call mxc_add_gpio
> to register gpio devices.
 
Why not init_machine? That is an arch_initcall(), so it's probably close
enough.

	Arnd
