Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab0L2U6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 15:58:25 -0500
Received: from mirapoint3.brutele.be ([212.68.199.148]:40272 "EHLO
	mirapoint3.brutele.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab0L2U6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 15:58:22 -0500
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Dec 2010 15:58:22 EST
Message-ID: <4D1B9F53.4000004@tvcablenet.be>
Date: Wed, 29 Dec 2010 21:51:31 +0100
From: =?ISO-8859-1?Q?Fran=E7ois_Valenduc?= 
	<francois.valenduc@tvcablenet.be>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101219 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.video.dri.devel
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Jeff Chua <jeff.chua.linux@gmail.com>,
        Alex Riesen <raa.lkml@gmail.com>
Subject: Re: Linux 2.6.37-rc8 (no fb)
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>	<20101229102127.06c0e505.randy.dunlap@oracle.com>	<AANLkTims54zDXZYjZiiHfSOwy0W=gOF2jV8yopQxFBny@mail.gmail.com> <20101229121601.179983b7@jbarnes-desktop>
In-Reply-To: <20101229121601.179983b7@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Junkmail-Status: score=10/50, host=mirapoint3.brutele.be
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A0B020A.4D1B9F54.01C8,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-06-24 23:00:37,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 29/12/10 21:16, Jesse Barnes a écrit :
> On Wed, 29 Dec 2010 11:40:04 -0800
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Wed, Dec 29, 2010 at 10:21 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>>
>>> The only significant difference that I can see in the kernel message log
>>> is this:
>>
>> Hmm. I suspect that difference should have gone away with commit
>> 92971021c6328 (Revert "drm: Don't try and disable an encoder that was
>> never enabled"), but clearly that didn't fix your blank screen.
>>
>> Does reverting commit 448f53a1ede54eb854d036abf54573281412d650
>> ("drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks") fix it for
>> you? It does for some people..
>>
>> Chris - why did that lvds_ssc_freq thing suddenly start mattering? Can
>> we please just disable spread-spectrum entirely? Or perhaps only if we
>> notice that it was enabled already? Or something?
> 
> Randy, Jeff and Alex, does the below help at all?  If so, it may be the
> minimal fix we want for 2.6.37.
> 
> diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios
> index 2b20786..d27d016 100644
> --- a/drivers/gpu/drm/i915/intel_bios.c
> +++ b/drivers/gpu/drm/i915/intel_bios.c
> @@ -263,6 +263,9 @@ parse_general_features(struct drm_i915_private *dev_priv,
>                 dev_priv->int_tv_support = general->int_tv_support;
>                 dev_priv->int_crt_support = general->int_crt_support;
>                 dev_priv->lvds_use_ssc = general->enable_ssc;
> +               /* force disable until we can parse this correctly */
> +               if (IS_GEN5(dev) || IS_GEN6(dev))
> +                       dev_priv->lvds_use_ssc = 0;
>  
>                 if (dev_priv->lvds_use_ssc) {
>                         if (IS_I85X(dev))
> 
> 
I also encountered the black screen problem after commit 448f53a1. I can
confirm that the above patch solves the problem.

François Valenduc
