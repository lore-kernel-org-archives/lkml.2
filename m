Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab1BGMO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 07:14:27 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53060 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab1BGMO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 07:14:26 -0500
Message-ID: <4D4FE1D6.5050507@ru.mvista.com>
Date: Mon, 07 Feb 2011 15:13:10 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide: legacy VLB drivers housekeeping
References: <201102071153.37633.bzolnier@gmail.com>
In-Reply-To: <201102071153.37633.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07-02-2011 13:53, Bartlomiej Zolnierkiewicz wrote:

> * remove stale documentation
> * remove dead ALWAYS_SET_DTC2278_PIO_MODE code from dtc2278
> * remove legacy debugging code from ht6560b

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
[...]

> Index: b/drivers/ide/ali14xx.c
> ===================================================================
> --- a/drivers/ide/ali14xx.c
> +++ b/drivers/ide/ali14xx.c
> @@ -7,32 +7,7 @@
>    *
>    * Works for ALI M1439/1443/1445/1487/1489 chipsets.
>    *
> - * Adapted from code developed by derekn@vw.ece.cmu.edu.  -ml
> - * Derek's notes follow:
> - *
> - * I think the code should be pretty understandable,
> - * but I'll be happy to (try to) answer questions.
> - *
> - * The critical part is in the setupDrive function.  The initRegisters
> - * function doesn't seem to be necessary, but the DOS driver does it, so
> - * I threw it in.
> - *
> - * I've only tested this on my system, which only has one disk.  I posted
> - * it to comp.sys.linux.hardware, so maybe some other people will try it
> - * out.
> - *
> - * Derek Noonburg  (derekn@ece.cmu.edu)
> - * 95-sep-26
> - *
> - * Update 96-jul-13:
> - *
> - * I've since upgraded to two disks and a CD-ROM, with no trouble, and
> - * I've also heard from several others who have used it successfully.
> - * This driver appears to work with both the 1443/1445 and the 1487/1489
> - * chipsets.  I've added support for PIO mode 4 for the 1487.  This
> - * seems to work just fine on the 1443 also, although I'm not sure it's
> - * advertised as supporting mode 4.  (I've been running a WDC AC21200 in
> - * mode 4 for a while now with no trouble.)  -Derek
> + * Adapted from code developed by Derek Noonburg<derekn@vw.ece.cmu.edu>.  -
> ml

    The patch is line-wrapped...

> Index: b/drivers/ide/dtc2278.c
> ===================================================================
> --- a/drivers/ide/dtc2278.c
> +++ b/drivers/ide/dtc2278.c
> @@ -2,6 +2,17 @@
>    *  Copyright (C) 1996  Linus Torvalds&  author (see below)
>    */
>
> +/*
> + * Initial DTC-2278 support from Dyan Wile<andy@cercle.cts.com>.
> + */
> +
> +/*
> + * DTC2278S has only a single IDE interface
> + * DTC2278D has two IDE interfaces and is otherwise identical to the S
> version

    Here too...

> + * DTC2278E also has serial ports and a printer port
> + * DTC2278EB: has onboard BIOS
> + */
> +
>   #include<linux/module.h>
>   #include<linux/types.h>
>   #include<linux/kernel.h>
> @@ -17,37 +28,6 @@
>
>   #define DRV_NAME "dtc2278"
>
> -/*
> - * Changing this #undef to #define may solve start up problems in some
> systems.

    And here...

> - */
> -#undef ALWAYS_SET_DTC2278_PIO_MODE
> -
> -/*
> - * From: andy@cercle.cts.com (Dyan Wile)
> - *
> - * Below is a patch for DTC-2278 - alike software-programmable controllers
> - * The code enables the secondary IDE controller and the PIO4 (3?) timings on
> - * the primary (EIDE). You may probably have to enable the 32-bit support to
> - * get the full speed. You better get the disk interrupts disabled ( hdparm -
> u0
> - * /dev/hd.. ) for the drives connected to the EIDE interface. (I get my
> - * filesystem  corrupted with -u1, but under heavy disk load only :-)
> - *
> - * This card is now forced to use the "serialize" feature,
> - * and irq-unmasking is disallowed.  If io_32bit is enabled,
> - * it must be done for BOTH drives on each interface.
> - *
> - * This code was written for the DTC2278E, but might work with any of these:
> - *
> - * DTC2278S has only a single IDE interface.
> - * DTC2278D has two IDE interfaces and is otherwise identical to the S
> version.
> - * DTC2278E also has serial ports and a printer port
> - * DTC2278EB: has onboard BIOS, and "works like a charm" -- Kent Bradford
> <kent@theory.caltech.edu>

    And above...

> Index: b/drivers/ide/ht6560b.c
> ===================================================================
> --- a/drivers/ide/ht6560b.c
> +++ b/drivers/ide/ht6560b.c

> @@ -227,20 +173,10 @@ static u8 ht_pio2timings(ide_drive_t *dr
>   		if (recovery_cycles<  2)  recovery_cycles = 2;
>   		if (active_cycles>  15) active_cycles   = 15;
>   		if (recovery_cycles>  15) recovery_cycles = 0;  /* 0==16 */
> -		
> -#ifdef DEBUG
> -		printk("ht6560b: drive %s setting pio=%d recovery=%d (%dns)
> active=%d (%dns)\n", drive->name, pio, recovery_cycles, recovery_time,
> active_cycles, active_time);

    Here too...

> @@ -272,10 +208,6 @@ static void ht_set_prefetch(ide_drive_t
>   	ide_set_drivedata(drive, (void *)config);
>
>   	spin_unlock_irqrestore(&ht6560b_lock, flags);
> -
> -#ifdef DEBUG
> -	printk("ht6560b: drive %s prefetch mode %sabled\n", drive->name, (state ?
> "en" : "dis"));

    And here.

> @@ -299,10 +231,6 @@ static void ht6560b_set_pio_mode(ide_hwi
>   	config |= timing;
>   	ide_set_drivedata(drive, (void *)config);
>   	spin_unlock_irqrestore(&ht6560b_lock, flags);
> -
> -#ifdef DEBUG
> -	printk("ht6560b: drive %s tuned to pio mode %#x timing=%#x\n", drive-
>> name, pio, timing);

    Here too...

> Index: b/drivers/ide/umc8672.c
> ===================================================================
> --- a/drivers/ide/umc8672.c
> +++ b/drivers/ide/umc8672.c
[...]
> @@ -18,23 +17,6 @@
>    *			add detection of possible race condition  -ml
>    */
>
> -/*
> - * VLB Controller Support from
> - * Wolfram Podien
> - * Rohoefe 3
> - * D28832 Achim
> - * Germany
> - *
> - * To enable UMC8672 support there must a lilo line like
> - * append="ide0=umc8672"...
> - * To set the speed according to the abilities of the hardware there must be
> a
> - * line like
> - * #define UMC_DRIVE0 11
> - * in the beginning of the driver, which sets the speed of drive 0 to 11
> (there

    And above...

WBR, Sergei
