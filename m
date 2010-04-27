Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab0D0JOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:14:52 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:53667 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab0D0JOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:14:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Jivv8sPI5dszY5GPJcujCVArZMf9J6gMdeL0u0+h/h/kY3zoVZeU0G1lqM/X2RLQmo
         qPLvPndOjat7F8Da8q3zrF1Sl9GllXLTQz/YJeQuRJeRnzFdGpK4bqLRhk+id1eLiVui
         1ccOeJUVeqh7XucndcBmvGoUw9kMlHuu4Wt8E=
Date: Tue, 27 Apr 2010 11:14:39 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost
To: Arnd Bergmann <arnd@arndb.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/6] Push down BKL into device drivers
In-Reply-To: <1272320645-8671-1-git-send-email-arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1004271112420.3318@localhost>
References: <201004262112.39906.arnd@arndb.de> <1272320645-8671-1-git-send-email-arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Apr 2010, Arnd Bergmann wrote:

> This is half the work of getting rid of the BKL in
> the ioctl file operation, the rest in arch/ and fs/
> still needs to be done, maybe two more hours of
> work (for someone else than me ;-)).
> 
> Pushdown is straightforward. In many cases, it's
> rather obvious that the BKL is not needed at all,
> but let's not mix the removal with the pushdown.

Hi Arnd. These pushdowns conflicted with Linus's renaming.
In addition I found a few errors due to the change to
unlocked_ioctl.

I will resubmit fixes to these problems in a new mail.

Thanks

> 
> Arnd Bergmann (6):
>   dvb: push down BKL into ioctl functions
>   scsi: push down BKL into ioctl functions
>   isdn: push down BKL into ioctl functions
>   staging: push down BKL into ioctl functions
>   v4l: always use unlocked_ioctl
>   drivers: push down BKL into various drivers
> 
>  drivers/block/pktcdvd.c                     |   13 ++++++--
>  drivers/char/apm-emulation.c                |    8 +++--
>  drivers/char/applicom.c                     |   13 +++++---
>  drivers/char/ds1620.c                       |   16 ++++++++-
>  drivers/char/dtlk.c                         |   15 +++++----
>  drivers/char/generic_nvram.c                |   17 ++++++++--
>  drivers/char/genrtc.c                       |   16 ++++++++-
>  drivers/char/hpet.c                         |   14 +++++---
>  drivers/char/i8k.c                          |   21 ++++++++++--
>  drivers/char/ipmi/ipmi_devintf.c            |   26 +++++++++++++---
>  drivers/char/ipmi/ipmi_watchdog.c           |   17 +++++++++-
>  drivers/char/nvram.c                        |   10 ++++--
>  drivers/char/nwflash.c                      |    7 +++-
>  drivers/char/raw.c                          |   42 ++++++++++++++-----------
>  drivers/hwmon/fschmd.c                      |    9 +++--
>  drivers/hwmon/w83793.c                      |   10 ++++--
>  drivers/input/misc/hp_sdc_rtc.c             |   34 ++++++++++++++------
>  drivers/isdn/capi/capi.c                    |   17 ++++++++--
>  drivers/isdn/divert/divert_procfs.c         |   19 ++++++++++--
>  drivers/isdn/i4l/isdn_common.c              |   18 +++++++++--
>  drivers/isdn/mISDN/timerdev.c               |   10 ++++--
>  drivers/macintosh/nvram.c                   |    2 +-
>  drivers/macintosh/via-pmu.c                 |   17 ++++++++--
>  drivers/media/dvb/dvb-core/dmxdev.c         |   31 +++++++++++++-----
>  drivers/media/dvb/dvb-core/dvb_ca_en50221.c |   17 +++++++---
>  drivers/media/dvb/dvb-core/dvb_frontend.c   |   30 +++++++++---------
>  drivers/media/dvb/dvb-core/dvb_net.c        |   15 +++++++--
>  drivers/media/dvb/dvb-core/dvbdev.c         |   17 +++++++----
>  drivers/media/dvb/dvb-core/dvbdev.h         |   11 ++----
>  drivers/media/dvb/firewire/firedtv-ci.c     |    5 +--
>  drivers/media/dvb/ttpci/av7110.c            |    4 +-
>  drivers/media/dvb/ttpci/av7110_av.c         |    8 ++--
>  drivers/media/dvb/ttpci/av7110_ca.c         |    5 +--
>  drivers/media/video/v4l2-dev.c              |   17 ++++++++--
>  drivers/mtd/mtdchar.c                       |   19 ++++++++---
>  drivers/pcmcia/pcmcia_ioctl.c               |   17 ++++++++--
>  drivers/rtc/rtc-m41t80.c                    |   16 ++++++++-
>  drivers/sbus/char/openprom.c                |   44 +++++++++++++++-----------
>  drivers/scsi/3w-9xxx.c                      |   10 ++++--
>  drivers/scsi/3w-sas.c                       |    7 +++-
>  drivers/scsi/3w-xxxx.c                      |   10 ++++--
>  drivers/scsi/aacraid/linit.c                |   11 +++++--
>  drivers/scsi/dpt_i2o.c                      |   20 ++++++++++--
>  drivers/scsi/gdth.c                         |   20 +++++++++---
>  drivers/scsi/megaraid.c                     |   20 ++++++++++--
>  drivers/scsi/megaraid/megaraid_mm.c         |   22 ++++++++++---
>  drivers/scsi/osst.c                         |   14 ++++++--
>  drivers/scsi/sg.c                           |   17 ++++++++--
>  drivers/staging/crystalhd/crystalhd_lnx.c   |   13 +++++--
>  drivers/staging/dt3155/dt3155_drv.c         |   24 +++++++++++----
>  drivers/staging/poch/poch.c                 |   17 +++++++++-
>  drivers/staging/vme/devices/vme_user.c      |   18 +++++++++--
>  drivers/usb/mon/mon_bin.c                   |   23 ++++++++++----
>  drivers/usb/mon/mon_stat.c                  |    3 +-
>  54 files changed, 631 insertions(+), 245 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
