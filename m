Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab0LRUyt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 15:54:49 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:19172 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932108Ab0LRUys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 15:54:48 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAPutDE1FpYat/2dsb2JhbACfVYRfdKwMhkkuiFyDDII+BIRlhhyHdg
X-IronPort-AV: E=Sophos;i="4.60,194,1291611600"; 
   d="txt'?scan'208";a="85830144"
Message-ID: <4D0D1FBA.1020605@gmail.com>
Date: Sat, 18 Dec 2010 15:55:22 -0500
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101028 Iceape/2.0.10
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: Hui Zhu <teawater@gmail.com>, linux-kernel@vger.kernel.org,
        keithp@keithp.com, ak@linux.intel.com, gregkh@suse.de,
        stable@kernel.org, Andi Kleen <andi@firstfloor.org>,
        maciej.rutecki@gmail.com
Subject: Re: [BUG] i915 boot got black screen with 2.6.37-rc5+
References: <AANLkTimOOmFqxU=r+-RphdfPJ54Qr+6LHU60Grzpnerr@mail.gmail.com> <b9dded$hcr3k7@orsmga002.jf.intel.com>
In-Reply-To: <b9dded$hcr3k7@orsmga002.jf.intel.com>
Content-Type: multipart/mixed;
 boundary="------------050509010204030606030104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050509010204030606030104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Chris Wilson wrote:
> Which chipset and what connectors? Judging by the offending commits, my
> guess is an Arrandale with eDP, in which case
> https://bugs.freedesktop.org/show_bug.cgi?id=31988 will be of interest.
> -Chris
>
>    
Chris, after seeing this message I have tested -rc6 on G33 as well and 
can confirm that it is broken.
I can see only "unpacking" message - very very brief - and then 
absolutely black screen.

I have prepared a custom initrd to ddump the dmesg to a hard disk and 
here are results - "No connectors reported connected with modes".

I attach a run with -rc5 (good) and -rc6 (bad) dmesg dump...

Would it give you enough to work on?

Thanks, Woody


--------------050509010204030606030104
Content-Type: text/plain;
 name="i915_g33_2.6.37-rc6.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="i915_g33_2.6.37-rc6.txt"

On 2.6.37-rc5:
[    0.403761] agpgart-intel 0000:00:00.0: Intel G33 Chipset
[    0.403814] agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
[    0.404604] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    0.408413] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.408566] [drm] Initialized drm 1.1.0 20060810
[    0.408645] [drm] radeon defaulting to kernel modesetting.
[    0.408646] [drm] radeon kernel modesetting enabled.
[    0.408713] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.408716] i915 0000:00:02.0: setting latency timer to 64
[    0.421882] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    0.421968] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    0.421982] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[    0.421985] [drm:parse_device_mapping], no child dev is parsed from VBT 
[    0.421996] [drm:intel_dsm_pci_probe], no _DSM method for intel device
[    0.422007] [drm:intel_modeset_init], 2 display pipes available.
[    0.422060] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.422371] [drm] initialized overlay support
[    0.427497] [drm:intel_update_fbc], 
[    0.427498] [drm:intel_update_watermarks], plane B (pipe 1) clock: 0
[    0.427501] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    0.427503] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    0.427504] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[    0.427506] [drm:intel_calculate_wm], FIFO watermark level: 26
[    0.427508] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[    0.427509] [drm:intel_calculate_wm], FIFO watermark level: 29
[    0.427511] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[    0.427513] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[    0.427516] [drm:intel_update_fbc], 
[    0.427518] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[    0.440061] [drm:intel_crt_detect], CRT detected via hotplug
[    0.490784] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] probed modes :
[    0.490786] [drm:drm_mode_debug_printmodeline], Modeline 8:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    0.490790] [drm:drm_mode_debug_printmodeline], Modeline 17:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    0.490793] [drm:drm_mode_debug_printmodeline], Modeline 10:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[    0.490796] [drm:drm_mode_debug_printmodeline], Modeline 18:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[    0.490800] [drm:drm_mode_debug_printmodeline], Modeline 19:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[    0.490803] [drm:drm_mode_debug_printmodeline], Modeline 20:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    0.490806] [drm:drm_mode_debug_printmodeline], Modeline 9:"832x624" 75 53207 832 872 960 1088 624 625 628 652 0x0 0x6
[    0.490809] [drm:drm_mode_debug_printmodeline], Modeline 22:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[    0.490812] [drm:drm_mode_debug_printmodeline], Modeline 21:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[    0.490815] [drm:drm_mode_debug_printmodeline], Modeline 11:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    0.490818] [drm:drm_mode_debug_printmodeline], Modeline 12:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[    0.490821] [drm:drm_mode_debug_printmodeline], Modeline 14:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[    0.490825] [drm:drm_mode_debug_printmodeline], Modeline 13:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[    0.490828] [drm:drm_mode_debug_printmodeline], Modeline 15:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    0.490831] [drm:drm_mode_debug_printmodeline], Modeline 16:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[    0.490834] [drm:drm_setup_crtcs], 
[    0.490836] [drm:drm_enable_connectors], connector 5 enabled? yes
[    0.490837] [drm:drm_target_preferred], looking for cmdline mode on connector 5
[    0.490839] [drm:drm_target_preferred], looking for preferred mode on connector 5
[    0.490841] [drm:drm_target_preferred], found mode 1280x1024
[    0.490842] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
[    0.490844] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 3
[    0.494707] [drm:intelfb_create], allocated 1280x1024 fb: 0x007f0000, bo f5f3d780
[    0.494838] fbcon: inteldrmfb (fb0) is primary device
[    0.495266] [drm:drm_crtc_helper_set_config], 
[    0.495268] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[    0.495271] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    0.495272] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[    0.495274] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    0.495276] [drm:drm_mode_debug_printmodeline], Modeline 23:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    0.495280] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[    0.495281] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[    0.495283] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:VGA-1] to [CRTC:3]
[    0.495284] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[    0.495286] [drm:drm_mode_debug_printmodeline], Modeline 23:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    0.495289] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[    0.495414] [drm:intel_crtc_mode_set], Mode for pipe A:
[    0.495415] [drm:drm_mode_debug_printmodeline], Modeline 23:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    0.500094] [drm:intel_pipe_set_base_atomic], Writing base 007F0000 00000000 0 0 5120
[    0.500098] [drm:intel_update_fbc], 
[    0.500101] [drm:drm_crtc_helper_set_mode], [ENCODER:6:DAC-6] set [MODE:23:1280x1024]
[    0.500104] [drm:intel_update_watermarks], plane A (pipe 0) clock: 108000
[    0.500106] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    0.500109] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    0.500111] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[    0.500113] [drm:intel_calculate_wm], FIFO watermark level: -8
[    0.500115] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[    0.500117] [drm:intel_calculate_wm], FIFO watermark level: 29
[    0.500119] [drm:i9xx_update_wm], FIFO watermarks - A: 1, B: 29
[    0.500121] [drm:i9xx_update_wm], self-refresh entries: 80
[    0.500123] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 1, B: 29, C: 2, SR 15
[    0.500280] [drm:intel_update_fbc], 
[    0.500282] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[    0.500283] [drm:drm_crtc_helper_set_config],        [CONNECTOR:5:VGA-1] set DPMS on
[    0.500285] [drm:drm_crtc_helper_set_config], 
[    0.500286] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:24] #connectors=0 (x y) (0 0)
[    0.500288] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    0.500290] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:VGA-1] to [CRTC:3]
[    0.500291] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[    0.500303] [drm:drm_crtc_helper_set_config], 
[    0.500305] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[    0.500307] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:VGA-1] to [CRTC:3]
[    0.500309] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[    0.500310] [drm:drm_crtc_helper_set_config],        [CONNECTOR:5:VGA-1] set DPMS on
[    0.503302] [drm:drm_crtc_helper_set_config], 
[    0.503304] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[    0.503306] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:VGA-1] to [CRTC:3]
[    0.503308] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[    0.503309] [drm:drm_crtc_helper_set_config],        [CONNECTOR:5:VGA-1] set DPMS on
[    0.506298] Console: switching to colour frame buffer device 160x64
[    0.506302] [drm:drm_crtc_helper_set_config], 
[    0.506303] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[    0.506305] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:VGA-1] to [CRTC:3]
[    0.506307] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[    0.506308] [drm:drm_crtc_helper_set_config],        [CONNECTOR:5:VGA-1] set DPMS on
[    0.509314] fb0: inteldrmfb frame buffer device
[    0.509315] drm: registered panic notifier
[    0.509322] No ACPI video bus found
[    0.509368] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0


On 2.6.37-rc6 - using blind dump from initrd - black screen:
[    0.290045] agpgart-intel 0000:00:00.0: Intel G33 Chipset
[    0.290162] agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
[    0.291040] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    0.295080] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.295303] [drm] Initialized drm 1.1.0 20060810
[    0.295444] [drm] radeon defaulting to kernel modesetting.
[    0.295510] [drm] radeon kernel modesetting enabled.
[    0.295639] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.295709] i915 0000:00:02.0: setting latency timer to 64
[    0.308590] [drm:intel_opregion_setup], graphic opregion physical addr: 0x7d5be0e4
[    0.308602] [drm:intel_opregion_setup], Public ACPI methods supported
[    0.308603] [drm:intel_opregion_setup], SWSCI supported
[    0.308605] [drm:intel_opregion_setup], ASLE supported
[    0.308622] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    0.308649] [drm:init_status_page], render ring hws offset: 0x007bf000
[    0.308710] [drm:intel_parse_bios], Using VBT from OpRegion: $VBT BEARLAKE-B     d
[    0.308716] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    0.308730] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[    0.308733] [drm:parse_device_mapping], no child dev is parsed from VBT 
[    0.308744] [drm:intel_dsm_pci_probe], no _DSM method for intel device
[    0.308755] [drm:intel_modeset_init], 2 display pipes available.
[    0.308809] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.309206] [drm] initialized overlay support
[    0.329275] [drm:intel_update_fbc], 
[    0.329277] [drm:intel_update_watermarks], plane B (pipe 1) clock: 0
[    0.329279] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    0.329281] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    0.329283] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[    0.329285] [drm:intel_calculate_wm], FIFO watermark level: 26
[    0.329286] [drm:intel_calculate_wm], FIFO entries required for mode: 0
[    0.329288] [drm:intel_calculate_wm], FIFO watermark level: 29
[    0.329290] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[    0.329291] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[    0.329294] [drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
[    0.329296] [drm:intel_update_fbc], 
[    0.329299] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[    1.336014] [drm:intel_crt_detect_hotplug], timed out waiting for FORCE_DETECT to go off
[    1.336017] [drm:intel_crt_detect], CRT not detected via hotplug
[    1.336020] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[    1.336023] No connectors reported connected with modes
[    1.336091] [drm:drm_setup_crtcs], 
[    1.336094] [drm:drm_enable_connectors], connector 5 enabled? no
[    1.336096] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
[    1.336100] [drm] Cannot find any crtc or sizes - going 1024x768
[    1.338451] [drm:intelfb_create], allocated 1024x768 fb: 0x007f0000, bo f5481840
[    1.338575] fbcon: inteldrmfb (fb0) is primary device
[    1.339077] [drm:drm_crtc_helper_set_config], 
[    1.339078] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:7] #connectors=0 (x y) (0 0)
[    1.339081] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    1.339083] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[    1.339085] [drm:drm_crtc_helper_set_config], 
[    1.339086] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:7] #connectors=0 (x y) (0 0)
[    1.339088] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    1.339089] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[    1.342355] Console: switching to colour frame buffer device 128x48
[    1.344012] fb0: inteldrmfb frame buffer device
[    1.344029] drm: registered panic notifier
[    1.344052] No ACPI video bus found
[    1.344110] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0


--------------050509010204030606030104--
