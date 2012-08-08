Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137Ab2HHTSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:18:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59583 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758860Ab2HHTSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:18:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 8/8] ARM: vt8500: gpio: Devicetree support for arch-vt8500
Date: Wed, 8 Aug 2012 19:17:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Tony Prisk <linux@prisktech.co.nz>,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Russell King <linux@arm.linux.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Alan Cox <alan@linux.intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Hauke Mehrtens <hauke@hauke-m.de>, Felipe Balbi <balbi@ti.com>,
        Neil Zhang <zhangwm@marvell.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Rob Landley <rob@landley.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>,
        Eric Andersson <eric.andersson@unixphere.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
        rtc-linux@googlegroups.com, devicetree-discuss@lists.ozlabs.org
References: <1344389967-8465-1-git-send-email-linux@prisktech.co.nz> <1344389967-8465-9-git-send-email-linux@prisktech.co.nz> <5022B242.1050001@wwwdotorg.org>
In-Reply-To: <5022B242.1050001@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208081917.19111.arnd@arndb.de>
X-Provags-ID: V02:K0:es0C/1cOnza2PLHbJC7akKIgWnNvjnyZhJbqyQAxuFN
 Bl+pH9Cl4gdOQ8thIl98eHPJLZBjbSBunBMyTmv8TzcxllOLGo
 Vrk1Igl5lm2TAOYh+wLQStDIZy98+oyIU9XfSx++3dv4iZcHb7
 tvvaOVfvQ5IqK943KT3oBm389SUr0sFqsCTlLlBeFEpGz//sic
 jGnB0c6NcnWnOUq3HmxyCJ+/zyi7d29UGYNaxOe2rYmScH1DbO
 orhLlWzkY4Mk/S+db0wzjJWwioKONfK8gLYw5koCm4wOOHrPeF
 zQRJxIkCzfEJVLNXVVPu2Ec4bgeewc+zbBbD2vd9qtSjgtKOu9
 0vl3KI/WAfj++6yZgbg4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2012, Stephen Warren wrote:
> I think that's all just:
> 
> module_platform_driver(vt8500_gpio_driver);
> 
> (except that _init uses platform_driver_probe() rather than
> platform_driver_register(), which seems unusual. I guess that explains
> the of_find_matching_node() above too.)

Ah, I totally missed both of these. Using platform_driver_register
is definitely preferred over platform_driver_probe in cases like
this, so using module_platform_driver is the right simplification.

	Arnd
