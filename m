Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab2CFVez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:34:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61463 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318Ab2CFVeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:34:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v5] lpc32xx: Added ethernet driver
Date: Tue, 6 Mar 2012 21:34:37 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: davem@davemloft.net, jeffrey.t.kirsher@intel.com,
        alexander.h.duyck@intel.com, eilong@broadcom.com,
        ian.campbell@citrix.com, netdev@vger.kernel.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, baruch@tkos.co.il,
        joe@perches.com
References: <1331067664-9124-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1331067664-9124-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203062134.38077.arnd@arndb.de>
X-Provags-ID: V02:K0:csaWdj6z2lEYia2/iGUGClWu4Akr8/1bFb0V1LO+8wW
 jD3gGz9Zp14Isgglx+VmwYxfwg8ciixISiYUoyVvAPmMHiktes
 sPQMaFJA9Zx/E2mEJlQhTfX/GT65ZpxUCYmheI/fXsDn216y1B
 TxnsA9lELezJcHvb9jKp5AaOB2LmPJ7SOaXOxEinHwilR0Gne0
 9J1n6f7UBSLRktBHs7W3wNQXIiPNnikrfgH/ofNlQXFZnGFI4g
 g8592cyTtRi1E4DQjT7jbiXK9MUV+B1/srK1RgqFaulES9lQUc
 RWqbJZn1zIT3BQtW3SPUoC0JoPlEP35IapN2FVqBK3X1we6Qop
 oKjf5BJmMKbU5sL/Tf6Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

One more thing I noticed this time:

On Tuesday 06 March 2012, Roland Stigge wrote:
> +static inline phy_interface_t lpc_phy_interface_mode(void)
> +{
> +#ifdef CONFIG_ARCH_LPC32XX_MII_SUPPORT
> +       return PHY_INTERFACE_MODE_MII;
> +#else
> +       return PHY_INTERFACE_MODE_RMII;
> +#endif
> +}
> +
> +static inline int use_iram_for_net(void)
> +{
> +#ifdef CONFIG_ARCH_LPC32XX_IRAM_FOR_NET
> +       return 1;
> +#else
> +       return 0;
> +#endif
> +}

This should eventually both become run-time options based on the device tree.
I don't know if you planned to do that anyway, but if you want the same kernel
binary to be used for systems in different configurations, you cannot have
compile-time decisions that are exclusive-or. Since you don't support device
tree yet but plan to do that in the future, you could add a comment here
about it, or you could even prepare it for that case already by passing the
device into the functions that will be required for reading the properties.

	Arnd
