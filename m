Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab1BNM3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 07:29:14 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56263 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab1BNM3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 07:29:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=uudJ11r21LtURUrfhtRHDCz4dJ023sv8LSwfVUPxb5ylq+vEVlzX3iURETjZbgMK8o
         7u1zG4kqIh/LnJnC4o0y3apnVq0oAOCEzjHU/hhy0z8HSJkyFsIK82FZVi7zZwqk4edT
         nJ5o1532YAJ6iKbXZKjM8HJwumIuOnCtYohCs=
MIME-Version: 1.0
In-Reply-To: <AANLkTingOYyEs4ZZrcaV0NOhiuGzSpvkATPRFjhFMCmE@mail.gmail.com>
References: <AANLkTinAYrGV1k357Bn8trtxafZDoYozG7LDcm3KNBSt@mail.gmail.com> <AANLkTingOYyEs4ZZrcaV0NOhiuGzSpvkATPRFjhFMCmE@mail.gmail.com>
From: halli manjunatha <manjunatha_halli@ti.com>
Date: Mon, 14 Feb 2011 17:58:48 +0530
X-Google-Sender-Auth: QjOVltDsnCPUEw-OtKgTGoTAEik
Message-ID: <AANLkTinQxwK_nVtJ2OOoQx8pTL_58cqoW4ZEE-utxbic@mail.gmail.com>
Subject: Re: [GIT PULL] TI WL 128x FM V4L2 driver
To: linux-media <linux-media@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

V4L2 FM driver depend upon an underlying TI_ST driver which is the
core transport driver.
Updates to TI-ST driver happen on linux-next tree on kernel.org and
are planned to be released in 2.6.39.

Since your tree @
[http://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git]
lags behind the linux-next tree, the recent updates to TI-ST driver
are missing on your tree.

Unfortunately these would cause a build failure for the V4L2 driver,
since the APIs have changed on the TI-ST driver.
So, Please suggest on how to proceed to submit V4L2 driver ?

Do I pull in the changes which have gone into linux-next on my clone
of your tree ? So that during a GIT pull changes on linux-next for
TI-ST driver also gets into your tree?

Regards
Manjunatha Halli

> On Tue, Jan 25, 2011 at 11:18 AM, halli manjunatha <manjunatha_halli@ti.com> wrote:
>>
>> Hi Mauro,
>>
>> Please pull the WL128x FM V4L2 driver from
>> http://dev.omapzoom.org/pub/scm/manju/L24x-btfm.git fm_v4l2_upstream
>>
>> This is TI WL128x FM V4L2 driver and it introduces ‘wl128x’ folder
>> under the ‘drivers/media/radio’. This driver enables support for FM RX
>> and TX for Texas Instrument's WL128x (also compatible with WL127x)
>> WiLink chip sets. The V4L2 FM driver can work in either Rx or Tx mode,
>> and V4L2 interfaces are provided for both.
>>
>> Texas Instrument's WL128x chip set packs BT, FM, GPS and WLAN in a
>> single die with BT, FM and GPS being interfaced over a single UART.
>> This driver works on top of the shared transport line discipline
>> driver. This driver can also be made use for the WL127x version of the
>> chip which packs BT, FM and WLAN only.
>>
>> This driver has been reviewed by various folks within TI and also in
>> Linux media community. The driver has been tested extensively on TI
>> platforms and we believe that it is ready for merge into mainline.
>>
>> The following changes since commit db309d3d54c2f721dd1176ce86c63b0381c0a258:
>>  Mauro Carvalho Chehab (1):
>>        [media] add support for Encore FM3
>>
>> are available in the git repository at:
>>
>>  http://dev.omapzoom.org/pub/scm/manju/L24x-btfm.git fm_v4l2_upstream
>>
>> Manjunatha Halli (7):
>>      drivers:media:radio: wl128x: FM Driver common header file
>>      drivers:media:radio: wl128x: FM Driver V4L2 sources
>>      drivers:media:radio: wl128x: FM Driver Common sources
>>      drivers:media:radio: wl128x: FM driver RX sources
>>      drivers:media:radio: wl128x: FM driver TX sources
>>      drivers:media:radio: wl128x: Kconfig & Makefile for wl128x driver
>>      drivers:media:radio: Update Kconfig and Makefile for wl128x FM driver
>>
>>  drivers/media/radio/Kconfig               |    3 +
>>  drivers/media/radio/Makefile              |    1 +
>>  drivers/media/radio/wl128x/Kconfig        |   17 +
>>  drivers/media/radio/wl128x/Makefile       |    6 +
>>  drivers/media/radio/wl128x/fmdrv.h        |  244 +++++
>>  drivers/media/radio/wl128x/fmdrv_common.c | 1677 +++++++++++++++++++++++++++++
>>  drivers/media/radio/wl128x/fmdrv_common.h |  402 +++++++
>>  drivers/media/radio/wl128x/fmdrv_rx.c     |  847 +++++++++++++++
>>  drivers/media/radio/wl128x/fmdrv_rx.h     |   59 +
>>  drivers/media/radio/wl128x/fmdrv_tx.c     |  425 ++++++++
>>  drivers/media/radio/wl128x/fmdrv_tx.h     |   37 +
>>  drivers/media/radio/wl128x/fmdrv_v4l2.c   |  580 ++++++++++
>>  drivers/media/radio/wl128x/fmdrv_v4l2.h   |   33 +
>>  13 files changed, 4331 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/media/radio/wl128x/Kconfig
>>  create mode 100644 drivers/media/radio/wl128x/Makefile
>>  create mode 100644 drivers/media/radio/wl128x/fmdrv.h
>>  create mode 100644 drivers/media/radio/wl128x/fmdrv_common.c
>>  create mode 100644 drivers/media/radio/wl128x/fmdrv_common.h
>>  create mode 100644 drivers/media/radio/wl128x/fmdrv_rx.c
>>  create mode 100644 drivers/media/radio/wl128x/fmdrv_rx.h
>>  create mode 100644 drivers/media/radio/wl128x/fmdrv_tx.c
>>  create mode 100644 drivers/media/radio/wl128x/fmdrv_tx.h
>>  create mode 100644 drivers/media/radio/wl128x/fmdrv_v4l2.c
>>  create mode 100644 drivers/media/radio/wl128x/fmdrv_v4l2.h
>>
>> --
>> Best Regards
>> Manjunatha Halli
>
