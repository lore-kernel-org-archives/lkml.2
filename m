Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab0JTUgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 16:36:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60207 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab0JTUgs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 16:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=XFZVfDss722GblkZife5p5cXU0FCItk76H3VFrvjgQlXF4bx8AZHO+wWyFPkz8c3U0
         E0wJF3hK+rWDQIqRy4cxQX1ZMPV9XTbncu1AiTD8XoDrjdcl5rcB5BfJp75XGgchsnKn
         1WrkSYMvWuJeWHP0kBytjUFYrkkibu+YmEx10=
MIME-Version: 1.0
In-Reply-To: <1287604743.15567.27.camel@Joe-Laptop>
References: <1287530020.10409.594.camel@Joe-Laptop> <20101020094208.3136b9dd@endymion.delvare>
 <1287602386.2210.6.camel@cowboy> <20101020213810.6b31c04e@endymion.delvare>
 <1287604323.15567.22.camel@Joe-Laptop> <1287604743.15567.27.camel@Joe-Laptop>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Wed, 20 Oct 2010 14:36:17 -0600
Message-ID: <AANLkTinuBoVyKSm5nAwNx6H8DF6wDNNi4z4-b8wyXbaW@mail.gmail.com>
Subject: Re: [PATCH] drivers/hwmon: Use pr_fmt and pr_<level>
To: Joe Perches <joe@perches.com>
Cc: Jean Delvare <khali@linux-fr.org>, dave@gnu.org,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Hans de Goede <j.w.r.degoede@hhs.nl>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        Henrik Rydberg <rydberg@euromail.se>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Luca Tettamanti <kronos.it@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Juerg Haefliger <juergh@gmail.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Roger Lucas <vt8231@hiddenengine.co.uk>, lm-sensors@lm-sensors.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 1:59 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2010-10-20 at 12:52 -0700, Joe Perches wrote:
>> So perhaps add this to include/linux/hwmon.h instead:
>> #if defined pr_fmt
>> #undef pr_fmt
>> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> #endif
>
> Nope.  That won't work as other non-hwmon files include it.
>
> drivers/platform/x86/eeepc-laptop.c:#include <linux/hwmon.h>
> drivers/platform/x86/compal-laptop.c:#include <linux/hwmon.h>
> drivers/platform/x86/thinkpad_acpi.c:#include <linux/hwmon.h>
> drivers/thermal/thermal_sys.c:#include <linux/hwmon.h>
> drivers/staging/iio/light/tsl2563.c:#include <linux/hwmon.h>
> drivers/gpu/drm/radeon/radeon_pm.c:#include <linux/hwmon.h>
> drivers/gpu/drm/nouveau/nouveau_pm.c:#include <linux/hwmon.h>
> drivers/acpi/power_meter.c:#include <linux/hwmon.h>
> drivers/input/touchscreen/ads7846.c:#include <linux/hwmon.h>
>
>
>


what about modules.h ? or device.h ?

Id think that would cover many users without being universally inadequate,
and Id guess one of those (or a neighbor) would cover most of the use-cases.

youve got a list of 200 pr-fmt users,
why not break them down by which format theyre using,
and see if those formats line up with subsystems.
Id think 6 or 7 definitions in the appropriate headers
would give useful log-content, and avoid countless changes.

KBUILD_MODNAME is always #defined by the make system.
so if your defn built upon that, it would address all code that builds
as modules, how many other use-cases are there ?
