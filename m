Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1B0K7L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 05:59:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab1B0K7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 05:59:10 -0500
Message-ID: <4D6A2E73.6070806@redhat.com>
Date: Sun, 27 Feb 2011 07:58:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: halli manjunatha <manjunatha_halli@ti.com>
CC: linux-media <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: Re: [GIT PULL] TI WL 128x FM V4L2 driver
References: <AANLkTinAYrGV1k357Bn8trtxafZDoYozG7LDcm3KNBSt@mail.gmail.com>
In-Reply-To: <AANLkTinAYrGV1k357Bn8trtxafZDoYozG7LDcm3KNBSt@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-01-2011 03:48, halli manjunatha escreveu:
> Hi Mauro,
> 
> Please pull the WL128x FM V4L2 driver from
> http://dev.omapzoom.org/pub/scm/manju/L24x-btfm.git fm_v4l2_upstream
> 
> This is TI WL128x FM V4L2 driver and it introduces ‘wl128x’ folder
> under the ‘drivers/media/radio’. This driver enables support for FM RX
> and TX for Texas Instrument's WL128x (also compatible with WL127x)
> WiLink chip sets. The V4L2 FM driver can work in either Rx or Tx mode,
> and V4L2 interfaces are provided for both.
> 
> Texas Instrument's WL128x chip set packs BT, FM, GPS and WLAN in a
> single die with BT, FM and GPS being interfaced over a single UART.
> This driver works on top of the shared transport line discipline
> driver. This driver can also be made use for the WL127x version of the
> chip which packs BT, FM and WLAN only.
> 
> This driver has been reviewed by various folks within TI and also in
> Linux media community. The driver has been tested extensively on TI
> platforms and we believe that it is ready for merge into mainline.

Applied, thanks.

>From what I understood from your comments, this driver will also cover 
wl127x chips. As such, it would be better to double check if all functionalities
present at drivers/media/radio/radio-wl1273.c (assuming that wl1273 is covered)
are also on the new driver, and, if not, merge the remaining ones and deprecate
the wl1273-specific driver.

Cheers,
Mauro
> 
> The following changes since commit db309d3d54c2f721dd1176ce86c63b0381c0a258:
>   Mauro Carvalho Chehab (1):
>         [media] add support for Encore FM3
> 
> are available in the git repository at:
> 
>   http://dev.omapzoom.org/pub/scm/manju/L24x-btfm.git fm_v4l2_upstream
> 
> Manjunatha Halli (7):
>       drivers:media:radio: wl128x: FM Driver common header file
>       drivers:media:radio: wl128x: FM Driver V4L2 sources
>       drivers:media:radio: wl128x: FM Driver Common sources
>       drivers:media:radio: wl128x: FM driver RX sources
>       drivers:media:radio: wl128x: FM driver TX sources
>       drivers:media:radio: wl128x: Kconfig & Makefile for wl128x driver
>       drivers:media:radio: Update Kconfig and Makefile for wl128x FM driver
> 
>  drivers/media/radio/Kconfig               |    3 +
>  drivers/media/radio/Makefile              |    1 +
>  drivers/media/radio/wl128x/Kconfig        |   17 +
>  drivers/media/radio/wl128x/Makefile       |    6 +
>  drivers/media/radio/wl128x/fmdrv.h        |  244 +++++
>  drivers/media/radio/wl128x/fmdrv_common.c | 1677 +++++++++++++++++++++++++++++
>  drivers/media/radio/wl128x/fmdrv_common.h |  402 +++++++
>  drivers/media/radio/wl128x/fmdrv_rx.c     |  847 +++++++++++++++
>  drivers/media/radio/wl128x/fmdrv_rx.h     |   59 +
>  drivers/media/radio/wl128x/fmdrv_tx.c     |  425 ++++++++
>  drivers/media/radio/wl128x/fmdrv_tx.h     |   37 +
>  drivers/media/radio/wl128x/fmdrv_v4l2.c   |  580 ++++++++++
>  drivers/media/radio/wl128x/fmdrv_v4l2.h   |   33 +
>  13 files changed, 4331 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/radio/wl128x/Kconfig
>  create mode 100644 drivers/media/radio/wl128x/Makefile
>  create mode 100644 drivers/media/radio/wl128x/fmdrv.h
>  create mode 100644 drivers/media/radio/wl128x/fmdrv_common.c
>  create mode 100644 drivers/media/radio/wl128x/fmdrv_common.h
>  create mode 100644 drivers/media/radio/wl128x/fmdrv_rx.c
>  create mode 100644 drivers/media/radio/wl128x/fmdrv_rx.h
>  create mode 100644 drivers/media/radio/wl128x/fmdrv_tx.c
>  create mode 100644 drivers/media/radio/wl128x/fmdrv_tx.h
>  create mode 100644 drivers/media/radio/wl128x/fmdrv_v4l2.c
>  create mode 100644 drivers/media/radio/wl128x/fmdrv_v4l2.h
> 

