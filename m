Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab2ADWF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 17:05:28 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:39448 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101Ab2ADWFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 17:05:25 -0500
Date: Wed, 4 Jan 2012 23:05:22 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Debian GNU/Linux m68k <debian-68k@lists.debian.org>
Subject: [RFC] m68k: Update defconfigs
Message-ID: <alpine.DEB.2.00.1201042252450.15625@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi all,

I've updated the defconfigs in a new "defconfig" branch (soon at
http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git;a=commitdiff;h=defconfig).
Several of these are based on Finn's updates for mac_defconfig.

I try to keep the defconfigs for the different platforms as similar as
possible. multi_defconfig is the union of all others (except for Sun-3).

Findings:
  - CONFIG_BLK_DEV_SWIM is m, while CONFIG_AMIGA_FLOPPY and
    CONFIG_ATARI_FLOPPY are y.
  - Amiga and Atari use CONFIG_RTC_CLASS, the others don't.
    Should we switch everything to CONFIG_RTC_CLASS (and thus drop
    CONFIG_GEN_RTC)? We do have CONFIG_RTC_DRV_GENERIC now.
  - The minimal defconfigs are still much larger than I'd prefer.

Here is the list of relevant differenes in all expanded defconfigs
(unselectable options are considered the same as unselected options):

    multi_defconfig/.config -------------------------------------+
    sun3x_defconfig/.config -----------------------------------+ |
    sun3_defconfig/.config ----------------------------------+ | |
    q40_defconfig/.config ---------------------------------+ | | |
    mvme16x_defconfig/.config ---------------------------+ | | | |
    mvme147_defconfig/.config -------------------------+ | | | | |
    mac_defconfig/.config ---------------------------+ | | | | | |
    hp300_defconfig/.config -----------------------+ | | | | | | |
    bvme6000_defconfig/.config ------------------+ | | | | | | | |
    atari_defconfig/.config -------------------+ | | | | | | | | |
    apollo_defconfig/.config ----------------+ | | | | | | | | | |
    amiga_defconfig/.config ---------------+ | | | | | | | | | | |
					   | | | | | | | | | | | |
    CONFIG_53C700_BE_BUS                 : y . . y . . . y . . . y
    CONFIG_A2065                         : y . . . . . . . . . . y
    CONFIG_A2091_SCSI                    : y . . . . . . . . . . y
    CONFIG_A3000_SCSI                    : y . . . . . . . . . . y
    CONFIG_ADB                           : . . . . . y . . . . . y
    CONFIG_ADB_CUDA                      : . . . . . y . . . . . y
    CONFIG_ADB_IOP                       : . . . . . y . . . . . y
    CONFIG_ADB_MACII                     : . . . . . y . . . . . y
    CONFIG_ADB_MACIISI                   : . . . . . y . . . . . y
    CONFIG_ADB_PMU68K                    : . . . . . y . . . . . y
    CONFIG_AMIGA                         : y n n n n n n n n n n y
    CONFIG_AMIGA_BUILTIN_SERIAL          : y . . . . . . . . . . y
    CONFIG_AMIGA_FLOPPY                  : y . . . . . . . . . . y
    CONFIG_AMIGA_PCMCIA                  : y . . . . . . . . . . y
    CONFIG_AMIGA_Z2RAM                   : y . . . . . . . . . . y
    CONFIG_APNE                          : y . . . . . . . . . . y
    CONFIG_APOLLO                        : n y n n n n n n n n n y
    CONFIG_ARCH_DISCONTIGMEM_ENABLE      : y y y y y y y y y n y y
    CONFIG_ARIADNE                       : y . . . . . . . . . . y
    CONFIG_ATARI                         : n n y n n n n n n n n y
    CONFIG_ATARILANCE                    : . . y . . . . . . . . y
    CONFIG_ATARI_DSP56K                  : . . m . . . . . . . . m
    CONFIG_ATARI_ETHERNAT                : . . m . . . . . . . . m
    CONFIG_ATARI_ETHERNEC                : . . y . . . . . . . . y
    CONFIG_ATARI_FLOPPY                  : . . y . . . . . . . . y
    CONFIG_ATARI_KBD_CORE                : . . y . . . . . . . . y
    CONFIG_ATARI_ROM_ISA                 : . . y . . . . . . . . y
    CONFIG_ATARI_SCSI                    : . . y . . . . . . . . y
    CONFIG_BCMA_POSSIBLE                 : y y y y y y y y y . y y
    CONFIG_BLK_DEV_BUDDHA                : y . . . . . . . . . . y
    CONFIG_BLK_DEV_FALCON_IDE            : . . y . . . . . . . . y
    CONFIG_BLK_DEV_GAYLE                 : y . . . . . . . . . . y
    CONFIG_BLK_DEV_IDECD                 : y . y . . y . . y . . y
    CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS  : y . y . . y . . y . . y
    CONFIG_BLK_DEV_MAC_IDE               : . . . . . y . . . . . y
    CONFIG_BLK_DEV_Q40IDE                : . . . . . . . . y . . y
    CONFIG_BLK_DEV_SWIM                  : . . . . . m . . . . . m
    CONFIG_BVME6000                      : . . . y . . n n . . . y
    CONFIG_BVME6000_NET                  : . . . y . . . . . . . y
    CONFIG_BVME6000_SCSI                 : . . . y . . . . . . . y
    CONFIG_DEV_APPLETALK                 : n n n n n m n n n n n m
    CONFIG_DIO                           : . . . . y . . . . . . y
    CONFIG_DISCONTIGMEM                  : y y y y y y y y y . y y
    CONFIG_DISCONTIGMEM_MANUAL           : y y y y y y y y y . y y
    CONFIG_DMASOUND                      : m . m . . . . . m . . m
    CONFIG_DMASOUND_ATARI                : . . m . . . . . . . . m
    CONFIG_DMASOUND_PAULA                : m . . . . . . . . . . m
    CONFIG_DMASOUND_Q40                  : . . . . . . . . m . . m
    CONFIG_EARLY_PRINTK                  : . . . . . y . y . . . y
    CONFIG_FB                            : y y y n y y n n y y y y
    CONFIG_FB_AMIGA                      : y . . . . . . . . . . y
    CONFIG_FB_AMIGA_AGA                  : y . . . . . . . . . . y
    CONFIG_FB_AMIGA_ECS                  : y . . . . . . . . . . y
    CONFIG_FB_AMIGA_OCS                  : y . . . . . . . . . . y
    CONFIG_FB_APOLLO                     : . y . . . . . . . . . y
    CONFIG_FB_ATARI                      : . . y . . . . . . . . y
    CONFIG_FB_CFB_COPYAREA               : y n y . n y . . y n n y
    CONFIG_FB_CFB_FILLRECT               : y y y . n y . . y n n y
    CONFIG_FB_CFB_IMAGEBLIT              : y y y . y y . . y n n y
    CONFIG_FB_CIRRUS                     : y . . . . . . . . . . y
    CONFIG_FB_FM2                        : y . . . . . . . . . . y
    CONFIG_FB_HP300                      : . . . . y . . . . . . y
    CONFIG_FB_MAC                        : . . . . . y . . . . . y
    CONFIG_FB_MACMODES                   : n n n . n y . . n n n y
    CONFIG_FB_Q40                        : . . . . . . . . y . . y
    CONFIG_FB_VALKYRIE                   : . . . . . y . . . . . y
    CONFIG_FLATMEM                       : . . . . . . . . . y . .
    CONFIG_FLATMEM_MANUAL                : . . . . . . . . . y . .
    CONFIG_FONT_6x11                     : . . . . . y . . . . . y
    CONFIG_FONT_8x16                     : y y y . y y . . y y y y
    CONFIG_FONT_8x8                      : y y y . y y . . y y y y
    CONFIG_FONT_PEARL_8x8                : y . . . . . . . . . . y
    CONFIG_FRAMEBUFFER_CONSOLE           : y y y . y y . . y y y y
    CONFIG_GENERIC_ISA_DMA               : y n n n n n n n y n n y
    CONFIG_GEN_RTC                       : . m . m m m m m m m m .
    CONFIG_GEN_RTC_X                     : . y . y y y y y y y y .
    CONFIG_GVP11_SCSI                    : y . . . . . . . . . . y
    CONFIG_HAS_DMA                       : y y y y y y y y y . y y
    CONFIG_HEARTBEAT                     : y y y . y . . . y . . y
    CONFIG_HIL_MLC                       : . . . . y . . . . . . y
    CONFIG_HP300                         : n n n n y n n n n n n y
    CONFIG_HPLANCE                       : . . . . y . . . . . . y
    CONFIG_HP_SDC                        : . . . . y . . . . . . y
    CONFIG_HP_SDC_RTC                    : . . . . m . . . . . . m
    CONFIG_HYDRA                         : y . . . . . . . . . . y
    CONFIG_IDE                           : y n y n n y n n y n n y
    CONFIG_IDE_ATAPI                     : y . y . . y . . y . . y
    CONFIG_IDE_GD                        : y . y . . y . . y . . y
    CONFIG_IDE_GD_ATA                    : y . y . . y . . y . . y
    CONFIG_IDE_GD_ATAPI                  : y . y . . y . . y . . y
    CONFIG_IDE_PROC_FS                   : y . y . . y . . y . . y
    CONFIG_INPUT_ADBHID                  : . . . . . y . . . . . y
    CONFIG_INPUT_JOYSTICK                : y n n n n n n n n n n y
    CONFIG_INPUT_M68K_BEEP               : m . m . n m . . m . . m
    CONFIG_INPUT_MISC                    : y n y n y y n n y n n y
    CONFIG_IPDDP                         : . . . . . m . . . . . m
    CONFIG_IPDDP_DECAP                   : . . . . . y . . . . . y
    CONFIG_IPDDP_ENCAP                   : . . . . . y . . . . . y
    CONFIG_ISA                           : y . . . . . . . y . . y
    CONFIG_JOYSTICK_AMIGA                : m . . . . . . . . . . m
    CONFIG_KEYBOARD_AMIGA                : y . . . . . . . . . . y
    CONFIG_KEYBOARD_ATARI                : . . y . . . . . . . . y
    CONFIG_KEYBOARD_HIL                  : . . . . y . . . . . . y
    CONFIG_KEYBOARD_HIL_OLD              : . . . . y . . . . . . y
    CONFIG_KEYBOARD_SUNKBD               : n n n n n n n n n y y y
    CONFIG_LOCALVERSION                  : "-amiga" "-apollo" "-atari" "-bvme6000" "-hp300" "-mac" "-mvme147" "-mvme16x" "-q40" "-sun3" "-sun3x" "-multi"
    CONFIG_LOGO                          : y y y . y y . . y y y y
    CONFIG_LOGO_LINUX_CLUT224            : y n y . y y . . y y y y
    CONFIG_LOGO_LINUX_MONO               : y y y . n y . . y y y y
    CONFIG_LOGO_LINUX_VGA16              : y n y . n y . . y y y y
    CONFIG_LOGO_MAC_CLUT224              : . . . . . y . . . . . y
    CONFIG_M68020                        : y y y n y y n n n y n y
    CONFIG_M68030                        : y y y n y y y n n . y y
    CONFIG_M68040                        : y y y y y y n y y . n y
    CONFIG_M68060                        : y y y y y n n y y . n y
    CONFIG_M68KFPU_EMU                   : n n n n n y n n n n n y
    CONFIG_M68K_L2_CACHE                 : . . . . . y . . . . . y
    CONFIG_MAC                           : n n n n n y n n n n n y
    CONFIG_MAC8390                       : . . . . . y . . . . . y
    CONFIG_MAC89x0                       : . . . . . y . . . . . y
    CONFIG_MACINTOSH_DRIVERS             : . . . . . y . . . . . y
    CONFIG_MACMACE                       : . . . . . y . . . . . y
    CONFIG_MACSONIC                      : . . . . . y . . . . . y
    CONFIG_MAC_EMUMOUSEBTN               : . . . . . y . . . . . y
    CONFIG_MAC_SCSI                      : . . . . . y . . . . . y
    CONFIG_MII                           : n n m n n n n n n n n m
    CONFIG_MMU_MOTOROLA                  : y y y y y y y y y . y y
    CONFIG_MMU_SUN3                      : . . . . . . . . . y . .
    CONFIG_MOUSE_AMIGA                   : m . . . . . . . . . . m
    CONFIG_MOUSE_ATARI                   : . . m . . . . . . . . m
    CONFIG_MOUSE_SERIAL                  : n m n m m m m m m m m m
    CONFIG_MVME147                       : . . . n . . y n . . . y
    CONFIG_MVME147_NET                   : . . . . . . y . . . . y
    CONFIG_MVME147_SCSI                  : . . . . . . y . . . . y
    CONFIG_MVME16x                       : . . . n . . n y . . . y
    CONFIG_MVME16x_NET                   : . . . . . . . y . . . y
    CONFIG_MVME16x_SCSI                  : . . . . . . . y . . . y
    CONFIG_NATFEAT                       : . . y . . . . . . . . y
    CONFIG_NE2000                        : n . . . . . . . m . . m
    CONFIG_NET_VENDOR_8390               : y . y . . y . . y . . y
    CONFIG_NET_VENDOR_AMD                : y . y . y . y . n y y y
    CONFIG_NET_VENDOR_APPLE              : . . . . . y . . . . . y
    CONFIG_NET_VENDOR_CIRRUS             : n . . . . y . . n . . y
    CONFIG_NET_VENDOR_I825XX             : . . . y . . . y . y . y
    CONFIG_NET_VENDOR_INTEL              : n n n y n n n y n y n y
    CONFIG_NET_VENDOR_NATSEMI            : y n y n n y n n y n n y
    CONFIG_NET_VENDOR_SMSC               : n . y . . n . . n . . y
    CONFIG_NFBLOCK                       : . . y . . . . . . . . y
    CONFIG_NFCON                         : . . y . . . . . . . . y
    CONFIG_NFETH                         : . . y . . . . . . . . y
    CONFIG_NODES_SHIFT                   : 3 3 3 3 3 3 3 3 3 . 3 3
    CONFIG_NO_DMA                        : n n n n n n n n n y n n
    CONFIG_NUBUS                         : . . . . . y . . . . . y
    CONFIG_NVRAM                         : . . y . . . . . . . . y
    CONFIG_PARPORT                       : m n m n n n n n n n n m
    CONFIG_PARPORT_1284                  : y . y . . . . . . . . y
    CONFIG_PARPORT_AMIGA                 : m . . . . . . . . . . m
    CONFIG_PARPORT_ATARI                 : . . m . . . . . . . . m
    CONFIG_PARPORT_MFC3                  : m . . . . . . . . . . m
    CONFIG_PARPORT_NOT_PC                : y . y . . . . . . . . y
    CONFIG_PPS_CLIENT_PARPORT            : m . m . . . . . . . . m
    CONFIG_PRINTER                       : m . m . . . . . . . . m
    CONFIG_Q40                           : n n n n n n n n y n n y
    CONFIG_RTC_CLASS                     : y n y n n n n n n n n y
    CONFIG_RTC_DRV_CMOS                  : . . n . . . . . . . . m
    CONFIG_RTC_DRV_GENERIC               : n . y . . . . . . . . m
    CONFIG_RTC_DRV_MSM6242               : m . n . . . . . . . . m
    CONFIG_RTC_DRV_RP5C01                : m . n . . . . . . . . m
    CONFIG_RTC_HCTOSYS                   : y . y . . . . . . . . y
    CONFIG_RTC_HCTOSYS_DEVICE            : "rtc0" . "rtc0" . . . . . . . . "rtc0"
    CONFIG_RTC_INTF_DEV                  : y . y . . . . . . . . y
    CONFIG_RTC_INTF_PROC                 : y . y . . . . . . . . y
    CONFIG_RTC_INTF_SYSFS                : y . y . . . . . . . . y
    CONFIG_RTC_LIB                       : y . y . . . . . . . . y
    CONFIG_SCSI_A4000T                   : y . . . . . . . . . . y
    CONFIG_SCSI_DMA                      : y y y y y y y y y n y y
    CONFIG_SCSI_MAC_ESP                  : . . . . . y . . . . . y
    CONFIG_SCSI_SPI_ATTRS                : y n y y n y y y n y y y
    CONFIG_SCSI_ZORRO7XX                 : y . . . . . . . . . . y
    CONFIG_SERIAL_CONSOLE                : y . . . . . . . . . . y
    CONFIG_SERIAL_CORE                   : . . . . . y . . . . . y
    CONFIG_SERIAL_CORE_CONSOLE           : . . . . . y . . . . . y
    CONFIG_SERIAL_PMACZILOG              : . . . . . y . . . . . y
    CONFIG_SERIAL_PMACZILOG_CONSOLE      : . . . . . y . . . . . y
    CONFIG_SERIAL_PMACZILOG_TTYS         : . . . . . y . . . . . y
    CONFIG_SERIO                         : n m n m y m m m y y y y
    CONFIG_SERIO_Q40KBD                  : . . . . . . . . y . . y
    CONFIG_SINGLE_MEMORY_CHUNK           : . . . . . . . . . y . .
    CONFIG_SOUND                         : m n m n n n n n m n n m
    CONFIG_SOUND_OSS_CORE                : y . y . . . . . y . . y
    CONFIG_SOUND_OSS_CORE_PRECLAIM       : y . y . . . . . y . . y
    CONFIG_SSB_POSSIBLE                  : y y y y y y y y y . y y
    CONFIG_SUN3                          : . . . . . . . . . y . .
    CONFIG_SUN3LANCE                     : . . . . . . . . . y y y
    CONFIG_SUN3X                         : n n n n n n n n n n y y
    CONFIG_SUN3X_ESP                     : . . . . . . . . . . y y
    CONFIG_SUN3_82586                    : . . . . . . . . . y . .
    CONFIG_SUN3_SCSI                     : . . . . . . . . . y . .
    CONFIG_VME                           : n n n y n n y y n n n y
    CONFIG_ZORRO                         : y . . . . . . . . . . y
    CONFIG_ZORRO8390                     : y . . . . . . . . . . y
    CONFIG_ZORRO_NAMES                   : y . . . . . . . . . . y

Since this is the first update since the introduction of minimal configs
("make savedefconfig") more than a year ago, the changes are big.
I'll try to do a better job in the future, with more frequent updates.

Thanks for your feedback!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
