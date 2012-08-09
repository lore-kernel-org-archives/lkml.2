Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754Ab2HIKTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 06:19:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39129 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757541Ab2HIKTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 06:19:50 -0400
Date: Thu, 9 Aug 2012 11:19:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] efikamx: reintroduce Genesi Efika MX Smarttop via
 device tree
Message-ID: <20120809101947.GA8474@sirena.org.uk>
References: <1344375978-29981-1-git-send-email-matt@genesi-usa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344375978-29981-1-git-send-email-matt@genesi-usa.com>
X-Cookie: This report is filled with omissions.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 04:46:18PM -0500, Matt Sealey wrote:

Yay for indentation!  It'd be good to rewrite your DT so you could cut
down on that, at the minute it's not good for legibility.

> +							sw1_reg: sw1 {
> +								regulator-min-microvolt = <600000>;
> +								regulator-max-microvolt = <1375000>;
> +								regulator-boot-on;
> +								regulator-always-on;
> +							};

This and many of your other regulators have voltage ranges specified but
no consumers which doesn't make sense.  It looks awfully like you've
just typed in the maximum range supported by the regulator which is most
likely broken.

You're also specifying both boot_on and always_on which again doesn't
seem to make a lot of sense - boot_on mainly exists to help autoprobe,
using it quite this routinely isn't too clever.
