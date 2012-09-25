Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab2IYLjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:39:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280Ab2IYLjd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:39:33 -0400
Date: Tue, 25 Sep 2012 08:39:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] A driver for Si476x series of chips
Message-ID: <20120925083929.3b4fa97b@redhat.com>
In-Reply-To: <1347576013-28832-1-git-send-email-andrey.smirnov@convergeddevices.net>
References: <1347576013-28832-1-git-send-email-andrey.smirnov@convergeddevices.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey,

Em Qui, 2012-09-13 às 15:40 -0700, Andrey Smirnov escreveu:
This patchset contains a driver for a Silicon Laboratories 476x series
> of radio tuners. The driver itself is implemented as an MFD devices
> comprised of three parts:
>  1. Core device that provides all the other devices with basic
>  functionality and locking scheme.
>  2. Radio device that translates between V4L2 subsystem requests into
>  Core device commands.
>  3. Codec device that does similar to the earlier described task, but
>  for ALSA SoC subsystem.
> 
As this driver touches on 3 sub-systems (mfd, media and alsa), you need to copy not only media ML, but also mfd and alsa ones, as you'll need that one of the 3 involved maintainers to submit your patches with the ack of the other two ones, for the parts that are under their umbrella.

As the main functionality here is related to media, I suspect that I'll be the one that will be submitting the driver. So, you'll need to c/c the MFD maintainer for the stuff under drivers/mfd/, and the alsa maintainer, for the stuff under sound/[1].

Regards,
Mauro

[1] From MAINTAINERS file:

MULTIFUNCTION DEVICES (MFD)
M:	Samuel Ortiz <sameo@linux.intel.com>
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git
S:	Supported
F:	drivers/mfd/

SOUND
M:	Jaroslav Kysela <perex@perex.cz>
M:	Takashi Iwai <tiwai@suse.de>
L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
W:	http://www.alsa-project.org/
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git
T:	git git://git.alsa-project.org/alsa-kernel.git
S:	Maintained
F:	Documentation/sound/
F:	include/sound/
F:	sound/




> This driver has been tested to work in two different sytems:
>  1. A custom Tegra-based ARM board(design is based on Harmony board)
>  running linux kernel 3.1.10 kernel
>  2. A standalone USB-connected board that has a dedicated Cortex M3
>  working as a transparent USB to I2C bridge which was connected to a
>  off-the-shelf x86-64 laptop running Ubuntu with 3.2.0 kernel.
> 
> As far as SubmitChecklist is concerned following criteria should be
> satisfied: 2b, 3, 5, 7, 9, 10
> 
> Andrey Smirnov (3):
>   Add a core driver for SI476x MFD
>   Add a V4L2 driver for SI476X MFD
>   Add a codec driver for SI476X MFD
> 
>  drivers/media/radio/Kconfig        |   17 +
>  drivers/media/radio/radio-si476x.c | 1307 +++++++++++++++++++++++++++++++
>  drivers/mfd/Kconfig                |   14 +
>  drivers/mfd/Makefile               |    3 +
>  drivers/mfd/si476x-cmd.c           | 1509 ++++++++++++++++++++++++++++++++++++
>  drivers/mfd/si476x-i2c.c           | 1033 ++++++++++++++++++++++++
>  drivers/mfd/si476x-prop.c          |  477 ++++++++++++
>  include/linux/mfd/si476x-core.h    |  532 +++++++++++++
>  include/media/si476x.h             |  461 +++++++++++
>  sound/soc/codecs/Kconfig           |    4 +
>  sound/soc/codecs/Makefile          |    2 +
>  sound/soc/codecs/si476x.c          |  346 +++++++++
>  12 files changed, 5705 insertions(+)
>  create mode 100644 drivers/media/radio/radio-si476x.c
>  create mode 100644 drivers/mfd/si476x-cmd.c
>  create mode 100644 drivers/mfd/si476x-i2c.c
>  create mode 100644 drivers/mfd/si476x-prop.c
>  create mode 100644 include/linux/mfd/si476x-core.h
>  create mode 100644 include/media/si476x.h
>  create mode 100644 sound/soc/codecs/si476x.c
> 
> 
