Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab0IVCtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 22:49:39 -0400
Received: from antispam01.maxim-ic.com ([205.153.101.182]:43818 "EHLO
	antispam01.maxim-ic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab0IVCth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 22:49:37 -0400
X-ASG-Debug-ID: 1285123777-6a7a99970001-xx1T2L
X-Barracuda-Envelope-From: Peter.Hsiang@maxim-ic.com
From: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 21 Sep 2010 19:49:30 -0700
X-ASG-Orig-Subj: RE: [PATCH] ASoC: Add max98088 CODEC driver
Subject: RE: [PATCH] ASoC: Add max98088 CODEC driver
Thread-Topic: [PATCH] ASoC: Add max98088 CODEC driver
Thread-Index: ActLUUNR8Bor+1e8SOePvX+lx2HMFgOYi4aw
Message-ID: <B2150E1E4418E1438554A300EA5040E40D46E1B8E7@ITSVLEX06.it.maxim-ic.internal>
References: <B2150E1E4418E1438554A300EA5040E40D469C123B@ITSVLEX06.it.maxim-ic.internal>
 <20100901111432.GE17548@opensource.wolfsonmicro.com>
 <B2150E1E4418E1438554A300EA5040E40D46A5BB13@ITSVLEX06.it.maxim-ic.internal>
 <20100903101721.GE16587@rakim.wolfsonmicro.main>
In-Reply-To: <20100903101721.GE16587@rakim.wolfsonmicro.main>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 22 Sep 2010 02:49:59.0430 (UTC) FILETIME=[D8D18260:01CB5A00]
X-Barracuda-Connect: terlingua.dalsemi.com[180.0.34.46]
X-Barracuda-Start-Time: 1285123777
X-Barracuda-URL: http://AntiSpam02.maxim-ic.com:8000/cgi-mod/mark.cgi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010, Mark Brown wrote:
> On Thu, Sep 02, 2010 at 04:30:14PM -0700, Peter Hsiang wrote:
> > On Wed, Sep 01, 2010, Mark Brown wrote:
> 
> > > > +/*
> > > > + * Read the MAX98088 I2C register space
> > > > + * Note: this driver source code is backward compatible to kernel
> > > > + * version 2.6.32.
> > > > + */
> > > > +static unsigned int max98088_read(struct snd_soc_codec *codec,
> > > > +                                 unsigned int reg)
> 
> > > Just use soc-cache.  Compatibility code for older kernels isn't really
> > > acceptable for mainline due to the increased maintainance burden and it
> > > will at best result in a driver that doesn't work as well as possible.
> 
> > This integrated registers feature is not available in 2.6.32
> > Is it ok with you to keep it this way for this release?  Thanks.
> 
> No, you should use the features of the current kernel.  For your
> backport you can do things like supply soc-cache.c as well.

The soc-cache.c in the latest kernel-next version supports codecs
with volatile registers in 16 bit mode, but not for the 8 bit mode.
See snd_soc_8_8_write.

The source code comments confirmed this:
"Note at present this code can not be used by CODECs with 
volatile registers."  

For this codec (with volatile registers), should we use the read
and write functions in the codec driver until the 8-bit mode is
supported by Linux soc-cache.c?

