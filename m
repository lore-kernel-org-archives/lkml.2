Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab0JTT7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 15:59:07 -0400
Received: from mail.perches.com ([173.55.12.10]:3421 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620Ab0JTT7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 15:59:05 -0400
Subject: Re: [PATCH] drivers/hwmon: Use pr_fmt and pr_<level>
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: dave@gnu.org, Guenter Roeck <guenter.roeck@ericsson.com>,
        Hans de Goede <j.w.r.degoede@hhs.nl>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        Henrik Rydberg <rydberg@euromail.se>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Luca Tettamanti <kronos.it@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Juerg Haefliger <juergh@gmail.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Jim Cromie <jim.cromie@gmail.com>,
        Roger Lucas <vt8231@hiddenengine.co.uk>, lm-sensors@lm-sensors.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1287604323.15567.22.camel@Joe-Laptop>
References: <1287530020.10409.594.camel@Joe-Laptop>
	 <20101020094208.3136b9dd@endymion.delvare> <1287602386.2210.6.camel@cowboy>
	 <20101020213810.6b31c04e@endymion.delvare>
	 <1287604323.15567.22.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 12:59:02 -0700
Message-ID: <1287604743.15567.27.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 12:52 -0700, Joe Perches wrote:
> So perhaps add this to include/linux/hwmon.h instead:
> #if defined pr_fmt
> #undef pr_fmt
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> #endif

Nope.  That won't work as other non-hwmon files include it.

drivers/platform/x86/eeepc-laptop.c:#include <linux/hwmon.h>
drivers/platform/x86/compal-laptop.c:#include <linux/hwmon.h>
drivers/platform/x86/thinkpad_acpi.c:#include <linux/hwmon.h>
drivers/thermal/thermal_sys.c:#include <linux/hwmon.h>
drivers/staging/iio/light/tsl2563.c:#include <linux/hwmon.h>
drivers/gpu/drm/radeon/radeon_pm.c:#include <linux/hwmon.h>
drivers/gpu/drm/nouveau/nouveau_pm.c:#include <linux/hwmon.h>
drivers/acpi/power_meter.c:#include <linux/hwmon.h>
drivers/input/touchscreen/ads7846.c:#include <linux/hwmon.h>


