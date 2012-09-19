Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab2ISVtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 17:49:12 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:47230 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752129Ab2ISVtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 17:49:11 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [alsa-devel] [RFC PATCH v2 0/5] snd-ice1712: Add Philips =?iso-8859-1?q?PSC724=09Ultimate?= Edge
Date: Wed, 19 Sep 2012 23:48:29 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
References: <1347994716-10251-1-git-send-email-linux@rainbow-software.org> <201209191903.14690.linux@rainbow-software.org> <s5hhaqtopxk.wl%tiwai@suse.de>
In-Reply-To: <s5hhaqtopxk.wl%tiwai@suse.de>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201209192348.30440.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2012 19:58:15 Takashi Iwai wrote:
> At Wed, 19 Sep 2012 19:03:14 +0200,
>
> Ondrej Zary wrote:
> > On Wednesday 19 September 2012 17:28:21 Takashi Iwai wrote:
> > > At Tue, 18 Sep 2012 20:58:31 +0200,
> > >
> > > Ondrej Zary wrote:
> > > > Hello,
> > > > this is second attempt to add Philips PSC724 Ultimate Edge sound card
> > > > support to snd-ice1712 driver. Unlike other snd-ice1712 subdrivers,
> > > > the codec code is splitted into separate modules and thus reusable by
> > > > other ice1712 subdrivers.
> > >
> > > Well, the problem is that most of ice17xx boards use only a part of
> > > channels on codecs.   Thus you don't want to expose controls for all
> > > channels, too.  Otherwise user will get confusing dead controls.
> >
> > The controls can be easily hidden by setting its name to NULL. It's even
> > used in the psc724 subdriver.
> >
> > > If these new modules are supposed to be used by other ice1712/ice1724
> > > sub drivers, they should provide some good binding mechanism, too.
> > > (And that's one of the good reasons why ASoC has been nominated.)
> >
> > They're easy to use, you just need to provide wm87x6_write() function. I
> > think that other subdrivers could be easily converted to use this (with
> > hardware to test).
>
> OK, but I'd like to have modules only when the code sharing happens.
> Also, it'd be better to have different module names, indicating that
> they are ice17xx-specific.

OK, I'll change the code to not produce modules.

> > > > Working: all analog outputs (front, rear, center+lfe, headphone) and
> > > > inputs (front mic, rear mic, line, cd, aux), mixer, headphone jack
> > > > detection, suspend/resume
> > > >
> > > > Currently untested: SPDIF
> > > >
> > > > Buggy: switching AGC mode in mixer causes alsamixer to crash - looks
> > > > like it does not like notifications about control
> > > > activating/deactivating

What about this? Is it a bug in my code or somewhere else?

-- 
Ondrej Zary
