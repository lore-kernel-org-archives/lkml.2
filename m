Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab2FJNjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 09:39:35 -0400
Received: from nebuchadnezzar.smejdil.cz ([195.122.194.203]:55663 "EHLO
	nebuchadnezzar.smejdil.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2FJNje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 09:39:34 -0400
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jun 2012 09:39:34 EDT
From: cijoml@volny.cz
To: linux-kernel@vger.kernel.org
Subject: OOPS firmware not loaded
Date: Sun, 10 Jun 2012 15:32:18 +0200
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Message-Id: <20120610133218.591D0B836@nebuchadnezzar.smejdil.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys, 

after upgrade to the 3.4.X kernel my dongle does not resume correctly. 
Firmware is in its place and when I remove and plug it again into USB slot, 
firmware is loaded.
There is one more long lasting problem, when I suspend with DVB stream 
playing, computer freezes completely! 

Thank you for fix. 

PM: resume of devices complete after 1944.596 msecs
dvb-usb: found a 'Leadtek Winfast DTV Dongle (STK7700P based)' in cold 
state, will try to load a firmware
 ------------[ cut here ]------------
WARNING: at drivers/base/firmware_class.c:597 request_firmware+0x45/0xae()
Hardware name: 901
Modules linked in: rndis_host cdc_ether usbnet mii i915 drm_kms_helper 
cfbcopyarea cfbimgblt cfbfillrect rfcomm bnep aes_i586 aes_generic loop 
rc_dib0700_rc5 dvb_usb_dib0700 dib0090 dib7000p dib7000m dib0070 dvb_usb 
dib8000 mt2266 tuner_xc2028 dib3000mc mxl5007t xc5000 s5h1411 mt2060 
lgdt3305 dvb_core rc_core xc4000 dibx000_common usbhid hid cryptomgr aead 
btusb bluetooth arc4 crypto_algapi snd_hda_codec_realtek snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_oss 
snd_seq_midi_event snd_seq rtl8192ce rtl8192c_common rtlwifi snd_timer 
snd_seq_device mac80211 coretemp uhci_hcd psmouse cfg80211 ehci_hcd snd 
video eeepc_laptop sparse_keymap hwmon rfkill pci_hotplug atl1e 
snd_page_alloc
Pid: 7691, comm: pm-suspend Tainted: G        W    3.4.1 #1
Call Trace:
 [<c1022639>] ? warn_slowpath_common+0x7c/0x8f
 [<c11e0777>] ? request_firmware+0x45/0xae
 [<c11e0777>] ? request_firmware+0x45/0xae
 [<c1022667>] ? warn_slowpath_null+0x1b/0x1e
 [<c11e0777>] ? request_firmware+0x45/0xae
 [<f880db3d>] ? dib0700_identify_state+0x81/0x89 [dvb_usb_dib0700]
 [<f87ae245>] ? dvb_usb_download_firmware+0x21/0xa4 [dvb_usb]
 [<f880dabc>] ? dib0700_probe+0xa2/0xa2 [dvb_usb_dib0700]
 [<f880dabc>] ? dib0700_probe+0xa2/0xa2 [dvb_usb_dib0700]
 [<f87ae52f>] ? dvb_usb_device_init+0x157/0x518 [dvb_usb]
 [<f880da4f>] ? dib0700_probe+0x35/0xa2 [dvb_usb_dib0700]
 [<c1214d6d>] ? usb_match_one_id+0x19/0x6e
 [<c12154c1>] ? usb_probe_interface+0xa6/0xe7
 [<c10e06d2>] ? sysfs_create_link+0xf/0x11
 [<c11d9b7d>] ? driver_probe_device+0x86/0x167
 [<c1214f61>] ? usb_device_match+0x31/0x54
 [<c11d8a02>] ? bus_for_each_drv+0x37/0x5f
 [<c11d9d4e>] ? device_attach+0x52/0x69
 [<c11d9cb9>] ? __driver_attach+0x5b/0x5b
 [<c121588e>] ? usb_rebind_intf+0x25/0x42
 [<c12158d3>] ? usb_resume_complete+0x28/0x36
 [<c11dd983>] ? dpm_complete+0xb7/0x111
 [<c10463bc>] ? suspend_devices_and_enter+0x164/0x189
 [<c10464fb>] ? pm_suspend+0x11a/0x137
 [<c1045c59>] ? state_store+0x75/0x90
 [<c1045be4>] ? pm_async_store+0x2f/0x2f
 [<c1146abe>] ? kobj_attr_store+0x1a/0x22
 [<c10def7b>] ? sysfs_write_file+0xbd/0xe9
 [<c10deebe>] ? sysfs_open_file+0x1c5/0x1c5
 [<c109fd03>] ? vfs_write+0x7a/0xad
 [<c109fdd6>] ? sys_write+0x41/0x67
 [<c12a850c>] ? sysenter_do_call+0x12/0x22
 ---[ end trace 7632ba16109d1440 ]---
usb 2-2.3: firmware: dvb-usb-dib0700-1.20.fw will not be loaded
dvb-usb: did not find the firmware file. (dvb-usb-dib0700-1.20.fw) Please 
see linux/Documentation/dvb/ for more details on firmware-problems. (-11)
Restarting tasks ... done.
