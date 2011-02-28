Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab1B1NOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 08:14:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33953 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab1B1NOs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 08:14:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=wdz461KoQOpP5sCZ5sJZLlPH8Z+CVPoI6v7zzuYZdbs3ILipfh8Iiz4S1+itVLJZ+6
         1xTwWYk0MN8ZLsmfZImzdoujMic7moi3Ur7HSvpwiZXqAuX0s1F9Poti60afSgrc1ear
         FhVU8JPPtZBIyrXr7zreBgM9yFxKlhugPxa3Y=
MIME-Version: 1.0
In-Reply-To: <4D6A2E73.6070806@redhat.com>
References: <AANLkTinAYrGV1k357Bn8trtxafZDoYozG7LDcm3KNBSt@mail.gmail.com> <4D6A2E73.6070806@redhat.com>
From: halli manjunatha <manjunatha_halli@ti.com>
Date: Mon, 28 Feb 2011 18:42:34 +0530
X-Google-Sender-Auth: 5BvjvQ7VEHI3r5gnCr-F4OkNlSg
Message-ID: <AANLkTikfyVfxUX3LXnpOPZWNmG7zSpDY9itn+BHxhdo6@mail.gmail.com>
Subject: Re: [GIT PULL] TI WL 128x FM V4L2 driver
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 4:28 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>
> Em 25-01-2011 03:48, halli manjunatha escreveu:
> > Hi Mauro,
> >
> > Please pull the WL128x FM V4L2 driver from
> > http://dev.omapzoom.org/pub/scm/manju/L24x-btfm.git fm_v4l2_upstream
> >
> > This is TI WL128x FM V4L2 driver and it introduces ‘wl128x’ folder
> > under the ‘drivers/media/radio’. This driver enables support for FM RX
> > and TX for Texas Instrument's WL128x (also compatible with WL127x)
> > WiLink chip sets. The V4L2 FM driver can work in either Rx or Tx mode,
> > and V4L2 interfaces are provided for both.
> >
> > Texas Instrument's WL128x chip set packs BT, FM, GPS and WLAN in a
> > single die with BT, FM and GPS being interfaced over a single UART.
> > This driver works on top of the shared transport line discipline
> > driver. This driver can also be made use for the WL127x version of the
> > chip which packs BT, FM and WLAN only.
> >
> > This driver has been reviewed by various folks within TI and also in
> > Linux media community. The driver has been tested extensively on TI
> > platforms and we believe that it is ready for merge into mainline.
>
> Applied, thanks.
>
> From what I understood from your comments, this driver will also cover
> wl127x chips. As such, it would be better to double check if all functionalities
> present at drivers/media/radio/radio-wl1273.c (assuming that wl1273 is covered)
> are also on the new driver, and, if not, merge the remaining ones and deprecate
> the wl1273-specific driver.
>
> Cheers,
> Mauro

Yes, this driver supports all the functionalities which are supported
by radio-wl1273.c [But our driver is on UART while wl1273 is based on
i2c..]

NOTE: V4L2 FM driver depend upon an underlying TI_ST driver which is
the core transport driver [based on UART, it is a ldisc driver]

Updates to TI-ST driver happen on linux-next tree on kernel.org and
are planned to be released in 2.6.39.

Since your tree
@[http://git.linuxtv.org/media_tree.git?a=shortlog;h=refs/heads/staging/for_v2.6.39]

lags behind the linux-next tree, the recent updates to TI-ST driver
are missing on your tree.

Unfortunately these would cause a build failure for the V4L2 driver,
since the APIs have changed on the TI-ST driver.


So, I will provide you one patch to make the present driver to work
with latest ST driver once your tree moves to 2.6.38-rc6+ kernel.

Regards
Manju
> >
> > The following changes since commit db309d3d54c2f721dd1176ce86c63b0381c0a258:
> >   Mauro Carvalho Chehab (1):
> >         [media] add support for Encore FM3
> >
> > are available in the git repository at:
> >
> >   http://dev.omapzoom.org/pub/scm/manju/L24x-btfm.git fm_v4l2_upstream
> >
> > Manjunatha Halli (7):
> >       drivers:media:radio: wl128x: FM Driver common header file
> >       drivers:media:radio: wl128x: FM Driver V4L2 sources
> >       drivers:media:radio: wl128x: FM Driver Common sources
> >       drivers:media:radio: wl128x: FM driver RX sources
> >       drivers:media:radio: wl128x: FM driver TX sources
> >       drivers:media:radio: wl128x: Kconfig & Makefile for wl128x driver
> >       drivers:media:radio: Update Kconfig and Makefile for wl128x FM driver
> >
> >  drivers/media/radio/Kconfig               |    3 +
> >  drivers/media/radio/Makefile              |    1 +
> >  drivers/media/radio/wl128x/Kconfig        |   17 +
> >  drivers/media/radio/wl128x/Makefile       |    6 +
> >  drivers/media/radio/wl128x/fmdrv.h        |  244 +++++
> >  drivers/media/radio/wl128x/fmdrv_common.c | 1677 +++++++++++++++++++++++++++++
> >  drivers/media/radio/wl128x/fmdrv_common.h |  402 +++++++
> >  drivers/media/radio/wl128x/fmdrv_rx.c     |  847 +++++++++++++++
> >  drivers/media/radio/wl128x/fmdrv_rx.h     |   59 +
> >  drivers/media/radio/wl128x/fmdrv_tx.c     |  425 ++++++++
> >  drivers/media/radio/wl128x/fmdrv_tx.h     |   37 +
> >  drivers/media/radio/wl128x/fmdrv_v4l2.c   |  580 ++++++++++
> >  drivers/media/radio/wl128x/fmdrv_v4l2.h   |   33 +
> >  13 files changed, 4331 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/media/radio/wl128x/Kconfig
> >  create mode 100644 drivers/media/radio/wl128x/Makefile
> >  create mode 100644 drivers/media/radio/wl128x/fmdrv.h
> >  create mode 100644 drivers/media/radio/wl128x/fmdrv_common.c
> >  create mode 100644 drivers/media/radio/wl128x/fmdrv_common.h
> >  create mode 100644 drivers/media/radio/wl128x/fmdrv_rx.c
> >  create mode 100644 drivers/media/radio/wl128x/fmdrv_rx.h
> >  create mode 100644 drivers/media/radio/wl128x/fmdrv_tx.c
> >  create mode 100644 drivers/media/radio/wl128x/fmdrv_tx.h
> >  create mode 100644 drivers/media/radio/wl128x/fmdrv_v4l2.c
> >  create mode 100644 drivers/media/radio/wl128x/fmdrv_v4l2.h
> >
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
