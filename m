Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1AFPuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:50:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53497 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab1AFPuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:50:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XestSu4gzrfDHDGaYhYC2F2TxlWhTzq43DTrJFWclJh1U07Fy4DwIB4Nlso3dTKFl8
         CQmvPTuZ9tTcWqWj8F32DzNGQkQ4o0YlA48dcMZFkvjEKrDWaAElh6sfK8wAh0oT0clS
         sF11ITeKoBufMaWCQZb+BgFiHHd/gsTu9cFDM=
MIME-Version: 1.0
In-Reply-To: <AANLkTimA5UOVn6+xe0ofV1F3_XhAP0daBvOAX2k1u_dU@mail.gmail.com>
References: <20101223171859.f6842045.sfr@canb.auug.org.au>
	<4D139517.3010608@ti.com>
	<AANLkTi=pTNg2iWN+=uEv=CyZHHCoddF51pmmCMjPeMUF@mail.gmail.com>
	<4ce0f816f951f24ca3de9c84d9f70842@mail.gmail.com>
	<AANLkTimA5UOVn6+xe0ofV1F3_XhAP0daBvOAX2k1u_dU@mail.gmail.com>
Date: Thu, 6 Jan 2011 23:50:02 +0800
Message-ID: <AANLkTimzQ1PHN986fqPF0yjd1M+390nSUDYJ65pu0z_f@mail.gmail.com>
Subject: Re: linux-next: manual merge of the usb tree with the omap tree
From: Ming Lei <tom.leiming@gmail.com>
To: Anand Gadiyar <gadiyar@ti.com>
Cc: Benoit Cousson <b-cousson@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Walmsley <paul@pwsan.com>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e65b60fe6fe40104992f7454
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e65b60fe6fe40104992f7454
Content-Type: text/plain; charset=ISO-8859-1

Hi,

2011/1/6 Ming Lei <tom.leiming@gmail.com>:
> Hi,
>
> 2011/1/6 Anand Gadiyar <gadiyar@ti.com>:
>
>> I'll take a look in a short while. I don't have an XM to
>> test, so you'll have to help me out here.
>
> No problem for me, :-)

I see why the beagle xM does not work, the attachment patch is
needed to make it working.

But the ehci on panda(omap4430) still does not work with
2.6.37-next-20110106+, and follows the failure messages:

[   46.572601] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   46.580017] ehci_hcd: block sizes: qh 60 qtd 96 itd 160 sitd 96
[   46.580078] bus: 'platform': add driver ehci-omap
[   46.580139] bus: 'platform': driver_probe_device: matched device
ehci-omap.0 with driver ehci-omap
[   46.580169] bus: 'platform': really_probe: probing driver ehci-omap
with device ehci-omap.0
[   46.580200] ehci-omap ehci-omap.0: failed to get ehci port0 regulator
[   46.580200] ehci-omap ehci-omap.0: starting TI EHCI USB Controller
[   46.580291] ehci-omap ehci-omap.0: OMAP UHH_REVISION 0x50700100
[   46.580352] ehci-omap ehci-omap.0: TLL RESET DONE
[   46.580352] ehci-omap ehci-omap.0: UHH setup done, uhh_hostconfig=1c
[   46.580383] ehci-omap ehci-omap.0: reset hcs_params 0x1313 dbg=0
cc=1 pcc=3 ordered ports=3
[   46.580383] ehci-omap ehci-omap.0: reset hcc_params 20016 thresh 1
uframes 256/512/1024 park LPM
[   46.580383] ehci-omap ehci-omap.0: OMAP-EHCI Host Controller
[   46.588592] drivers/usb/core/inode.c: creating file 'devices'
[   46.588623] drivers/usb/core/inode.c: creating file '001'
[   46.588684] device: 'usbmon1': device_add
[   46.588867] PM: Adding info for No Bus:usbmon1
[   46.590026] ehci-omap ehci-omap.0: new USB bus registered, assigned
bus number 1
[   46.645721] ehci-omap ehci-omap.0: park 0
[   46.645721] ehci-omap ehci-omap.0: support lpm
[   46.645751] ehci-omap ehci-omap.0: irq 109, io mem 0x4a064c00
[   46.651763] ehci-omap ehci-omap.0: reset command 0080b02  park=3
ithresh=8 period=1024 Reset HALT
[   46.651763] ehci-omap ehci-omap.0: init command 0010005 (park)=0
ithresh=1 period=512 RUN
[   46.661254] ehci-omap ehci-omap.0: USB 2.0 started, EHCI 1.00
[   46.667297] usb usb1: rpm_resume flags 0x0
[   46.667297] usb usb1: rpm_resume returns 1
[   46.667358] usb usb1: default language 0x0409
[   46.667358] usb usb1: udev 1, busnum 1, minor = 0
[   46.667388] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   46.675476] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[   46.683288] usb usb1: Product: OMAP-EHCI Host Controller
[   46.689086] usb usb1: Manufacturer: Linux 2.6.37-next-20110106+ ehci_hcd
[   46.696350] usb usb1: SerialNumber: ehci-omap.0
[   46.701354] device: 'usb1': device_add
[   46.701568] bus: 'usb': add device usb1
[   46.701629] PM: Adding info for usb:usb1
[   46.702758] bus: 'usb': driver_probe_device: matched device usb1
with driver usb
[   46.702758] bus: 'usb': really_probe: probing driver usb with device usb1
[   46.702819] usb usb1: usb_probe_device
[   46.702819] usb usb1: configuration #1 chosen from 1 choice
[   46.702850] usb usb1: rpm_resume flags 0x4
[   46.702850] usb usb1: rpm_resume returns 1
[   46.702911] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   46.702911] device: '1-0:1.0': device_add
[   46.702941] bus: 'usb': add device 1-0:1.0
[   46.703002] PM: Adding info for usb:1-0:1.0
[   46.703430] bus: 'usb': driver_probe_device: matched device 1-0:1.0
with driver hub
[   46.703460] bus: 'usb': really_probe: probing driver hub with device 1-0:1.0
[   46.703460] hub 1-0:1.0: usb_probe_interface
[   46.703491] hub 1-0:1.0: usb_probe_interface - got id
[   46.703491] usb usb1: rpm_resume flags 0x4
[   46.703491] usb usb1: rpm_resume returns 1
[   46.703521] hub 1-0:1.0: USB hub found
[   46.707427] hub 1-0:1.0: 3 ports detected
[   46.715698] hub 1-0:1.0: standalone hub
[   46.715698] hub 1-0:1.0: individual port power switching
[   46.715728] hub 1-0:1.0: individual port over-current protection
[   46.715728] hub 1-0:1.0: power on to power good time: 20ms
[   46.715759] hub 1-0:1.0: local power source is good
[   46.715759] hub 1-0:1.0: enabling power on all ports
[   46.715820] driver: '1-0:1.0': driver_bound: bound to device 'hub'
[   46.715820] bus: 'usb': really_probe: bound device 1-0:1.0 to driver hub
[   46.715850] device: 'ep_81': device_add
[   46.717468] PM: Adding info for No Bus:ep_81
[   46.717498] device: 'usbdev1.1': device_add
[   46.717590] PM: Adding info for No Bus:usbdev1.1
[   46.717773] drivers/usb/core/inode.c: creating file '001'
[   46.717803] driver: 'usb1': driver_bound: bound to device 'usb'
[   46.717803] bus: 'usb': really_probe: bound device usb1 to driver usb
[   46.717834] device: 'ep_00': device_add
[   46.717895] PM: Adding info for No Bus:ep_00
[   46.717895] usb usb1: rpm_suspend flags 0xc
[   46.717926] usb usb1: rpm_suspend returns -16
[   46.717926] ehci-omap ehci-omap.0: ...powerup ports...
[   46.747161] driver: 'ehci-omap.0': driver_bound: bound to device 'ehci-omap'
[   46.747192] bus: 'platform': really_probe: bound device ehci-omap.0
to driver ehci-omap
[   46.809661] ehci-omap ehci-omap.0: GetStatus port:1 status 001803 0
 ACK POWER sig=j CSC CONNECT
[   46.809692] hub 1-0:1.0: port 1: status 0501 change 0001
[   46.911193] hub 1-0:1.0: state 7 ports 3 chg 0002 evt 0000
[   46.911193] hub 1-0:1.0: rpm_resume flags 0x4
[   46.911193] hub 1-0:1.0: rpm_resume returns 1
[   46.911224] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[   46.973907] ehci-omap ehci-omap.0: port 1 high speed
[   46.973907] ehci-omap ehci-omap.0: GetStatus port:1 status 001005 0
 ACK POWER sig=se0 PE CONNECT
[   47.036102] usb 1-1: new high speed USB device using ehci-omap and address 2
[   47.044036] ehci-omap ehci-omap.0: detected XactErr len 0/8 retry 1
[   47.044158] ehci-omap ehci-omap.0: detected XactErr len 0/8 retry 2
[   47.044281] ehci-omap ehci-omap.0: detected XactErr len 0/8 retry 3
[   47.044403] ehci-omap ehci-omap.0: detected XactErr len 0/8 retry 4
[   47.044525] ehci-omap ehci-omap.0: detected XactErr len 0/8 retry 5
[   47.044647] ehci-omap ehci-omap.0: detected XactErr len 0/8 retry 6
[   47.044799] ehci-omap ehci-omap.0: detected XactErr len 0/8 retry 7
[   47.044921] ehci-omap ehci-omap.0: detected XactErr len 0/8 retry 8
......

Anand, could you help to check it?

thanks,
-- 
Lei Ming

--0016e65b60fe6fe40104992f7454
Content-Type: text/x-patch; charset=US-ASCII; name="fix_ehci_gpio_beagle_xm.patch"
Content-Disposition: attachment; filename="fix_ehci_gpio_beagle_xm.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_giltxdr80

ZGlmZiAtLWdpdCBhL2FyY2gvYXJtL21hY2gtb21hcDIvYm9hcmQtb21hcDNiZWFnbGUuYyBiL2Fy
Y2gvYXJtL21hY2gtb21hcDIvYm9hcmQtb21hcDNiZWFnbGUuYwppbmRleCBmMWE4ZWRlLi4zZTEz
MGFlIDEwMDY0NAotLS0gYS9hcmNoL2FybS9tYWNoLW9tYXAyL2JvYXJkLW9tYXAzYmVhZ2xlLmMK
KysrIGIvYXJjaC9hcm0vbWFjaC1vbWFwMi9ib2FyZC1vbWFwM2JlYWdsZS5jCkBAIC0yOTksNyAr
Mjk5LDEwIEBAIHN0YXRpYyBpbnQgYmVhZ2xlX3R3bF9ncGlvX3NldHVwKHN0cnVjdCBkZXZpY2Ug
KmRldiwKIAogCS8qIFRXTDQwMzBfR1BJT19NQVggKyAwID09IGxlZEEsIEVIQ0kgbkVOX1VTQl9Q
V1IgKG91dCwgYWN0aXZlIGxvdykgKi8KIAlncGlvX3JlcXVlc3QoZ3BpbyArIFRXTDQwMzBfR1BJ
T19NQVgsICJuRU5fVVNCX1BXUiIpOwotCWdwaW9fZGlyZWN0aW9uX291dHB1dChncGlvICsgVFdM
NDAzMF9HUElPX01BWCwgMCk7CisJaWYgKG9tYXAzX2JlYWdsZV9nZXRfcmV2KCkgPT0gT01BUDNC
RUFHTEVfQk9BUkRfWE0pCisJCWdwaW9fZGlyZWN0aW9uX291dHB1dChncGlvICsgVFdMNDAzMF9H
UElPX01BWCwgMSk7CisJZWxzZQorCQlncGlvX2RpcmVjdGlvbl9vdXRwdXQoZ3BpbyArIFRXTDQw
MzBfR1BJT19NQVgsIDApOwogCiAJLyogVFdMNDAzMF9HUElPX01BWCArIDEgPT0gbGVkQiwgUE1V
X1NUQVQgKG91dCwgYWN0aXZlIGxvdyBMRUQpICovCiAJZ3Bpb19sZWRzWzJdLmdwaW8gPSBncGlv
ICsgVFdMNDAzMF9HUElPX01BWCArIDE7Ci0tIAoxLjcuMwoK
--0016e65b60fe6fe40104992f7454--
