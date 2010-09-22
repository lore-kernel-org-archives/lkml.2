Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab0IVKij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 06:38:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59799 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751678Ab0IVKhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 06:37:47 -0400
Date: Wed, 22 Sep 2010 11:38:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: Add max98088 CODEC driver
Message-ID: <20100922103806.GC22361@opensource.wolfsonmicro.com>
References: <B2150E1E4418E1438554A300EA5040E40D469C123B@ITSVLEX06.it.maxim-ic.internal>
 <20100901111432.GE17548@opensource.wolfsonmicro.com>
 <B2150E1E4418E1438554A300EA5040E40D46A5BB13@ITSVLEX06.it.maxim-ic.internal>
 <20100903101721.GE16587@rakim.wolfsonmicro.main>
 <B2150E1E4418E1438554A300EA5040E40D46E1B8E7@ITSVLEX06.it.maxim-ic.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B2150E1E4418E1438554A300EA5040E40D46E1B8E7@ITSVLEX06.it.maxim-ic.internal>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 07:49:30PM -0700, Peter Hsiang wrote:
> On Fri, Sep 03, 2010, Mark Brown wrote:

> > No, you should use the features of the current kernel.  For your
> > backport you can do things like supply soc-cache.c as well.

> The soc-cache.c in the latest kernel-next version supports codecs
> with volatile registers in 16 bit mode, but not for the 8 bit mode.
> See snd_soc_8_8_write.

> The source code comments confirmed this:
> "Note at present this code can not be used by CODECs with 
> volatile registers."  

> For this codec (with volatile registers), should we use the read
> and write functions in the codec driver until the 8-bit mode is
> supported by Linux soc-cache.c?

You should modify soc-cache.c to support volatile registers if you need
this; it's not been implemented because nobody needed it yet (someone
may get to it before you get round to resubmitting, but if they haven't
then just extend the core functionality).
