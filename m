Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508Ab0JZSUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 14:20:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62315 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933455Ab0JZSUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 14:20:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Rusjx/xMSKeTQ22WasMC4myGktvFnYkDd78f6OEq5oF6SLTqpRSpfSQ3VGehbd+RMT
         sFYO9UFFyXX66N36kvsFanY2XIt6xuEAzVzVifBEtAB/6/4Sy22WZgnXcufCYypedJJw
         oGyyG2Rg6bJy6P1+Jq0RU8eQukc/KZzMFhUJE=
MIME-Version: 1.0
In-Reply-To: <s5haam24bls.wl%tiwai@suse.de>
References: <s5haam24bls.wl%tiwai@suse.de>
Date: Tue, 26 Oct 2010 14:20:49 -0400
Message-ID: <AANLkTi=DcsSQTeGER5tWjuLV6FpLCizO3ZMajqFCYPGe@mail.gmail.com>
Subject: Re: [GIT PULL] sound updates for 2.6.37-rc1
From: Arnaud Lacombe <lacombar@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Oct 25, 2010 at 9:59 AM, Takashi Iwai <tiwai@suse.de> wrote:
> Linus,
>
> please pull ALSA updates for v2.6.37-rc1 from:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git for-linus
>
> The biggest changes are the update of ASoC core API, in addition to
> lots of fixes/updates in ASoC drivers.  The summary regarding ASoC
> are:
>
> - Overhaul of the core APIs for registration of all kinds of devices,
>  reducing the level of direct coupling between machine drivers and their
>  CODEC and CPU drivers allowing ASoC machines to have multiple CODEC
>  devices and multiple instances of the same CODEC device within a system.
> - New CODEC drivers for  88PM860x CODEC, MAX98088, WL1273, WM8962, WM8804,
>  and WM8985.
> - New CPU drivers for EP93xx AC’97 controllers, MPC85xx SSI ports,
>  and SH HDMI controllers.
> - Machine support for Freescale P1022 DS, Marvell Tavor and Saarb, and
>  Simplemachines Sim.One.
>
> For HD-audio, the former individual HDMI parsers for ATI, Intel and
> Nvidia are now unified to a single parser.  Also, the BIOS pin parser
> was improved so that it can assign multiple input-pins for the same
> task (e.g. mic-in).
>
> Another new stuff is the aloop driver.  It's a simple PCM loopback
> driver for PCM data pass-through.  This has been in external
> alsa-driver tree for long time, and now it's revised and merged to
> upstream.
>
> Other than that, many driver updates including oxygen, USB-audio, and
> the removal of BKL in OSS code, (and yet-again-new ISA driver :),
> etc are found.
>
>
> Thanks!
>
> Takashi
>
> ===
> [...]
>
> Liam Girdwood (3):
>      ASoC: multi-component - ASoC Multi-Component Support
>  [...]
>  include/sound/soc-of-simple.h                      |   25 -
>  [...]
>  delete mode 100644 include/sound/soc-of-simple.h
>
`sound/soc/fsl/pcm030-audio-fabric.c' still reference
`sound/soc-of-simple.h', causing the following build error:

sound/soc/fsl/pcm030-audio-fabric.c:27:33: fatal error:
sound/soc-of-simple.h: No such file or directory

Confirmed in Linus' tree:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=sound/soc/fsl/pcm030-audio-fabric.c;h=fe15bb26e48474e6f9aacb15961d62b59cea704d;hb=HEAD

Config available if needed.

 - Arnaud
