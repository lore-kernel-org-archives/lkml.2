Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216Ab1H0P1z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 11:27:55 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61409 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab1H0P1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 11:27:54 -0400
Message-ID: <4E590CE3.4090505@gmail.com>
Date: Sat, 27 Aug 2011 08:27:31 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [RFC 1/2]drivers:staging:usbip:stub_dev.c change SPIN_LOCK_UNLOCKED
 to __SPIN_LOCK_UNLOCKED
References: <1311960037-9581-1-git-send-email-justinmattock@gmail.com> <20110823214142.GE3679@kroah.com>
In-Reply-To: <20110823214142.GE3679@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 02:41 PM, Greg KH wrote:
> On Fri, Jul 29, 2011 at 10:20:36AM -0700, Justin P. Mattock wrote:
>> From: "Justin P. Mattock"<justinmattock@gmail.com>
>>
>> The patch below updates SPIN_LOCK_UNLOCKED to __SPIN_LOCK_UNLOCKED since it is
>> deprected according to my search results.
>> Note: Keep in mind I am not sure if this is the correct change for this(still learning)
>> even though it's commented out and such.(figured to give this a try and see).
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>
> As these were "RFC" I'm not going to apply them.
>
> Care to test them out and see if they really work?
>
> thanks,
>
> greg k-h
>

well, I went and changed up the patch to test these out. Im not sure how 
this app works for this driver(will look into), but just looking at 
dmesg gives me an idea of why they commented this out..:
(without patch applied the below shows up as well)


[  104.566320] usbip_core: module is from the staging directory, the 
quality is unknown, you have been warned.
[  104.566842] usbip_core: usbip_core_init:843: USB/IP Core v1.0.0
[  116.990063] usbip_host: module is from the staging directory, the 
quality is unknown, you have been warned.
[  116.991268] usbip-host 5-1:1.2: Enter
[  116.991357] BUG: spinlock bad magic on CPU#0, modprobe/1627
[  116.991369]  lock: ffffffffa013b330, .magic: 00000000, .owner: 
<none>/-1, .owner_cpu: 0
[  116.991392] Pid: 1627, comm: modprobe Tainted: G         C 
3.1.0-rc3-00161-g671ee7f-dirty #24
[  116.991403] Call Trace:
[  116.991439]  [<ffffffff814a9411>] spin_bug+0xa3/0xab
[  116.991501]  [<ffffffff81230553>] do_raw_spin_lock+0x29/0x13d
[  116.991587]  [<ffffffff814aeaff>] _raw_spin_lock+0x39/0x40
[  116.991624]  [<ffffffffa0138c53>] ? get_busid_priv+0x1b/0x4b [usbip_host]
[  116.991672]  [<ffffffffa0138c53>] get_busid_priv+0x1b/0x4b [usbip_host]
[  116.991716]  [<ffffffffa01386a7>] stub_probe+0x57/0x45d [usbip_host]
[  116.991770]  [<ffffffff81345f84>] usb_probe_interface+0x150/0x1bd
[  116.991804]  [<ffffffff812db077>] driver_probe_device+0x131/0x213
[  116.991861]  [<ffffffff812db1b7>] __driver_attach+0x5e/0x82
[  116.991889]  [<ffffffff812db159>] ? driver_probe_device+0x213/0x213
[  116.991904]  [<ffffffff812da0c8>] bus_for_each_dev+0x59/0x8f
[  116.991946]  [<ffffffff812dac54>] driver_attach+0x1e/0x20
[  116.991961]  [<ffffffff812da870>] bus_add_driver+0xd4/0x22a
[  116.992067]  [<ffffffff812db672>] driver_register+0x98/0x105
[  116.992221]  [<ffffffff813450b7>] usb_register_driver+0xb8/0x17c
[  116.992234]  [<ffffffffa013d000>] ? 0xffffffffa013cfff
[  116.992246]  [<ffffffffa013d06c>] usbip_host_init+0x6c/0x144 [usbip_host]
[  116.992258]  [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
[  116.992268]  [<ffffffff81087c26>] sys_init_module+0x88/0x1d2
[  116.992277]  [<ffffffff814b5b42>] system_call_fastpath+0x16/0x1b
[  116.992286] usbip-host 5-1:1.2: 5-1 is not in match_busid table... skip!
[  116.992355] usbcore: registered new interface driver usbip-host
[  116.992366] usbip_host: usbip_host_init:269: USB/IP Host Driver v1.0.0
[  126.545592] vhci_hcd: module is from the staging directory, the 
quality is unknown, you have been warned.
[  126.546315] vhci_hcd: vhci_hcd_probe:1086: name vhci_hcd id -1
[  126.546324] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[  126.552145] vhci_hcd vhci_hcd: new USB bus registered, assigned bus 
number 6
[  126.552164] vhci_hcd: vhci_start:962: enter vhci_start
[  126.554695] usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
[  126.554701] usb usb6: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[  126.554705] usb usb6: Product: USB/IP Virtual Host Controller
[  126.554708] usb usb6: Manufacturer: Linux 
3.1.0-rc3-00161-g671ee7f-dirty vhci_hcd
[  126.554711] usb usb6: SerialNumber: vhci_hcd
[  126.554979] hub 6-0:1.0: USB hub found
[  126.554986] vhci_hcd: vhci_hub_control:279: typeReq a006 wValue 2900 
wIndex 0
[  126.554989] vhci_hcd: vhci_hub_control:339:  GetHubDescriptor
[  126.554992] vhci_hcd: vhci_hub_control:479: port -1
[  126.554994] vhci_hcd: vhci_hub_control:486:  bye
[  126.554999] hub 6-0:1.0: 8 ports detected
[  126.555006] vhci_hcd: vhci_hub_control:279: typeReq a000 wValue 0 
wIndex 0
[  126.555050] vhci_hcd: vhci_hub_control:343:  GetHubStatus
[  126.555052] vhci_hcd: vhci_hub_control:479: port -1
[  126.555055] vhci_hcd: vhci_hub_control:486:  bye
[  126.555061] vhci_hcd: vhci_hub_control:279: typeReq 2303 wValue 8 
wIndex 1
[  126.555064] vhci_hcd: vhci_hub_control:462:  SetPortFeature: default 8
[  126.555067] vhci_hcd: vhci_hub_control:479: port 0

I will try and test this out with the app. other than that seems to be 
functioning like the original.

Justin P. Mattock
