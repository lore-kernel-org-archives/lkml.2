Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab2HBGFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:05:08 -0400
Received: from nm20.bullet.mail.ukl.yahoo.com ([217.146.183.194]:27850 "HELO
	nm20.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753193Ab2HBGFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:05:02 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Aug 2012 02:05:01 EDT
X-Yahoo-Newman-Id: 284704.65385.bm@smtp129.mail.ukl.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: m.VJlYAVM1lBBUwNLIP.9rk.0.OhGmN.hFxfjAo8ihXEt7o
 4oPOCwJ52L0ZgwB3Zi9sLCIDcWpDsjnKhZ0bld4Vo.GZFThwiE2J51rH81zw
 gkdbNWKfl8xVcWD4Kt1MyjhrhcP2Rpp07F1EhMh.R0g4CXpY2JAS411gjnRk
 f5mGF91ocmR9iiEAVS3T7Ogcd_US4pCuKFVBvSZX_GCmgrBbI..cqSU1Y4lT
 9Z5klEkQtxb0tA4Ei0MHoFreWn_STBzKLWOQJYNl0wWqwPxxMuPxXspUCAaY
 _KxeTh22bABqrmg2umfgIk_aSSGZd3VGXrtRWQ2sTuuXrBmIetidfMc4IFex
 59Fs3JTYzc.RK5V5r9GtD_HSH3nBQRuub7GYqKcG1K6jNYJ9DuK7mI7gdl8.
 35EM1iwqfiuXJNs4175Ck90rgnGY7.Dc-
X-Yahoo-SMTP: Bi9SToiswBAnI3e3zPOhqi7CYhWz
From: "Ola Lilja" <olalilja@yahoo.se>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <STEricsson_nomadik_linux@list.st.com>, <linus.walleij@stericsson.com>,
        <arnd@arndb.de>, <ola.o.lilja@stericsson.com>,
        <alsa-devel@alsa-project.org>, <lrg@ti.com>
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <1343741493-17671-3-git-send-email-lee.jones@linaro.org> <20120731134214.GK4468@opensource.wolfsonmicro.com> <5017EAC3.3080504@linaro.org> <20120731142820.GW4468@opensource.wolfsonmicro.com> <5017EDCA.4020601@linaro.org> <20120731145443.GY4468@opensource.wolfsonmicro.com> <5017F68B.3060400@linaro.org> <20120731151819.GC4468@opensource.wolfsonmicro.com> <5018D880.5090306@linaro.org> <20120801132022.GS11892@opensource.wolfsonmicro.com>
In-Reply-To: <20120801132022.GS11892@opensource.wolfsonmicro.com>
Subject: RE: [PATCH 1/6] ASoC: dapm: If one widget fails, do not force all subsequent widgets to fail too
Date: Thu, 2 Aug 2012 07:58:24 +0200
Message-ID: <003901cd7073$d49cacc0$7dd60640$@se>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac1v6GiBVIp9Y6vBTvSZISl1brnl2AAiMhwA
Content-Language: sv
x-antivirus: avast!
x-antivirus-status: Clean
X-Antivirus: avast! (VPS 120801-1, 08/02/2012), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: den 1 augusti 2012 15:20
> To: Lee Jones
> Cc: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> STEricsson_nomadik_linux@list.st.com; linus.walleij@stericsson.com;
> arnd@arndb.de; olalilja@yahoo.se; ola.o.lilja@stericsson.com; alsa-
> devel@alsa-project.org; lrg@ti.com
> Subject: Re: [PATCH 1/6] ASoC: dapm: If one widget fails, do not force
> all subsequent widgets to fail too
> 
> On Wed, Aug 01, 2012 at 08:19:28AM +0100, Lee Jones wrote:
> > On 31/07/12 16:18, Mark Brown wrote:
> 
> > >I'm not going to apply this patch.  This isn't a vendor BSP, we
> > >shouldn't be putting random hacks like this in core code.
> 
> > BSP kernel or otherwise, it still seems wrong to me to fail and
> entire
> > audio driver just because of a broken link.
> 
> No, really.  Random disconnections in the DAPM graph are just endless
> pain from a support and debug point of view.  This isn't something that
> randomly breaks on specific hardware where we'd expect random errors at
> runtime, it's something that will never have worked - it seems clear
> nobody tested the mainline submission.
> 
> It's very disappointing to see such an error exist, and even more
> disappointing that there's no interest in fixing the driver.

(Yes, I know this mailer isn't configured correctly, but I'm on vacation
and have no Linux-computer/community-mailer available. However I find it
important to answer this)
Mark, you very well know that I have put in a lot of effort in getting our
Ux500-driver mainlined. This is something I have driven without really
getting sanctioned directly at working, rendering it even harder to find
time for it.
Accusing me of having "no interest in fixing the driver" is just absurd
regarding the time I've spent on this. I'm also still driving for
mainlining our upcoming drivers, so there is no lack of interest, nor lack
of activity at our side. I really think you could afford a bit more polite
attitude when doing reviews. It is not easy to fulfill every single aspect
of mainlining directly and there is (most likely) no one that purposely do
break any community rules. At least not from my side.

Regarding the problem with the failing DAPM-widget I can probably guess
What is going wrong when Lee is trying it out. There will be two failing
clock-supply widgets due to the fact that on the mainline-code these
clocks simply is not there yet. I have, of course, tested this driver
before submitting it, and I wouldn't dream on submitting a driver where
there were failing widgets/routes. Internally, I have put a patch with our
clock-tree for Ux500 on, but this is not mainline-quality code and that is
why it is not submitted with the other patches I sent. The clocks are in
the moment of writing being worked on by other persons in ST-Ericsson, and
I would not have had any time to be doing all this which is not in the
scope of my responsibilities (which is the audio-domain).
Before you told me to create the clock-supply widget-type, I had only
warnings for these failing clocks, as an intermediate solution, before
the clock-tree was submitted, but now they are implemented with the clock-
supply-type and there will be route-errors instead.
Linus W. could probably shed some light of when the missing clocks are to
be submitted.

Regards,
Ola

