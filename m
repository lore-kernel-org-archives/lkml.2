Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab2CHCGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 21:06:52 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33112 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab2CHCGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 21:06:47 -0500
MIME-Version: 1.0
In-Reply-To: <20120307114631.GE3107@opensource.wolfsonmicro.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
	<1329976011-2251-2-git-send-email-tomoya.rohm@gmail.com>
	<20120302163915.GD6056@opensource.wolfsonmicro.com>
	<CANKRQni8hPoHEsV2VecbgKBdfS5+rit0-jXzz_d8F_nY5-dN3g@mail.gmail.com>
	<20120306115246.GD19635@opensource.wolfsonmicro.com>
	<CANKRQngg+8LJvb-+Byv6XPqqWFyCU1U+-hppuxo_=CM1qLUF_Q@mail.gmail.com>
	<20120307114631.GE3107@opensource.wolfsonmicro.com>
Date: Thu, 8 Mar 2012 11:06:47 +0900
Message-ID: <CANKRQnh2x-EYyaiOaz58zBeAe7PKWNS6cE+yyha5jSvignigHw@mail.gmail.com>
Subject: Re: [PATCH v3] sound/soc/lapis: add platform driver for ML7213
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 8:46 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>> >> if these platform devices aren't used, device detection doesn't work correctly.
>> >> So, I added these.
>> > You've not actually mentioned the problem you were seeing...
>> I saw mapping problem between machine driver and platform driver.
>> e.g.  cpu_dai_name "ml7213ioh"
> You've still not explained the problem you're seeing but this sounds
> like something that should work.  Please address the

* Faced problem if there are no platform settings.
machine driver's hw_params is not called
platform_driver's functions(snd_pcm_ops, snd_soc_platform_driver) are
not called.

As a result, the following message is not showed . (by soc_pcm.c)
printk(KERN_INFO "asoc: %s <-> %s mapping ok\n", codec_dai->name,
         cpu_dai->name);

>> > Apart from anything else you've got the interrupt requested as
>> > IRQF_SHARED so the interrupt could get called at any time.  It's also
>> > not clear that you've got the hardware in a known good state.
>> Do you mean request_irq should move to somewhere, like open() or
>> hw_params() or ... ?
> You need to do enough hardware and software initialisation prior to
> requesting the interrupt to ensure that if an interrupt does happen it
> won't cause any ill effects.  Checks in the interrupt handler to make
> sure things like the ALSA layer stuff have been set up can also be used
> to make the interrupt handler safer.

I can understand your concern.
Let me clarify your think.
You think that interrupt handler must check whether ALSA initialization has
already finished or not before interrupt process executes.
Right?

thanks.
-- 
ROHM Co., Ltd.
tomoya
