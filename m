Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab1FPQkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:40:39 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:35624 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751479Ab1FPQkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:40:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=sHEQRaAOdeJoFkUWm7/i9t+5qiGIU943+D1u7BEkBmWDlBPUkyUoaP6Ob9qvOCUrmEJKnk28rEArHXntYbDioegchLUlYyXuecI2OOILHclMq5w+Rr0eLA0MV17ZeHZH;
Date: Thu, 16 Jun 2011 09:40:30 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [2.6.39] drm/i915: blank screen on Lenovo Ideapad U160
Message-ID: <20110616094030.15714852@jbarnes-desktop>
In-Reply-To: <gizkli0zew.fsf@karga.hank.lab>
References: <gi1uzevjl4.fsf@mx10.gouders.net>
	<alpine.DEB.2.00.1105311406210.5012@localhost6.localdomain6>
	<gitycau362.fsf@mx10.gouders.net>
	<giei3eoeic.fsf@mx10.gouders.net>
	<gi1uyx8m2f.fsf_-_@mx10.gouders.net>
	<20110615115903.685acba0@jbarnes-desktop>
	<giips6lr5a.fsf@mx10.gouders.net>
	<20110615144132.074167f3@jbarnes-desktop>
	<giei2ulpl1.fsf@mx10.gouders.net>
	<20110615150737.79cd5de7@jbarnes-desktop>
	<gi4o3q2plu.fsf@karga.hank.lab>
	<gizkli0zew.fsf@karga.hank.lab>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011 13:49:11 +0200
Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:

> Some redundant information, but if I change one line at another place
> in the i915 code (whithout the above modification) the result is more
> satisfactory on my machine, because in that case the display even works
> after I close and reopen the lid:
> 
> diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
> index 927442a..ebb67ae 100644
> --- a/drivers/gpu/drm/i915/intel_bios.c
> +++ b/drivers/gpu/drm/i915/intel_bios.c
> @@ -267,7 +267,7 @@ static int intel_bios_ssc_frequency(struct drm_device *dev,
>         case 4:
>                 return alternate ? 100 : 96;
>         default:
> -               return alternate ? 100 : 120;
> +               return alternate ? 120 : 100;
>         }
>  }

Does your machine also work if you set the lvds_use_ssc param to 0?

-- 
Jesse Barnes, Intel Open Source Technology Center
