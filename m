Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab0JQUrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 16:47:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932785Ab0JQUrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 16:47:01 -0400
Message-ID: <4CBB60BB.8050404@redhat.com>
Date: Sun, 17 Oct 2010 18:46:51 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org, Abylai Ospan <aospan@netup.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCHES FOR 2.6.37]  Support for NetUP Dual DVB-T/C CI RF
 card V.2
References: <201010171955.18806.liplianin@me.by> <4CBB37DC.6050507@infradead.org> <4CBB3994.7060509@redhat.com> <201010172318.40892.liplianin@me.by>
In-Reply-To: <201010172318.40892.liplianin@me.by>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 17-10-2010 18:18, Igor M. Liplianin escreveu:
> В сообщении от 17 октября 2010 20:59:48 автор Mauro Carvalho Chehab написал:
>> Em 17-10-2010 15:52, Mauro Carvalho Chehab escreveu:
>>> Em 17-10-2010 14:55, Igor M. Liplianin escreveu:
>>>> Patches to support for NetUP Dual DVB-T/C-CI RF from NetUP Inc.
>>>>
>>>>         http://linuxtv.org/wiki/index.php/NetUP_Dual_DVB_T_C_CI_RF
>>>>
>>>> Version 2,  Altera FPGA firmware download module reworked.
>>>>
>>>> Features:
>>>>
>>>> PCI-e x1
>>>> Supports two DVB-T/DVB-C transponders simultaneously
>>>> Supports two analog audio/video channels simultaneously
>>>> Independent descrambling of two transponders
>>>> Hardware PID filtering
>>>>
>>>> Components:
>>>>
>>>> Conexant CX23885
>>>> STM STV0367 low-power and ultra-compact combo DVB-T/C single-chip
>>>> receiver Xceive XC5000 silicon TV tuner
>>>> Altera FPGA for Common Interafce
>>>>
>>>> The following changes since commit 1c8c51f7413ec522c7b729c8ebc5ce815fb7d4a8:
>>>>   V4L/DVB: drivers/media/IR/ene_ir.c: fix NULL dereference (2010-10-17
>>>>   09:50:42 -0200)
>>>>
>>>> are available in the git repository at:
>>>>   http://udev.netup.ru/git/v4l-dvb.git netup-for-media-tree-2
>>>>
>>>> Abylay Ospan (6):
>>>>       cx23885: Altera FPGA CI interface reworked.
>>>>       stv0367: change default value for AGC register.
>>>>       stv0367: implement uncorrected blocks counter.
>>>>       cx23885, cimax2.c: Fix case of two CAM insertion irq.
>>>>       Fix CI code for NetUP Dual  DVB-T/C CI RF card
>>>>       Force xc5000 firmware loading for NetUP Dual  DVB-T/C CI RF card
>>>>
>>>> Igor M. Liplianin (14):
>>>>       Altera FPGA firmware download module.
>>>>       Altera FPGA based CI driver module.
>>>>       Support for stv0367 multi-standard demodulator.
>>>>       xc5000: add support for DVB-C tuning.
>>>>       Initial commit to support NetUP Dual DVB-T/C CI RF card.
>>>>       cx23885: implement tuner_bus parameter for cx23885_board
>>>>       structure. cx23885: implement num_fds_portb, num_fds_portc
>>>>       parameters for cx23885_board structure. stv0367: Fix potential
>>>>       divide error
>>>>       cx23885: remove duplicate set interrupt mask
>>>>       stv0367: coding style corrections
>>>>       cx25840: Fix subdev registration and typo in cx25840-core.c
>>>>       cx23885: 0xe becomes 0xc again for NetUP Dual DVB-S2
>>>>       cx23885: disable MSI for NetUP cards, otherwise CI is not working
>>>>       cx23885, altera-ci: enable all PID's less than 0x20 in hardware
>>>>       PID filter.
>>>>  
>>>>  drivers/media/common/tuners/xc5000.c        |   18 +
>>>>  drivers/media/dvb/frontends/Kconfig         |    7 +
>>>>  drivers/media/dvb/frontends/Makefile        |    1 +
>>>>  drivers/media/dvb/frontends/stv0367.c       | 3419
>>>>  +++++++++++++++++++++++++ drivers/media/dvb/frontends/stv0367.h      
>>>>  |   62 +
>>>>  drivers/media/dvb/frontends/stv0367_priv.h  |  211 ++
>>>>  drivers/media/dvb/frontends/stv0367_regs.h  | 3614
>>>>  +++++++++++++++++++++++++++ drivers/media/video/cx23885/Kconfig       
>>>>   |   12 +-
>>>>  drivers/media/video/cx23885/Makefile        |    1 +
>>>>  drivers/media/video/cx23885/altera-ci.c     |  841 +++++++
>>>>  drivers/media/video/cx23885/altera-ci.h     |  102 +
>>>>  drivers/media/video/cx23885/cimax2.c        |   24 +-
>>>>  drivers/media/video/cx23885/cx23885-cards.c |  116 +-
>>>>  drivers/media/video/cx23885/cx23885-core.c  |   35 +-
>>>>  drivers/media/video/cx23885/cx23885-dvb.c   |  175 ++-
>>>>  drivers/media/video/cx23885/cx23885-reg.h   |    1 +
>>>>  drivers/media/video/cx23885/cx23885-video.c |    7 +-
>>>>  drivers/media/video/cx23885/cx23885.h       |    7 +-
>>>>  drivers/media/video/cx25840/cx25840-core.c  |    4 +-
>>>>  drivers/misc/Kconfig                        |    1 +
>>>>  drivers/misc/Makefile                       |    1 +
>>>>  drivers/misc/stapl-altera/Kconfig           |    8 +
>>>>  drivers/misc/stapl-altera/Makefile          |    3 +
>>>>  drivers/misc/stapl-altera/altera.c          | 2603 +++++++++++++++++++
>>>>  drivers/misc/stapl-altera/jbicomp.c         |  163 ++
>>>>  drivers/misc/stapl-altera/jbiexprt.h        |   32 +
>>>>  drivers/misc/stapl-altera/jbijtag.c         | 1038 ++++++++
>>>>  drivers/misc/stapl-altera/jbijtag.h         |   83 +
>>>>  drivers/misc/stapl-altera/jbistub.c         |   70 +
>>>>  include/misc/altera.h                       |   49 +
>>>>  30 files changed, 12674 insertions(+), 34 deletions(-)
>>>>  create mode 100644 drivers/media/dvb/frontends/stv0367.c
>>>>  create mode 100644 drivers/media/dvb/frontends/stv0367.h
>>>>  create mode 100644 drivers/media/dvb/frontends/stv0367_priv.h
>>>>  create mode 100644 drivers/media/dvb/frontends/stv0367_regs.h
>>>>  create mode 100644 drivers/media/video/cx23885/altera-ci.c
>>>>  create mode 100644 drivers/media/video/cx23885/altera-ci.h
>>>>  create mode 100644 drivers/misc/stapl-altera/Kconfig
>>>>  create mode 100644 drivers/misc/stapl-altera/Makefile
>>>>  create mode 100644 drivers/misc/stapl-altera/altera.c
>>>>  create mode 100644 drivers/misc/stapl-altera/jbicomp.c
>>>>  create mode 100644 drivers/misc/stapl-altera/jbiexprt.h
>>>>  create mode 100644 drivers/misc/stapl-altera/jbijtag.c
>>>>  create mode 100644 drivers/misc/stapl-altera/jbijtag.h
>>>>  create mode 100644 drivers/misc/stapl-altera/jbistub.c
>>>>  create mode 100644 include/misc/altera.h
>>>
>>> There are still a few issues at FPGA patch.
>>
>> In time: I didn't analyse the rest of the series, just the first patch, as
>> they're likely to have (some) of the problems pointed at fpga. After
>> having this driver fully fixed, I'll review the other patches. So, feel
>> free to fix issues close to the ones I've pointed at the other patches as
>> well.
>>
>> Thanks,
>> Mauro.
> 
> So, soon will be Verson number 3.
> 
> The fist patch is the eldest, so I'm returning to nine month ago.
> It's adapted to kernel user-space application, and all that legacy issues was from it.
> Other patches not related and written from scratch(well, almost).
> The driver took much effort from me, look at aggregate size of code.
> Also need to mention it's already functional and tested on real hardware.

Yeah, I noticed that it were ported from some other source code. In general,
such drivers require more attention, as they generally come from code that
doesn't run at CPU ring 0, so, issues there generally don't cause much troubles.
However, when porting to kernel, they have more potential to hurt. That's why
I'm analyzing it carefully.

My suggestion is that you should just post v3 of this patch as a PATCH (instead of
a git pull) at both LKML and LMML, for us to take another review (hopefully, the last one ;) )

After having it reviewed, you can submit your pull request.

> 
> Thank you for giving attention,
> Igor. 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

