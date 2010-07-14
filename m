Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab0GNKYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 06:24:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56723 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab0GNKYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 06:24:53 -0400
Date: Wed, 14 Jul 2010 11:24:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dajun Chen <dajun.chen@gmail.com>
Cc: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 4/11] Power:Battery module of DA9052 PMIC device
	driver (RESEND)
Message-ID: <20100714102448.GE5933@sirena.org.uk>
References: <AANLkTilbY_V_0E2NtXwrhV8Rd4Efpy8p8FvrAigH6A00@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilbY_V_0E2NtXwrhV8Rd4Efpy8p8FvrAigH6A00@mail.gmail.com>
X-Cookie: You will wish you hadn't.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 10:44:10AM +0100, Dajun Chen wrote:

> +#ifndef _BAT_H
> +#define _BAT_H

This is likely to run into namespace conflicts with other stuff -
including the chip name should fix that.

> +
> +#define DA9052_CHG_MEASUREMENT_FAIL			-154

As has been pointed out with all your other patches please you standard
Linux error codes rather than making up your own.  This applies to
pretty much all kernel code.

> +/* STATIC CONFIGURATION */
> +#define SW_TEMP_CONTROL_EN			0
> +#define MONITORING_INTERVAL			500
> +#define SW_BAT_TEMP_THRESHOLD			60
> +#define SW_JUNC_TEMP_THRESHOLD			120

This all needs to be platform data rather than #defines in the header -
the kernel contains code for a very wide range of boards so editing the
header file per-board isn't going to work and the valeus you pick may be
actively harmful if they fail to correspond to the actual battery
properties.
