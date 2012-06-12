Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab2FLLh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 07:37:58 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37640 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab2FLLh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 07:37:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAMeQTsaknGLR2QCWwN8kYKh8y=JJtqN-ZSty6YTKnAOv2Vp3XQ@mail.gmail.com>
References: <CAH9NwWd1F3Vw2zrQJh8Jazm45C_BAH3H3-qupvm2XaLgDOM=QQ@mail.gmail.com>
 <CAMeQTsZfE8_t6DCr3UWVqnOLyxNuNh7_VxJmqiP+enBBqM0o_A@mail.gmail.com>
 <CAH9NwWc3W6zHCFf9rwKg5NMQaWnh4A=xVVysmG1Y=eUMzu=18Q@mail.gmail.com> <CAMeQTsaknGLR2QCWwN8kYKh8y=JJtqN-ZSty6YTKnAOv2Vp3XQ@mail.gmail.com>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Tue, 12 Jun 2012 13:37:36 +0200
Message-ID: <CAH9NwWdmhmLB5io5RWVQBj6c7zjXT9hFa7OAHVrL6oY8P0kjaw@mail.gmail.com>
Subject: Re: gma500: Cannot find any crtc or sizes - going 1024x768
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/12 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>:
> On Tue, Jun 12, 2012 at 10:59 AM, Christian Gmeiner
> <christian.gmeiner@gmail.com> wrote:
>> Got a little bit further:
>>
>> diff --git a/drivers/gpu/drm/gma500/mid_bios.c
>> b/drivers/gpu/drm/gma500/mid_bios.c
>> index b2a790b..9ee3122 100644
>> --- a/drivers/gpu/drm/gma500/mid_bios.c
>> +++ b/drivers/gpu/drm/gma500/mid_bios.c
>> @@ -55,8 +55,12 @@ static void mid_get_fuse_settings(struct drm_device *dev)
>>        pci_read_config_dword(pci_root, 0xD4, &fuse_value);
>>
>>        /* FB_MIPI_DISABLE doesn't mean LVDS on with Medfield */
>> +#if 0
>>        if (IS_MRST(dev))
>>                dev_priv->iLVDS_enable = fuse_value & FB_MIPI_DISABLE;
>> +#else
>> +       dev_priv->iLVDS_enable = 1;
>> +#endif
>>
>>        DRM_INFO("internal display is %s\n",
>>                 dev_priv->iLVDS_enable ? "LVDS display" : "MIPI display");
>> diff --git a/drivers/gpu/drm/gma500/psb_intel_lvds.c
>> b/drivers/gpu/drm/gma500/psb_intel_lvds.c
>> index c83f5b5..5b49522 100644
>> --- a/drivers/gpu/drm/gma500/psb_intel_lvds.c
>> +++ b/drivers/gpu/drm/gma500/psb_intel_lvds.c
>> @@ -530,11 +530,14 @@ static int psb_intel_lvds_get_modes(struct
>> drm_connector *connector)
>>        struct psb_intel_lvds_priv *lvds_priv = psb_intel_encoder->dev_priv;
>>        int ret = 0;
>>
>> +       printk(KERN_INFO "test 1\n");
>> +#if 0
>>        if (!IS_MRST(dev))
>>                ret = psb_intel_ddc_get_modes(connector,
>> &lvds_priv->i2c_bus->adapter);
>>
>>        if (ret)
>>                return ret;
>> +#endif
>>
>>        /* Didn't get an EDID, so
>>         * Set wide sync ranges so we get all modes
>>
>>
>> [    8.233858] [drm:drm_helper_probe_single_connector_modes],
>> [CONNECTOR:7:LVDS-1]
>> [    8.233869] test 1
>> [    8.233967] [drm:drm_helper_probe_single_connector_modes],
>> [CONNECTOR:7:LVDS-1] probed modes :
>> [    8.233993] [drm:drm_mode_debug_printmodeline], Modeline
>> 10:"1024x600" 75 53990 1024 1072 1104 1184 600 603 604 608 0x48 0x0
>> [    8.234038] [drm:drm_setup_crtcs],
>> [    8.234053] [drm:drm_enable_connectors], connector 7 enabled? yes
>> [    8.234066] [drm:drm_target_preferred], looking for cmdline mode on
>> connector 7
>> [    8.234077] [drm:drm_target_preferred], looking for preferred mode
>> on connector 7
>> [    8.234088] [drm:drm_target_preferred], found mode 1024x600
>> [    8.234101] [drm:drm_setup_crtcs], picking CRTCs for 2048x2048 config
>> [    8.234116] [drm:drm_setup_crtcs], desired mode 1024x600 set on crtc 3
>> [    8.242199] fbcon: psbfb (fb0) is primary device
>> [    8.244065] [drm:drm_crtc_helper_set_config],
>> [    8.244076] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:12]
>> #connectors=1 (x y) (0 0)
>> [    8.244099] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
>> [    8.244106] [drm:drm_crtc_helper_set_config], modes are different,
>> full mode set
>> [    8.244120] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0
>> 0 0 0 0 0 0 0 0x0 0x0
>> [    8.244138] [drm:drm_mode_debug_printmodeline], Modeline
>> 11:"1024x600" 75 53990 1024 1072 1104 1184 600 603 604 608 0x48 0x0
>> [    8.244145] [drm:drm_crtc_helper_set_config], encoder changed, full
>> mode switch
>> [    8.244151] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
>> [    8.244161] [drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1]
>> to [CRTC:3]
>> [    8.244168] [drm:drm_crtc_helper_set_config], attempting to set
>> mode from userspace
>> [    8.244184] [drm:drm_mode_debug_printmodeline], Modeline
>> 11:"1024x600" 75 53990 1024 1072 1104 1184 600 603 604 608 0x48 0x0
>> [    8.244195] Can't support LVDS on pipe A
>> [    8.244201] [drm:drm_crtc_helper_set_mode], Encoder fixup failed
>> [    8.244211] [drm:drm_crtc_helper_set_config] *ERROR* failed to set
>> mode on [CRTC:3]
>> [    8.244222] fbcon_init: detected unhandled fb_set_par error, error code -22
>> [    8.262085] Console: switching to colour frame buffer device 128x37
>> [    8.293680] fb0: psbfb frame buffer device
>> [    8.294817] drm: registered panic notifier
>> [    8.295173] [drm] Initialized gma500 1.0.0 2011-06-06 for
>> 0000:00:02.0 on minor 0
>
> You're hitting a bug in the IS_MRST macro. You might actually have the fuse
> value but IS_MRST returns false for 0x4108. Try the following patch:
>
> diff --git a/drivers/gpu/drm/gma500/psb_drv.h b/drivers/gpu/drm/gma500/psb_drv.h
> index 1bd115e..e8640ae 100644
> --- a/drivers/gpu/drm/gma500/psb_drv.h
> +++ b/drivers/gpu/drm/gma500/psb_drv.h
> @@ -44,7 +44,7 @@ enum {
>  };
>
>  #define IS_PSB(dev) (((dev)->pci_device & 0xfffe) == 0x8108)
> -#define IS_MRST(dev) (((dev)->pci_device & 0xfffc) == 0x4100)
> +#define IS_MRST(dev) (((dev)->pci_device & 0xfff0) == 0x4100)
>  #define IS_MFLD(dev) (((dev)->pci_device & 0xfff8) == 0x0130)
>
>  /*


Works much better with this patch applied - I see a linux desktop on
the panel :)


[   17.907584] gma500 0000:00:02.0: setting latency timer to 64
[   17.907908] [drm:psb_intel_opregion_setup], Public ACPI methods supported
[   17.907921] [drm:psb_intel_opregion_setup], ASLE supported
[   17.907945] gma500 0000:00:02.0: Enabling MSI failed!
[   17.909051] [drm] internal display is LVDS display
[   17.909183] ioremap error for 0x3ddbd000-0x3ddbe000, requested 0x10, got 0x0
[   17.909294] gma500 0000:00:02.0: Unable to read GCT!
[   17.917913] gma500 0000:00:02.0: VBT signature missing
[   17.925659] hub 6-0:1.0: USB hub found
[   17.925775] hub 6-0:1.0: 1 port detected
[   17.926214] ohci_hcd 0000:02:08.1: setting latency timer to 64
[   17.926233] ohci_hcd 0000:02:08.1: OHCI Host Controller
[   17.926349] ohci_hcd 0000:02:08.1: new USB bus registered, assigned
bus number 7
[   17.926520] ohci_hcd 0000:02:08.1: irq 16, io mem 0xd014e000
[   17.966094] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[   17.982193] hub 7-0:1.0: USB hub found
[   17.982308] hub 7-0:1.0: 1 port detected
[   17.982684] ohci_hcd 0000:02:08.2: setting latency timer to 64
[   17.982703] ohci_hcd 0000:02:08.2: OHCI Host Controller
[   17.982818] ohci_hcd 0000:02:08.2: new USB bus registered, assigned
bus number 8
[   17.982990] ohci_hcd 0000:02:08.2: irq 16, io mem 0xd014d000
[   18.000555] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   18.000657] [drm] No driver support for vblank timestamp query.
[   18.000901] gma500 0000:00:02.0: No ddc adapter available!
[   18.041626] hub 8-0:1.0: USB hub found
[   18.041740] hub 8-0:1.0: 1 port detected
[   18.081160] hub 1-1:1.0: USB hub found
[   18.081470] hub 1-1:1.0: 3 ports detected
[   18.354785] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:7:LVDS-1]
[   18.354815] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:7:LVDS-1] probed modes :
[   18.354841] [drm:drm_mode_debug_printmodeline], Modeline
10:"1024x600" 75 53990 1024 1072 1104 1184 600 603 604 608 0x48 0x0
[   18.354853] [drm:drm_setup_crtcs],
[   18.354868] [drm:drm_enable_connectors], connector 7 enabled? yes
[   18.354881] [drm:drm_target_preferred], looking for cmdline mode on
connector 7
[   18.354894] [drm:drm_target_preferred], looking for preferred mode
on connector 7
[   18.354906] [drm:drm_target_preferred], found mode 1024x600
[   18.354918] [drm:drm_setup_crtcs], picking CRTCs for 2048x2048 config
[   18.354933] [drm:drm_setup_crtcs], desired mode 1024x600 set on crtc 3
[   18.367788] fbcon: psbfb (fb0) is primary device
[   18.370608] [drm:drm_crtc_helper_set_config],
[   18.370619] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:12]
#connectors=1 (x y) (0 0)
[   18.370643] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[   18.370649] [drm:drm_crtc_helper_set_config], modes are different,
full mode set
[   18.370664] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0
0 0 0 0 0 0 0 0x0 0x0
[   18.370681] [drm:drm_mode_debug_printmodeline], Modeline
11:"1024x600" 75 53990 1024 1072 1104 1184 600 603 604 608 0x48 0x0
[   18.370689] [drm:drm_crtc_helper_set_config], encoder changed, full
mode switch
[   18.370696] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[   18.370706] [drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1]
to [CRTC:3]
[   18.370713] [drm:drm_crtc_helper_set_config], attempting to set
mode from userspace
[   18.370730] [drm:drm_mode_debug_printmodeline], Modeline
11:"1024x600" 75 53990 1024 1072 1104 1184 600 603 604 608 0x48 0x0
[   18.370747] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[   18.401081] usb 6-1: new full-speed USB device number 2 using ohci_hcd
[   18.440582] [drm:drm_crtc_helper_set_mode], [ENCODER:8:LVDS-8] set
[MODE:11:1024x600]
[   18.477990] [drm:drm_crtc_helper_set_config], Setting connector
DPMS state to on
[   18.478002] [drm:drm_crtc_helper_set_config],
[CONNECTOR:7:LVDS-1] set DPMS on
[   18.505542] [drm:drm_crtc_helper_set_config],
[   18.505550] [drm:drm_crtc_helper_set_config], [CRTC:4] [NOFB]
[   18.603146] Console: switching to colour frame buffer device 128x37
[   18.613253] usbcore: registered new interface driver usbhid
[   18.613256] usbhid: USB HID core driver
[   18.619328] fb0: psbfb frame buffer device
[   18.619332] drm: registered panic notifier
[   18.619857] [drm] Initialized gma500 1.0.0 2011-06-06 for
0000:00:02.0 on minor 0


Is there a way to overwrite the found modeline?

Thanks
---
Christian Gmeiner, MSc
