Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab2JTXPY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 19:15:24 -0400
Received: from smtprelay0026.b.hostedemail.com ([64.98.42.26]:40953 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753388Ab2JTXPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 19:15:23 -0400
X-Panda: scanned!
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:::::::::::::,RULES_HIT:2:152:355:379:541:582:599:601:960:966:967:968:973:982:988:989:1152:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2108:2194:2196:2198:2199:2200:2201:2393:2525:2553:2565:2682:2685:2729:2743:2857:2859:2896:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3027:3138:3139:3140:3141:3142:3167:3484:3636:3865:3867:3868:3869:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4049:4118:4225:4250:4321:4385:5007:6117:6119:6261:7679:7875:7903:7904:8957:9025:9108:9164:10004:10848:11658:11854:11914:12043:12350:12517:12519:12740,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSomf04|997365504|41AB14C
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 7565
Date: Sat, 20 Oct 2012 23:15:17 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: bp@alien8.de
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        security@kernel.org, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org
Message-ID: <1781795634.31179.1350774917965.JavaMail.mail@webmail04>
References: <2104474742.26357.1350734815286.JavaMail.mail@webmail05>
 <20121020162759.GA12551@liondog.tnic>
 <966148591.30347.1350754909449.JavaMail.mail@webmail08>
 <20121020203227.GC555@elf.ucw.cz> <20121020225849.GA8976@liondog.tnic>
Subject: Re: Re: Re: A reliable kernel panic (3.6.2) and system crash when
 visiting a particular website
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [5.166.170.242]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You don't get me - I have *no* VirtualBox (or any proprietary) modules running
- but I can reproduce this problem using *the same system running under* VirtualBox
in Windows 7 64.

It's almost definitely either a USB driver bug or video4linux driver bug:

I'm CC'ing linux-media and linux-usb mailing lists, the problem is described here:
https://lkml.org/lkml/2012/10/20/35
https://lkml.org/lkml/2012/10/20/148

Here are  the last lines from my dmesg (with usbmon loaded):

[  292.164833] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0002
[  292.168091] ehci_hcd 0000:00:1f.5: GetStatus port:1 status 00100a 0  ACK POWER sig=se0 PEC CSC
[  292.172063] hub 1-0:1.0: port 1, status 0100, change 0003, 12 Mb/s
[  292.174883] usb 1-1: USB disconnect, device number 2
[  292.178045] usb 1-1: unregistering device
[  292.183539] usb 1-1: unregistering interface 1-1:1.0
[  292.197034] usb 1-1: unregistering interface 1-1:1.1
[  292.204317] usb 1-1: unregistering interface 1-1:1.2
[  292.234519] usb 1-1: unregistering interface 1-1:1.3
[  292.236175] usb 1-1: usb_disable_device nuking all URBs
[  292.364429] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
[  294.364279] hub 1-0:1.0: hub_suspend
[  294.366045] usb usb1: bus auto-suspend, wakeup 1
[  294.367375] ehci_hcd 0000:00:1f.5: suspend root hub
[  296.501084] usb usb1: usb wakeup-resume
[  296.508311] usb usb1: usb auto-resume
[  296.509833] ehci_hcd 0000:00:1f.5: resume root hub
[  296.560149] hub 1-0:1.0: hub_resume
[  296.562240] ehci_hcd 0000:00:1f.5: GetStatus port:1 status 001003 0  ACK POWER sig=se0 CSC CONNECT
[  296.566141] hub 1-0:1.0: port 1: status 0501 change 0001
[  296.670413] hub 1-0:1.0: state 7 ports 8 chg 0002 evt 0000
[  296.673222] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[  297.311720] usb 1-1: new high-speed USB device number 3 using ehci_hcd
[  300.547237] usb 1-1: skipped 1 descriptor after configuration
[  300.549443] usb 1-1: skipped 4 descriptors after interface
[  300.552273] usb 1-1: skipped 2 descriptors after interface
[  300.556499] usb 1-1: skipped 1 descriptor after endpoint
[  300.559392] usb 1-1: skipped 2 descriptors after interface
[  300.560960] usb 1-1: skipped 1 descriptor after endpoint
[  300.562169] usb 1-1: skipped 2 descriptors after interface
[  300.563440] usb 1-1: skipped 1 descriptor after endpoint
[  300.564639] usb 1-1: skipped 2 descriptors after interface
[  300.565828] usb 1-1: skipped 2 descriptors after endpoint
[  300.567084] usb 1-1: skipped 9 descriptors after interface
[  300.569205] usb 1-1: skipped 1 descriptor after endpoint
[  300.570484] usb 1-1: skipped 53 descriptors after interface
[  300.595843] usb 1-1: default language 0x0409
[  300.602503] usb 1-1: USB interface quirks for this device: 2
[  300.605700] usb 1-1: udev 3, busnum 1, minor = 2
[  300.606959] usb 1-1: New USB device found, idVendor=046d, idProduct=081d
[  300.610298] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=1
[  300.613742] usb 1-1: SerialNumber: 48C5D2B0
[  300.617703] usb 1-1: usb_probe_device
[  300.620594] usb 1-1: configuration #1 chosen from 1 choice
[  300.639218] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[  300.640736] snd-usb-audio 1-1:1.0: usb_probe_interface
[  300.642307] snd-usb-audio 1-1:1.0: usb_probe_interface - got id
[  301.050296] usb 1-1: adding 1-1:1.1 (config #1, interface 1)
[  301.054897] usb 1-1: adding 1-1:1.2 (config #1, interface 2)
[  301.056934] uvcvideo 1-1:1.2: usb_probe_interface
[  301.058072] uvcvideo 1-1:1.2: usb_probe_interface - got id
[  301.059395] uvcvideo: Found UVC 1.00 device <unnamed> (046d:081d)
[  301.090173] input: UVC Camera (046d:081d) as /devices/pci0000:00/0000:00:1f.5/usb1/1-1/1-1:1.2/input/input7
[  301.111289] usb 1-1: adding 1-1:1.3 (config #1, interface 3)
[  301.131207] usb 1-1: link qh16-0001/f48d64c0 start 2 [1/0 us]
[  301.137066] usb 1-1: unlink qh16-0001/f48d64c0 start 2 [1/0 us]
[  301.156451] ehci_hcd 0000:00:1f.5: reused qh f48d64c0 schedule
[  301.158310] usb 1-1: link qh16-0001/f48d64c0 start 2 [1/0 us]
[  301.160238] usb 1-1: unlink qh16-0001/f48d64c0 start 2 [1/0 us]
[  301.196606] set resolution quirk: cval->res = 384
[  371.309569] e1000: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[  390.729568] ehci_hcd 0000:00:1f.5: reused qh f48d64c0 schedule
f5ade900 2296555[  390.730023] usb 1-1: link qh16-0001/f48d64c0 start 2 [1/0 us]
437 S Ii:1:003:7[  390.736394] usb 1-1: unlink qh16-0001/f48d64c0 start 2 [1/0 us]
 -115:128 16 <
f5ade900 2296566256 C Ii:1:003:7 -2:128 0
[  391.100896] ehci_hcd 0000:00:1f.5: reused qh f48d64c0 schedule
[  391.103188] usb 1-1: link qh16-0001/f48d64c0 start 2 [1/0 us]
f5ade900 2296926929 S Ii:1:003:7[  391.104889] usb 1-1: unlink qh16-0001/f48d64c0 start 2 [1/0 us]
 -115:128 16 <
f5ade900 2296937889 C Ii:1:003:7 -2:128 0
f5272300 2310382508 S Co:1:003:0 s 01 0b 0004 0001 0000 0
f5272300 2310407888 C Co:1:003:0 0 0
f5272300 2310408051 S Co:1:003:0 s 22 01 0100 0086 0003 3 = 80bb00
f5272300 2310412456 C Co:1:003:0 0 3 >
f5272300 2310412521 S Ci:1:003:0 s a2 81 0100 0086 0003 3 <
f5272300 2310415909 C Ci:1:003:0 0 0
f5272300 2310418133 S Zi:1:003:6 -115:8:0 1 -18:0:100 100 <
f5272600 2310418219 S Zi:1:003:6 -115:8:0 1 -18:0:100 100 <
f52720c0 2310418239 S Zi:1:003:6 -115:8:0 1 -18:0:100 100 <
f5272a80 2310418247 S Zi:1:003:6 -115:8:0 1 -18:0:100 100 <
f5272480 2310418256 S Zi:1:003:6 -115:8:0 1 -18:0:100 100 <
f52723c0 2310418264 S Zi:1:003:6 -115:8:0 1 -18:0:100 100 <
f5272d80 2310418272 S Zi:1:003:6 -115:8:0 1 -18:0:100 100 <
f5272b40 2310418280 S Zi:1:003:6 -115:8:0 1 -18:0:100 100 <

Hard freeze with 100% CPU usage at this point as if some driver got into an
infinite loop or something.

All debug options from https://lkml.org/lkml/2012/10/20/116 are enabled, but
serial console is empty.

Best wishes,

Artem


On Oct 21, 2012, Borislav Petkov wrote: 

> I don't think that's the problem - I rather suspect the fact that he's
> using virtualbox which is causing random corruptions by writing to
> arbitrary locations.
> 
> 
> 
> please remove virtualbox completely from your system, rebuild the kernel
> and make sure the virtualbox kernel modules don't get loaded - simply
> delete them so that they are completely gone; *and* *then* retest again.

