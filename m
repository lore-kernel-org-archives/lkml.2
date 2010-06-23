Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab0FWVAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 17:00:19 -0400
Received: from emroute3.ornl.gov ([160.91.4.110]:60086 "EHLO emroute3.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab0FWVAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 17:00:17 -0400
X-Greylist: delayed 1080 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jun 2010 17:00:17 EDT
Date: Wed, 23 Jun 2010 16:42:12 -0400
From: David Dillow <dave@thedillows.org>
Subject: Re: PROBLEM: SIS7019 stops recording after 42 min
In-reply-to: <AANLkTiln40Xo3fHbMSkEvdBUtFq8ZWrF57wgRWdU2Juc@mail.gmail.com>
To: linux@schou.dk
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Message-id: <1277325732.2521.55.camel@lap75545.ornl.gov>
MIME-version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12)
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
References: <AANLkTimO5PXmJiIPDw82MTA53mLSl-OC0e1SOEh7v8pH@mail.gmail.com>
 <1276972298.22889.16.camel@obelisk.thedillows.org>
 <AANLkTimwZFNLBNJWODyzKXwx9CbIorg3OCA53XZchkeN@mail.gmail.com>
 <1277043970.22889.45.camel@obelisk.thedillows.org>
 <AANLkTikBTMq3d-Ov65wYLJ_Vw-7Jde4AOwfXcEPB0wLr@mail.gmail.com>
 <1277129180.22889.64.camel@obelisk.thedillows.org>
 <AANLkTikW71h7ABVXY21pLL9AeOlmRTfVaSTjJ_6Ma0_R@mail.gmail.com>
 <AANLkTikCGzUKe9Fy1d0xhberqGFe71lvrQbg5gkQzgf1@mail.gmail.com>
 <AANLkTikPW9j4H15gq7nl0Tb213R15uIQAnSDi_cTOJre@mail.gmail.com>
 <1277262047.10818.9.camel@obelisk.thedillows.org>
 <1277271419.10818.22.camel@obelisk.thedillows.org>
 <AANLkTiln40Xo3fHbMSkEvdBUtFq8ZWrF57wgRWdU2Juc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-23 at 20:22 +0200, Hans Schou wrote:
> 2010/6/23 David Dillow <dave@thedillows.org>:
> 
> > I can reproduce the alternating pattern of periods using a different
> > device, so this may be something in the core code of ALSA.
> 
> Strange? The program I am actually using is one I have written myself.
> I was sure I was using the old method as I open(2). In my program I
> use
>    int fd = open("/dev/dsp",  O_RDWR);
> 
> This should not go through ALSA (I think). I gues one should use
> something with "snd_pcm_open()" to use ALSA.

To use ALSA directly, yes. However, there is no OSS SIS7019 driver in
the kernel, only the ALSA one I wrote. There is an OSS emulation layer,
so you can use the OSS API to talk to the ALSA core. Unless you are
using a vendor (SIS/MicroJr/etc.) supplied driver, you are using ALSA in
some capacity.

> > Since this problem is not related to the SiS7019 driver, I'll leave it
> > to later -- or for others to investigate. Using three periods per buffer
> > sees a similar pattern, but one has an extra period time to work
> > within.
> 
> I really don't understand why I do not see this problem on other
> hardware using the same compiled code.

You mean the 10 second pauses during recording after 42 minutes? That is
a driver bug, so it is specific to this card.

If you mean the alternating long/sort period times, then it is present
on other hardware, but you likely don't see it either due to the
defaults giving you more periods to work in so you don't see overruns,
faster hardware than the SIS550 CPU, or a combination of the two. The
bug that gives rise to the 10 second pauses can also shorten the periods
I think, making overruns more likely to occur.

Dave


