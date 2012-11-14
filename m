Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab2KNIsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:48:13 -0500
Received: from zmail.sgconsulting.it ([174.143.207.116]:33572 "EHLO
	zmail.sgconsulting.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab2KNIsK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:48:10 -0500
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Nov 2012 03:48:09 EST
Date: Wed, 14 Nov 2012 08:40:46 +0000 (UTC)
From: Forconi <forconi@wavecomm.it>
To: linux-kernel@vger.kernel.org
Message-ID: <2055189652.1317458.1352882446411.JavaMail.root@zmail.sgconsulting.it>
In-Reply-To: <1877610299.1316440.1352881150817.JavaMail.root@zmail.sgconsulting.it>
Subject: KMS Framebuffer on Intel N2600 (GMA3600)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [213.243.236.19]
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - GC23 (Win)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm trying to get Linux + KMS Framebuffer up and running on a board that has this hardware configuration:

 - CPU: Intel Atom N2600
 - Chipset: Intel NM10
 - Integrated graphics system: Intel GMA 3600
 - LCD Panel with LVDS controller (LCD resolution is 800x480, 18 bpp, 60Hz)

I have downloaded the latest 3.6.6 linux kernel and configured for my board.

The configuration for the framebuffer section is like this:

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=y
# CONFIG_DRM_GMA600 is not set
CONFIG_DRM_GMA3600=y
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_WMT_GE_ROPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LP855X is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y


To boot my new kernel I use these parameters: video=LVDS-1:800x480-18@60D drm.debug=0x06

The kernel boots correctly but the LCD screen is completely black (with backlight off).
Using SSH I can login to my system and have a look at dmesg:

[    4.951945] [drm] Initialized drm 1.1.0 20060810
[    5.369917] gma500 0000:00:02.0: setting latency timer to 64
[    5.370123] [drm:psb_intel_opregion_setup], Public ACPI methods supported
[    5.370128] [drm:psb_intel_opregion_setup], ASLE supported
[    5.370177] gma500 0000:00:02.0: irq 45 for MSI/MSI-X
[    5.370200] [drm:psb_intel_init_bios], Using VBT from OpRegion: $VBT CEDARVIEW      d
[    5.370210] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
[    5.370221] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[    5.370301] gma500 0000:00:02.0: GPU: power management timed out.
[    5.377826] acpi device:26: registered as cooling_device5
[    5.378195] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    5.378363] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    5.378576] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    5.378583] [drm] No driver support for vblank timestamp query.
[    5.384094] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm LVDSDDC_C
[    5.425206] [drm:cdv_intel_single_pipe_active], pipe enabled 0
[    5.445193] gma500 0000:00:02.0: trying to get vblank count for disabled pipe 1
[    5.445270] gma500 0000:00:02.0: trying to get vblank count for disabled pipe 1
[    5.485585] [drm:cdv_intel_single_pipe_active], pipe enabled 0
[    5.505572] [drm] forcing LVDS-1 connector ON
[    5.505577] [drm:drm_fb_helper_parse_command_line], cmdline mode for connector LVDS-1 800x480@60Hz
[    5.505587] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1]
[    5.529444] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1] disconnected
[    5.529452] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:LVDS-1]
[    5.533924] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm LVDSBLC_B
[    5.533935] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:LVDS-1] probed modes :
[    5.533940] [drm:drm_mode_debug_printmodeline], Modeline 16:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
[    5.533950] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:DVI-D-1]
[    5.538423] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm HDMIB
[    5.538432] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:DVI-D-1] disconnected
[    5.538439] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DVI-D-2]
[    5.542905] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm HDMIC
[    5.542911] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DVI-D-2] disconnected
[    5.542916] [drm:drm_setup_crtcs],
[    5.542921] [drm:drm_enable_connectors], connector 7 enabled? no
[    5.542926] [drm:drm_enable_connectors], connector 9 enabled? yes
[    5.542930] [drm:drm_enable_connectors], connector 12 enabled? no
[    5.542935] [drm:drm_enable_connectors], connector 14 enabled? no
[    5.542940] [drm:drm_target_preferred], looking for cmdline mode on connector 9
[    5.542948] [drm:drm_target_preferred], found mode 800x480
[    5.542952] [drm:drm_setup_crtcs], picking CRTCs for 2048x2048 config
[    5.542959] [drm:drm_setup_crtcs], desired mode 800x480 set on crtc 4
[    5.544998] fbcon: psbfb (fb0) is primary device
[    5.545782] [drm:drm_crtc_helper_set_config],
[    5.545785] [drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[    5.545795] [drm:drm_crtc_helper_set_config],
[    5.545799] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:19] #connectors=1 (x y) (0 0)
[    5.545812] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    5.545815] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[    5.545821] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    5.545828] [drm:drm_mode_debug_printmodeline], Modeline 18:"800x480" 0 29605 800 816 896 992 480 481 484 497 0x0 0x6
[    5.545830] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[    5.545833] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[    5.545837] [drm:drm_crtc_helper_set_config], [CONNECTOR:9:LVDS-1] to [CRTC:4]
[    5.545840] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[    5.545846] [drm:drm_mode_debug_printmodeline], Modeline 18:"800x480" 0 29605 800 816 896 992 480 481 484 497 0x0 0x6
[    5.545852] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[    5.545861] [drm:cdv_intel_crtc_mode_set], Use SSC reference clock 100 Mhz
[    5.545868] [drm:drm_mode_debug_printmodeline], Modeline 20:"800x480" 0 65000 1024 1048 1184 1344 768 771 777 806 0x0 0x6
[    5.547424] [drm:cdv_sb_write], 0x00008038: 0x04000001 (before)
[    5.547427] [drm:cdv_sb_write], 0x00008038: 0x0068a701
[    5.551414] [drm:cdv_sb_write], 0x00008038: 0x0068a701 (after)
[    5.553409] [drm:cdv_dpll_set_clock_cdv], use their DPLL for pipe A/B
[    5.555407] [drm:cdv_sb_write], 0x00008030: 0x7e40221c (before)
[    5.555410] [drm:cdv_sb_write], 0x00008030: 0x7e40221c
[    5.559403] [drm:cdv_sb_write], 0x00008030: 0x7e40221c (after)
[    5.563392] [drm:cdv_sb_write], 0x00008028: 0x1700217f (before)
[    5.563395] [drm:cdv_sb_write], 0x00008028: 0x5900217f
[    5.567385] [drm:cdv_sb_write], 0x00008028: 0x5900217f (after)
[    5.571379] [drm:cdv_sb_write], 0x00008034: 0x80980057 (before)
[    5.571382] [drm:cdv_sb_write], 0x00008034: 0x16000157
[    5.575373] [drm:cdv_sb_write], 0x00008034: 0x16000157 (after)
[    5.579367] [drm:cdv_sb_write], 0x0000803c: 0x01550000 (before)
[    5.579370] [drm:cdv_sb_write], 0x0000803c: 0x81552000
[    5.583361] [drm:cdv_sb_write], 0x0000803c: 0x81552000 (after)
[    5.587354] [drm:cdv_sb_write], 0x00000120: 0x000000c4 (before)
[    5.587357] [drm:cdv_sb_write], 0x00000120: 0x003000c4
[    5.591349] [drm:cdv_sb_write], 0x00000120: 0x003000c4 (after)
[    5.595342] [drm:cdv_sb_write], 0x00000220: 0x000000c4 (before)
[    5.595345] [drm:cdv_sb_write], 0x00000220: 0x003000c4
[    5.599335] [drm:cdv_sb_write], 0x00000220: 0x003000c4 (after)
[    5.603329] [drm:cdv_sb_write], 0x00002320: 0x003000c4 (before)
[    5.603332] [drm:cdv_sb_write], 0x00002320: 0x003000c4
[    5.607327] [drm:cdv_sb_write], 0x00002320: 0x003000c4 (after)
[    5.611321] [drm:cdv_sb_write], 0x00002420: 0x003000c4 (before)
[    5.611324] [drm:cdv_sb_write], 0x00002420: 0x003000c4
[    5.615313] [drm:cdv_sb_write], 0x00002420: 0x003000c4 (after)
[    5.615467] [drm:cdv_intel_crtc_mode_set], Mode for pipe B:
[    5.615474] [drm:drm_mode_debug_printmodeline], Modeline 18:"800x480" 0 29605 800 816 896 992 480 481 484 497 0x0 0x6
[    5.655581] [drm:drm_crtc_helper_set_mode], [ENCODER:10:LVDS-10] set [MODE:18:800x480]
[    5.655736] [drm:cdv_intel_single_pipe_active], pipe enabled 2
[    5.695762] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[    5.695766] [drm:drm_crtc_helper_set_config],        [CONNECTOR:9:LVDS-1] set DPMS on
[    5.745031] Console: switching to colour frame buffer device 100x30
[    5.749488] fb0: psbfb frame buffer device
[    5.749492] drm: registered panic notifier
[    5.749614] [drm:cdv_get_max_backlight], LVDS Panel PWM value is 0!
[    5.749622] [drm:cdv_get_max_backlight], LVDS Panel PWM value is 0!
[    5.749633] [drm] Initialized gma500 1.0.0 2011-06-06 for 0000:00:02.0 on minor 0


I can't understand if I have done some mistakes in the kernel configuration (enabled some conflicting features)
or if there is still some other settings to configure to make Linux KMS + Framebuffer run correctly.



Thank you for any help/suggestions.

Best regards,
Samuele Forconi.



-- 
Ing. Samuele Forconi
Responsabile Sviluppo SW
WaveComm S.r.l.
Sede legale: Via Donizetti 25, 53011 Castellina in Chianti (SI)
Sede operativa: Loc. Belvedere - Ingresso 2, 53034 Colle Val d'Elsa (SI)
Phone: (39) 0577 043101
Fax: (39) 0577 043101
Mobile: (39) 347 5899717
Skype: samueleforconi
E-mail: forconi@wavecomm.it
URL: www.wavecomm.it

_____________________________________________________________________________________________

Ai sensi del D. Lgs. n.196 del 30/06/2003, questo messaggio ed ogni suo allegato sono confidenziali e ad uso esclusivo del destinatario, il quale è l'unico autorizzato ad usarlo, copiarlo e, sotto la propria responsabilità, diffonderlo. Se il ricevente non è il destinatario diretto del presente messaggio, è pregato di contattare l'originario mittente e di cancellare questo messaggio ed ogni suo allegato dal sistema di posta. Se il ricevente non è il destinatario diretto del presente messaggio, sono vietati l'uso, la riproduzione, e la stampa di questo messaggio e di ogni suo allegato, nonché la diffusione del loro contenuto a qualsiasi altro soggetto.

For the D. Lgs. n.196 of 30/06/2003, this message and any attachment are confidential and privileged for the the recipient identified above, who only may use, copy and, under his/her responsibility, further disseminate it. If you are not the intended recipient, please contact the sender and delete this message and any attachment from your system. If you are not the intended recipient you must not use, copy or print this message or attachment or disclose the contents to any other person.
