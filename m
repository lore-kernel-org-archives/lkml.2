Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab0HCLNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 07:13:05 -0400
Received: from sypressi.dnainternet.net ([83.102.40.135]:49280 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475Ab0HCLNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 07:13:04 -0400
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Aug 2010 07:13:03 EDT
X-Spam-Flag: NO
X-Spam-Score: -1.36
From: Anssi Hannula <anssi.hannula@iki.fi>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 0/2] ALSA: hda - support HDMI HBR passthrough
Date: Tue, 3 Aug 2010 14:04:01 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.35-0.rc5.1mdv; KDE/4.4.92; x86_64; ; )
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
References: <1280831338-4596-1-git-send-email-anssi.hannula@iki.fi> <s5h62zsm076.wl%tiwai@suse.de>
In-Reply-To: <s5h62zsm076.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008031404.01578.anssi.hannula@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai kirjoitti tiistai, 3. elokuuta 2010 13:59:09:
> At Tue,  3 Aug 2010 13:28:56 +0300,
> 
> Anssi Hannula wrote:
> > Hi all!
> > 
> > This patchset adds support for passing through IEC 61937 encapsulated
> > compressed audio at high bitrates (i.e. those over 6.144Mbps).
> > At least TrueHD and DTS-HD are such formats.
> > 
> > I've tested this using an NVIDIA hdmi codec and the following ffmpeg
> > patch which adds support for TrueHD in its IEC 61937 muxer:
> > http://lists.mplayerhq.hu/pipermail/ffmpeg-devel/2010-August/094317.html
> > 
> > One needs to set the AES0 & 0x02 (non-audio) bit during playback so that
> > the data is not transmitted as normal 8 channel PCM audio.
> 
> Thanks, I applied both patches.
> 
> There are some magic numbers there like 0x8000, and I'm going to define
> them...

Yeah, I guess all the Stream Format bits should be defined to get rid of all 
the existing magic numbers in snd_hda_calc_stream_format() as well.

> 
> Takashi
> 
> > ---
> > 
> > Anssi Hannula (2):
> >       ALSA: hda - Set Stream Type in Stream Format according to AES0
> >       ALSA: hda - Add support for HDMI HBR passthrough
> >  
> >  sound/pci/hda/hda_codec.c       |    6 ++++-
> >  sound/pci/hda/hda_codec.h       |    6 ++++-
> >  sound/pci/hda/hda_intel.c       |    3 +-
> >  sound/pci/hda/patch_hdmi.c      |   40
> >  ++++++++++++++++++++++++++++++++++++++- sound/pci/hda/patch_intelhdmi.c
> >  |    3 +-
> >  sound/pci/hda/patch_nvhdmi.c    |    3 +-
> >  6 files changed, 53 insertions(+), 8 deletions(-)

-- 
Anssi Hannula
