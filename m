Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab2AIUHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 15:07:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34767 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933137Ab2AIUHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 15:07:36 -0500
Date: Mon, 9 Jan 2012 20:07:34 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: dd diasemi <dd.diasemi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: drivers/regulator/core.c: Fixes mapping inside
	regulator_mode_to_status() and makes it returning -EINVAL on
	invalid input.
Message-ID: <20120109200734.GB30766@opensource.wolfsonmicro.com>
References: <1326111140.22107.9.camel@sw-eng-lt-dc-vm2> <20120109161456.GC2974@opensource.wolfsonmicro.com> <CAEqHmAte=rvhjGUEdMgNQKfvPxSVTFR5TfWy13VPEhZj0T53KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEqHmAte=rvhjGUEdMgNQKfvPxSVTFR5TfWy13VPEhZj0T53KQ@mail.gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 07:20:50PM +0000, dd diasemi wrote:
> On Mon, Jan 9, 2012 at 4:14 PM, Mark Brown

> >>       default:
> >> -             return 0;
> >> +             return -EINVAL;

> > This behaviour is deliberate.

> For this moment, the only usage is in one file in
> wm831x_aldo_get_status() and wm831x_gp_ldo_get_status():
> 	ret = wm831x_aldo_get_mode(rdev);
> 	if (ret < 0)
> 		return ret;
> 	else
> 		return regulator_mode_to_status(ret);

> The usage mistreats the signed value 'ret' as wm831x_aldo_get_mode()
> always returns 0 on communication error. It effects in response as if
> the regulator was off.

> If that behaviour is deliberate, I would suggest to make it explicit:
>  	default:
> -		return 0;
> +		return REGULATOR_STATUS_OFF;

That's not the deliberate behaviour, the deliberate behaviour is to
return no mode if we didn't find one.
