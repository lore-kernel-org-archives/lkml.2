Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab0G0P6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 11:58:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab0G0P6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 11:58:41 -0400
Message-ID: <4C4F0244.2070803@redhat.com>
Date: Tue, 27 Jul 2010 12:59:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100720 Red Hat/3.1.1-1.el6 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>, Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 0/15] STAGING: add lirc device drivers
References: <20100726232546.GA21225@redhat.com>
In-Reply-To: <20100726232546.GA21225@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 26-07-2010 20:25, Jarod Wilson escreveu:
> This patch series adds the remaining lirc_foo device drivers to the staging
> tree. The core lirc_dev driver and lirc headers are currently merged in a
> v4l/dvb staging tree (which is pulled into linux-next), and are utilized by
> way of an IR decoder/encoder bridge plugin to ir-core.
> 
> I've started porting lirc_foo drivers over to ir-core, first tackling the
> lirc_mceusb and lirc_imon drivers. lirc_mceusb is no more, replaced by a
> pure ir-core mceusb driver, and lirc_imon only supports the old first-gen
> imon devices now, which are quite different from the current-gen ones, now
> supported by a pure ir-core imon driver.
> 
> The long-term goal here is that all of these drivers should either be ported
> to ir-core, or dropped entirely. Some of them (*cough* lirc_parallel *cough*)
> should likely just be put out to pasture, but others are definitely still in
> use by quite a few people out there. I've got hardware for another four or
> five of the drivers, but not the rest, so I'm hoping that maybe people who
> have the hardware will pitch in and help with the porting if the bits are
> more readily available by way of the staging tree.
> 
> Drivers I have hardware for, and am thus most likely to work on porting to
> ir-core before any others (and probably in this order):
> - lirc_zilog
> - lirc_streamzap
> - lirc_i2c
> - lirc_serial
> - lirc_sir
> 
> Additionally, Maxim Levitsky, the author of lirc_ene0100, has already started
> work on porting lirc_ene0100 to ir-core. Everything else, definitely
> looking for help.
> 
> Patches:
> staging/lirc: add lirc_bt829 driver
> staging/lirc: add lirc_ene0100 driver
> staging/lirc: add lirc_i2c driver
> staging/lirc: add lirc_igorplugusb driver
> staging/lirc: add lirc_imon driver
> staging/lirc: add lirc_it87 driver
> staging/lirc: add lirc_ite8709 driver
> staging/lirc: add lirc_parallel driver
> staging/lirc: add lirc_sasem driver
> staging/lirc: add lirc_serial driver
> staging/lirc: add lirc_sir driver
> staging/lirc: add lirc_streamzap driver
> staging/lirc: add lirc_ttusbir driver
> staging/lirc: add lirc_zilog driver
> staging/lirc: wire up Kconfig and Makefile bits
> 
> Diffstat:
>  drivers/staging/Kconfig                 |    2 +
>  drivers/staging/Makefile                |    1 +
>  drivers/staging/lirc/Kconfig            |  110 +++
>  drivers/staging/lirc/Makefile           |   19 +
>  drivers/staging/lirc/TODO               |    8 +
>  drivers/staging/lirc/lirc_bt829.c       |  383 +++++++++
>  drivers/staging/lirc/lirc_ene0100.c     |  646 ++++++++++++++
>  drivers/staging/lirc/lirc_ene0100.h     |  169 ++++
>  drivers/staging/lirc/lirc_i2c.c         |  536 ++++++++++++
>  drivers/staging/lirc/lirc_igorplugusb.c |  555 ++++++++++++
>  drivers/staging/lirc/lirc_imon.c        | 1058 +++++++++++++++++++++++
>  drivers/staging/lirc/lirc_it87.c        | 1019 +++++++++++++++++++++++
>  drivers/staging/lirc/lirc_it87.h        |  116 +++
>  drivers/staging/lirc/lirc_ite8709.c     |  542 ++++++++++++
>  drivers/staging/lirc/lirc_parallel.c    |  705 ++++++++++++++++
>  drivers/staging/lirc/lirc_parallel.h    |   26 +
>  drivers/staging/lirc/lirc_sasem.c       |  933 +++++++++++++++++++++
>  drivers/staging/lirc/lirc_serial.c      | 1313 +++++++++++++++++++++++++++++
>  drivers/staging/lirc/lirc_sir.c         | 1282 ++++++++++++++++++++++++++++
>  drivers/staging/lirc/lirc_streamzap.c   |  821 ++++++++++++++++++
>  drivers/staging/lirc/lirc_ttusbir.c     |  397 +++++++++
>  drivers/staging/lirc/lirc_zilog.c       | 1387
> +++++++++++++++++++++++++++++++
>  22 files changed, 12028 insertions(+), 0 deletions(-)
> 
Hi Jarod,

Please add a TODO file at staging/lirc, describing what's needed for
the drivers to move to the IR branch.

Greg,

It is probably simpler to merge those files via my tree, as they depend
on some changes scheduled for 2.6.36.

Would it be ok for you if I merge them from my tree?

Cheers,
Mauro


