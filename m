Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab2CBO7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:59:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60935 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab2CBO7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:59:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Subject: Re: [PATCH 01/03] MFD: add ADC support to DA9052/53 MFD  core v2
Date: Fri, 2 Mar 2012 14:59:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>,
        sameo@linux.intel.com
References: <1330698533.21817.30.camel@dhruva>
In-Reply-To: <1330698533.21817.30.camel@dhruva>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203021459.36840.arnd@arndb.de>
X-Provags-ID: V02:K0:M3IbcCFn/PQJ5KGEeylLY4DBV45X1ua+U81wsiVWFyB
 UgG2MVi8NqqozYAVyHLWCve21yz0Ai2V4ZOkve9tWCimNj/0p0
 ihbb2ukDOGOPHq7Rk19967tjONp1AiMXN0o9T4eSl0WUIHnNH8
 5LV/74mZhAWqFDpnlFwuzBsZSaTBU/qrX3UjArVDT0bMpl+0PL
 veh67+Bg0v80cozul+zoJ/Az/jXcwsIm7BSQVKmMi4l+utjS5n
 cwObDBzVbX2QgO35QrniZmNAZHymqI/c6O4WvfbJnnlSdHzB6m
 U2OuT0TGsaDP27XCK7IfqHP3qW4dZEaPgQTzdV4F3qKOhqnEtA
 sJFA/wJB+pNWXvT8wl4M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 March 2012, Ashish Jangam wrote:
> +
> +       mutex_lock(&da9052->auxadc_lock);
> +
> +       /* Channel gets activated on enabling the Conversion bit */
> +       mux_sel = chan_mux[channel] | DA9052_ADC_MAN_MAN_CONV;
> +
> +       ret = da9052_reg_write(da9052, DA9052_ADC_MAN_REG, mux_sel);
> +       if (ret < 0)
> +               goto err;
> +
> +       /* Wait for an interrupt */
> +       wait_for_completion_timeout(&da9052->done, msecs_to_jiffies(500));

Shouldn't this check the return value of wait_for_completion_timeout
and return an error if it timed out?

If you don't expect a timeout to ever happen, it's probably better to
use wait_for_completion instead of wait_for_completion_timeout, but
if it can time out, you should handle it.

	Arnd
