Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab2CCQoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 11:44:17 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40328 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab2CCQoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 11:44:15 -0500
Date: Sat, 3 Mar 2012 16:44:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: linux-pm@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-acpi@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 2/4] hwmon: exynos4: Move thermal sensor
 driver to driver/mfd directory
Message-ID: <20120303164410.GB1495@sirena.org.uk>
References: <1330772767-16120-1-git-send-email-amit.kachhap@linaro.org>
 <1330772767-16120-3-git-send-email-amit.kachhap@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330772767-16120-3-git-send-email-amit.kachhap@linaro.org>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2012 at 04:36:05PM +0530, Amit Daniel Kachhap wrote:
> This movement is needed because the hwmon entries and corresponding
> sysfs interface is a duplicate of utilities already provided by
> driver/thermal/thermal_sys.c. The goal is to place it in mfd folder
> and add necessary calls to get the temperature information.

> --- a/Documentation/hwmon/exynos4_tmu
> +++ /dev/null

Moving this seems to be a failure, the device is exposing a hwmon
interface even if you've moved the code to mfd (though it doesn't
actually look like a multi-function device at all as far as I can see -
usually a MFD would have a bunch of unrelated functionality while this
has one function used by two subsystems).

If anything it looks like the ADC driver ought to be moved into IIO with
either generic or Exynos specific function drivers layered on top of it
in hwmon and thermal making use of the values that are read.
