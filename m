Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030325Ab2KXJqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 04:46:17 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:46992 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030191Ab2KXJqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 04:46:14 -0500
Date: Sat, 24 Nov 2012 10:46:10 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] sound fixes for 3.7-rc7
Message-ID: <20121124094610.GA221@x4>
References: <s5hboeojvwj.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5hboeojvwj.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.11.23 at 14:23 +0100, Takashi Iwai wrote:
> Sound fixes for 3.7-rc7
> 
> The highlight of this update is the fixes for ASoC kirkwood by Russell.
> In addition to that, a couple of regression fixes for HD-audio due to
> the runtime PM support on 3.7, and other driver-specific regression
> fixes like USB MIDI on non-standard USB audio drivers.
> 
> Takashi Iwai (2):
>       ALSA: hda - Fix recursive suspend/resume call

This commit causes with !CONFIG_PM:

ound/pci/hda/hda_codec.c: In function ‘codec_exec_verb’:
sound/pci/hda/hda_codec.c:231:12: error: ‘struct hda_codec’ has no member named ‘in_pm’
  if (!codec->in_pm && res && *res == -1 && bus->rirb_error) {
            ^
sound/pci/hda/hda_codec.c:241:19: error: ‘struct hda_codec’ has no member named ‘in_pm’
  if (!err || codec->in_pm)
                   ^
make[3]: *** [sound/pci/hda/hda_codec.o] Error 1


-- 
Markus
