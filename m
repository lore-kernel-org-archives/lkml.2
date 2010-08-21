Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab0HURcr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 13:32:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57119 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab0HURcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 13:32:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=mfzDipVU7qt7ITEl0kWKl/HSb7oKAsBqowdJdgMce+no/bfNaKf3M4dAIQ2tW8UAkn
         pyJI1TVduCfwzHwVrE50wyzhxmkJ5VQ97bHxpY/5+9FaG0ZYiESfbuvYdzTLAl/zTlnH
         V/a7dqN7OTXG0wJJ6xhL9s5c98mBV1S7wIr4c=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-arm-kernel@lists.infradead.org
Subject: Re: 2.6.36-rc1 on zaurus: bluetooth regression
Date: Sat, 21 Aug 2010 19:32:05 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-bluetooth@vger.kernel.org
References: <20100821152445.GA1536@ucw.cz>
In-Reply-To: <20100821152445.GA1536@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008211932.05481.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne So 21. srpna 2010 17:24:45 Pavel Machek napsal(a):
> Hi!
> 
> Good news is that it boots, suspends and resumes.
> 
> Bad news is that bluetooth broke for me. I'm using CF bluetooth
> card.
> 
> Socket 0 Bridge:   	[pxa2xx-pcmcia] 	(bus ID: pxa2xx-pcmcia)
> 	Configuration:	state: on	ready: yes
> 			Voltage: 3.3V Vcc: 3.3V Vpp: 0.0V
> Socket 0 Device 0:	[serial_cs]		(bus ID: 0.0)
> 	Configuration:	state: on
> 	Product Name:   Compact Flash Bluetooth Card
> 	Identification:	manf_id: 0x0279	card_id: 0x950b
> 			function: 2 (serial)
> 			prod_id(1): "Compact Flash" (0x95521410)
> 			prod_id(2): "Bluetooth Card" (0x7664fb1d)
> 			prod_id(3): --- (---)
> 			prod_id(4): --- (---)
> Socket 1 Bridge:   	[pxa2xx-pcmcia] 	(bus ID: pxa2xx-pcmcia)
> 	Configuration:	state: on	ready: yes
> 			Voltage: 3.3V Vcc: 3.3V Vpp: 0.0V
> Socket 1 Device 0:	[ide-cs]		(bus ID: 1.0)
> 	Configuration:	state: on
> 	Product Name:   HITACHI microdrive
> 	Identification:	manf_id: 0x0319	card_id: 0x0000
> 			function: 4 (fixed disk)
> 			prod_id(1): "HITACHI" (0xf4f43949)
> 			prod_id(2): "microdrive" (0xa6d76178)
> 			prod_id(3): --- (---)
> 			prod_id(4): --- (---)
> 
> 
> In 2.6.35, I have lots of messages in the syslog, and speed is slow,
> but it works.
> 
> Aug 19 08:01:06 toy kernel: bcsp_recv: Out-of-order packet arrived, got 3
> expected 2 Aug 19 08:01:06 toy kernel: bcsp_recv: Out-of-order packet
> arrived, got 4 expected 2 Aug 19 08:01:11 toy kernel: bcsp_recv: Short
> BCSP packet
> Aug 19 08:01:11 toy kernel: bcsp_recv: Out-of-order packet arrived, got 3
> expected 2 Aug 19 08:01:11 toy kernel: bcsp_recv: Out-of-order packet
> arrived, got 4 expected 2 Aug 19 08:01:12 toy kernel: bcsp_recv:
> Out-of-order packet arrived, got 5 expected 2 Aug 19 08:01:16 toy kernel:
> bcsp_recv: Short BCSP packet
> Aug 19 08:01:16 toy kernel: bcsp_recv: Out-of-order packet arrived, got 2
> expected 1 Aug 19 08:01:16 toy kernel: bcsp_recv: Out-of-order packet
> arrived, got 3 expected 1 Aug 19 08:01:16 toy kernel: bcsp_recv:
> Out-of-order packet arrived, got 4 expected 1
> 
> In 2.6.36-rc1, I get:
> 
> Aug 20 08:38:27 toy bluetoothd[1318]: HCI dev 0 down
> Aug 20 08:38:27 toy bluetoothd[1318]: Adapter /org/bluez/1318/hci0 has been
> disabled Aug 20 08:38:27 toy bluetoothd[1318]: Stopping security manager 0
> Aug 20 08:38:27 toy kernel: pcmcia_socket pcmcia_socket0: pccard: card
> ejected from slot 0 Aug 20 08:38:27 toy kernel: PM: Removing info for
> pcmcia:0.0
> Aug 20 08:38:27 toy kernel: PM: Removing info for No Bus:ttyS0
> Aug 20 08:38:27 toy bluetoothd[1318]: HCI dev 0 unregistered
> Aug 20 08:38:27 toy bluetoothd[1318]: Unregister path: /org/bluez/1318/hci0
> Aug 20 08:38:27 toy kernel: PM: Removing info for No Bus:hci0
> Aug 20 08:38:27 toy kernel: PM: Adding info for No Bus:ttyS0
> Aug 20 08:38:31 toy kernel: pcmcia_socket pcmcia_socket0: pccard: PCMCIA
> card inserted into slot 0 Aug 20 08:38:31 toy kernel: pcmcia 0.0: pcmcia:
> registering new device pcmcia0.0 (IRQ: 201) Aug 20 08:38:31 toy kernel:
> PM: Adding info for pcmcia:0.0
> Aug 20 08:38:31 toy kernel: PM: Removing info for No Bus:ttyS0
> Aug 20 08:38:31 toy kernel: 0.0: ttyS0 at I/O 0xc48402f8 (irq = 201) is a
> 16C950/954 Aug 20 08:38:31 toy kernel: PM: Adding info for No Bus:ttyS0
> Aug 20 08:38:36 toy bluetoothd[1318]: HCI dev 0 registered
> Aug 20 08:38:36 toy kernel: PM: Adding info for No Bus:hci0
> Aug 20 08:38:36 toy kernel: bcsp_recv: Out-of-order packet arrived, got 1
> expected 0 Aug 20 08:38:37 toy bluetoothd[1318]: accept: Socket operation
> on non-socket (88) Aug 20 08:38:37 toy bluetoothd[1318]: HCI dev 0 up
> Aug 20 08:38:37 toy bluetoothd[1318]: Starting security manager 0
> Aug 20 08:38:37 toy kernel: bcsp_recv: Short BCSP packet
> Aug 20 08:38:39 toy kernel: PM: Removing info for No Bus:rfcomm1
> Aug 20 08:38:39 toy kernel: PM: Adding info for No Bus:rfcomm1
> Aug 20 08:38:40 toy pand[1546]: Bluetooth PAN daemon version 4.66
> Aug 20 08:38:40 toy pand[1546]: Connecting to 00:21:BA:FF:2D:37
> Aug 20 08:38:40 toy kernel: hci_cmd_task: hci0 command tx timeout
> Aug 20 08:38:42 toy bluetoothd[1318]: Can't read version info for
> /org/bluez/1318/hci0: Connection timed out (110) Aug 20 08:38:44 toy
> modprobe: FATAL: Could not load /lib/modules/2.6.36-rc1/modules.dep: No
> such file or directory
> 
> Any ideas?
> 							Pavel

Could it be due to the PCMCIA timings changes on pxa I did? Try reverting that 
change and retry.
