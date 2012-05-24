Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029Ab2EXD1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 23:27:10 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:27923
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756964Ab2EXD1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 23:27:08 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944hd25hf0ah)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 24 May 2012 11:27:00 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linuxzsc@gmail.com>, <shawn.guo@gmail.com>, <kernel@pengutronix.de>
Subject: Re: [PATCH 1/1] dma: imx-sdma: buf_tail should be initialize in
 prepare function
Message-ID: <20120524032659.GA19682@b20223-02.ap.freescale.net>
References: <1337603494-27464-1-git-send-email-richard.zhao@freescale.com>
 <20120524032026.GB17621@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120524032026.GB17621@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 11:20:29AM +0800, Shawn Guo wrote:
> On Mon, May 21, 2012 at 08:31:34PM +0800, Richard Zhao wrote:
> > This fix audio underrun issue. When SNDRV_PCM_TRIGGER_STOP
> > and SNDRV_PCM_TRIGGER_START, it calls prepare again. buf_tail
> > should be reset to zero.
> > So move buf_tail initialization into prepare function.
> > 
> I tried the patch on imx51, and it does not fix the issue for me.
> 
> Regards,
> Shawn
> 
> root@linaro-developer:~# aplay audio8k16S.wav
> Playing WAVE 'audio8k16S.wav' : Signed 16 bit Little Endian, Rate 8000 Hz, Stere
> o
> ^Z
> [1]+  Stopped                 aplay audio8k16S.wav
> root@linaro-developer:~# fg
> aplay audio8k16S.wav
> underrun!!! (at least 2034.382 ms long)
Does the audio playback recover? Without the patch, sometimes the
playback will have distortion and play too fast.

Thanks
Richard 

