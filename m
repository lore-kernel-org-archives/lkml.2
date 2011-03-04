Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044Ab1CDSvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:51:04 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61630 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759607Ab1CDSvB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:51:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=IBYxFQ/7QFhCeZUK1GDEhHW4DZre02szwwgiI5MeTVlOi8xG/j/U8WVq7EcsDIfgYT
         bCAGqQ5F1SzvDG5ktZRpulZK4NWrSNDhQzzOLjd84pHm6f93sNu6G2N2qVbCljUCh/cG
         JuwEg6Mea1A94yUOdlx/dXNXcXT+wBiihpsbo=
MIME-Version: 1.0
In-Reply-To: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
References: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 4 Mar 2011 13:50:41 -0500
X-Google-Sender-Auth: E0sZW8OR1zA-U9qsyaq1zioNyiM
Message-ID: <AANLkTinNrOG69Kzy=ZfRjurOedsz2Oazt-FT-m3Ro6Gg@mail.gmail.com>
Subject: Re: [PATCH v5 00/11] hwmon: (w83627ehf) Add support for NCT6775F and NCT6776F
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ian Dobson <i.dobson@planet-ian.com>,
        Randy Dunlap <rdunlap@xenotime.net>, binximeng@gmail.com,
        lmsensors@tapanitarvainen.fi, andrea.rizzolo@gmail.com,
        jeff.sadowski@gmail.com, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 12:57 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
> The following patch series adds support for NCT6775F and NCT6776F to the
> w83627ehf driver. It also includes some cleanup and adds support for
> the fourth temperature sensor on W83677HG-B.
>
> No code changes since v4. Resubmitting and widening audience in the hope that
> someone may find the time to review the changes prior to the next commit window.

I'm not sure my review is worth much, but the driver seems to work.  I've tested
fan speed measurement, changing pwm2_enable to 1, changing the fan speed,
and changing back to 5.  Everything looks good.

The only weird thing I noticed is that, the first time I ran sensors, I got:
fan2:                    0 RPM  (min =    0 RPM, div = 64)
and thereafter I get
fan2:                  136 RPM  (min =    0 RPM, div = 64)  ALARM

I suspect (although I haven't checked) that sensors is just reading
div after it's already changed to 64.

Thanks,
Andy

>
> v5:
> - Update Kconfig to reference W83667HG, NCT6775F, and NCT6776F.
>
> v4:
> - Store rpm instead of raw fan speed readings
> - For NCT6775F, increase fan divisor if the fan speed reads 0
>  [ On NCT6775F, fan speed readings can return 0 instead of 0xff if the
>    fan divisor value is too low ]
> - Separate changes into more patches to simplify review
>
> v3:
> - Documentation: Remove references to datasheets which no longer exist
> - Documentation: Add information about limits of SmartFan IV support.
> - SmartFan III mode is not supported on NCT6776F, so remove related attributes
>  and refuse to configure it.
> - (additional patch) Improve support for chips with 16-bit fan count registers
>
> v2:
> - W83677HG-B does share the AUXTIN/VIN3 pin, so we can not skip this check.
> - Cosmetic changes to fix a couple of checkpatch errors and to undo some
>  unnecessary formatting changes in patch 5.
> - Patch 1 introduced a bug in temp_to_reg which was fixed in a later patch.
>  Modified code to not introduce the bug in the first place.
> - Two dev_dbg messages were changed to dev_info for testing. Changed back
>  to dev_dbg.
>
> The patched driver can be downloaded as stand-alone driver from
>        http://www.roeck-us.net/linux/drivers/w83627ehf/
>
