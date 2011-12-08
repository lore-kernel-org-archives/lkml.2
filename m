Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1LHKle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 05:41:34 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39560 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1LHKlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 05:41:32 -0500
Date: Thu, 8 Dec 2011 14:41:27 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Hughes <hughsient@gmail.com>,
        Daniel Nicoletti <dantti12@gmail.com>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, vojtech@ucw.cz,
        Przemo Firszt <przemo@firszt.eu>, Richard Hughes <richard@hughsie.com>
Subject: Re: [GIT PULL] power_supply: add power supply scope
Message-ID: <20111208104127.GA1753@oksana.dev.rtsoft.ru>
References: <CACo8zOd45i3EnCVMyJoDPP4bx2AnD9mEjDiC=bJKvmX=TWfXGg@mail.gmail.com>
 <4ED90E6D.8090402@goop.org>
 <CACo8zOcvKwr0wDkytvJfqyx4kV0ceYyCt+qnDqiSgxNywpzeHg@mail.gmail.com>
 <4ED9BDF8.3010600@goop.org>
 <CAD2FfiE-rg-1bMmVpYzBhnQcBMKKKO4WPnu0bvx+pvdFnpARrQ@mail.gmail.com>
 <4EDE4C7A.1010802@goop.org>
 <CAD2FfiHWuEmVTa54YqfJDk5zHpSQuM_nwPT=mR6NoWpajpydpg@mail.gmail.com>
 <4EDFA192.7000602@goop.org>
 <CAD2FfiF+fVoLPWpPyGGKdnoGhx1f=Loh2Ju-vdU58Y=2kf6C3g@mail.gmail.com>
 <4EE015D1.5070005@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4EE015D1.5070005@goop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 05:41:37PM -0800, Jeremy Fitzhardinge wrote:
[...]
> diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
> index 6512b20..ec36c82 100644
> --- a/drivers/acpi/ac.c
> +++ b/drivers/acpi/ac.c
> @@ -142,6 +142,9 @@ static int get_ac_property(struct power_supply *psy,
>  	case POWER_SUPPLY_PROP_ONLINE:
>  		val->intval = ac->state;
>  		break;
> +	case POWER_SUPPLY_PROP_SCOPE:
> +		val->intval = POWER_SUPPLY_SCOPE_SYSTEM;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}

Mm... how about the rest of the drivers? I.e. drivers/power/*battery.c?

I think it's not a great idea to patch every driver, would be better to make
it similar to how we handle power_supply.type (w/ default value 'SYSTEM').


But, thinking more about it... personally, from the ABI point of view, I'd
like to just see some kind of 'supplicants' directory in the power_supply
instances, with symlinks to an appropriate devices.

I.e.
/sys/class/power_supply/battery/supplicants/<device_name>
is a symlink to /sys/class/HID/.../device.

With a special meaning of an empty directory (or non-existent, or w/ a
symlink pointing to '/sys/devices/system') -- system power.

That way we may describe any possible power hierarchy.

>From the implementation point of view, for now power_supply may just
conditionally (by introducing power_supply.not_system_power flag)
expose power_supply.dev->parent to /sys/.../supplicants.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
