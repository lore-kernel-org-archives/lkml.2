Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab2KEI71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:59:27 -0500
Received: from webbox1416.server-home.net ([77.236.96.61]:56233 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630Ab2KEI70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:59:26 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Daniel J Blueman <daniel@quora.org>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        Jaroslav Kysela <perex@perex.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] HDA: Fix digital microphone on CS420x
Date: Mon, 05 Nov 2012 09:59:21 +0100
Message-ID: <28172648.UT99xke6PI@ws-stein>
User-Agent: KMail/4.8.5 (Linux/3.5.7-gentoo; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAMVG2sv2dD=WXAiJnpEO7e-pnJ5gOnCn0JK5P+B_SWc4Wqg36w@mail.gmail.com>
References: <1352006344-3378-1-git-send-email-daniel@quora.org> <s5hd2ztsryr.wl%tiwai@suse.de> <CAMVG2sv2dD=WXAiJnpEO7e-pnJ5gOnCn0JK5P+B_SWc4Wqg36w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Monday 05 November 2012 07:22:24, Daniel J Blueman wrote:
> On 4 November 2012 16:16, Takashi Iwai <tiwai@suse.de> wrote:
> > Thanks, this looks more comprehensive.  DIG1 and DIG2 seem to have
> > been set wrongly in the original code, based on the Cirrus's example
> > code.  Is the right-only recording problem fixed by this patch?
> >
> 
> It is fixed. In the mbp101 init verbs, setting the vendor widget ADC
> configuration bit 12 to copy the ADC2 right channel to the left (0x1004 to
> nid 0x11 coef 2) is superfluous here, so presumably for the analogue mic
> in. I'll get time later to check all this.
> 
> The second coefficient index initialisation (0x000f to nid 0x11 coef 4) is
> now redundant, as we enable the mic bits later correctly now. I'll send an
> updated patch which drops this.
> 
> Alexander, could you check this doesn't break your machine?

I replaced my 2nd patch "hda: Cirrus: Fix wrong ADC config" with Daniel's 
patch "HDA: Fix digital microphone on CS420x" and I still get stereo in both 
ADC channels I'm using. So, no breakage, but I can't comment on the digital 
mic patch, because I'm not using it.

Best regards,
Alexander
-- 
Dipl.-Inf. Alexander Stein

SYS TEC electronic GmbH
August-Bebel-Str. 29
D-07973 Greiz

Tel: +49-3661-6279-0, Fax: +49-3661-6279-99
eMail:    Alexander.Stein@systec-electronic.com
Internet: http://www.systec-electronic.com

Managing Director: Dipl.-Phys. Siegmar Schmidt
Commercial registry: Amtsgericht Jena, HRB 205563
