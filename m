Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab2GYK5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 06:57:55 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44297 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab2GYK5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 06:57:54 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [REGRESSION] [KMS] [INTEL] Wrong resolution in console and XWindow
Date: Wed, 25 Jul 2012 12:57:49 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.0-rc3; KDE/4.8.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
References: <201207251020.47637.maciej.rutecki@gmail.com> <201207251054.25498.maciej.rutecki@gmail.com> <20120725092928.GD5396@phenom.ffwll.local>
In-Reply-To: <20120725092928.GD5396@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201207251257.50064.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 25 lipca 2012 o 11:29:28 Daniel Vetter wrote:
> On Wed, Jul 25, 2012 at 10:54:25AM +0200, Maciej Rutecki wrote:
> > On środa, 25 lipca 2012 o 10:29:26 Daniel Vetter wrote:
> > > On Wed, Jul 25, 2012 at 10:20:47AM +0200, Maciej Rutecki wrote:
> > > > Last known good: 3.4.4
> > > > First bad: 3.5.0
> > > > 
> > > > When booting 3.5.0 resolution (in console, and after in KDE) is set
> > > > to 1024x768 (60Hz). In 3.4.4 was correct: 1440x900 (60Hz).
> > > 
> > > Can you please attach the output of xrandr --verbose for both kernels?
> > > Also, please boot with drm.debug=0xe added to your kernel cmdline and
> > > grab the dmesg (again for both kernels).
> > 
> > Thanks for the ansfer.
> > 
> > Here xrandr and dmesg outputs for 3.4.4 and 3.5.0
> > 
> > http://mrutecki.pl/download/kernel/3.5/swinka/debug/
> 
> Can you please test this quick hack:
> 
> 
> diff --git a/drivers/gpu/drm/i915/intel_i2c.c
> b/drivers/gpu/drm/i915/intel_i2c.c index 1991a44..abe1611 100644
> --- a/drivers/gpu/drm/i915/intel_i2c.c
> +++ b/drivers/gpu/drm/i915/intel_i2c.c
> @@ -405,7 +405,7 @@ clear_err:
>  	 * timing out seems to happen when there _is_ a ddc chip present, but
>  	 * it's slow responding and only answers on the 2nd retry.
>  	 */
> -	ret = -ENXIO;
> +	ret = 0;
>  	if (wait_for((I915_READ(GMBUS2 + reg_offset) & GMBUS_ACTIVE) == 0,
>  		     10)) {
>  		DRM_DEBUG_KMS("GMBUS [%s] timed out after NAK\n",
> 
> 
> Thanks, Daniel

Still the same.

PS. Unfortunately, this afternoon I have small a surgical operation and 
further tests will be possible only after 2-3 days.

Regards
-- 
Maciej Rutecki
http://www.mrutecki.pl
