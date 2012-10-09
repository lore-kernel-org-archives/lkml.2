Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab2JIKQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 06:16:03 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:52593 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752216Ab2JIKQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 06:16:00 -0400
MIME-Version: 1.0
In-Reply-To: <50732C91.20005@gmail.com>
References: <1348222894-6767-1-git-send-email-nlopezcasad@logitech.com>
 <20120923102318.GA12946@entuzijast.net> <CAE7qMroQOxo7kci7roLbS5HXjpkyhRi=cj1WCoYtAPB328xNQg@mail.gmail.com>
 <20120927070426.GA27734@entuzijast.net> <20120927185628.GA30949@entuzijast.net>
 <CAE7qMrrjeMBzfofaY+2O4CAh3OSDaK3fDe_c8Hh8Y2web7kUqQ@mail.gmail.com> <50732C91.20005@gmail.com>
From: Nestor Lopez Casado <nlopezcasad@logitech.com>
Date: Tue, 9 Oct 2012 12:15:28 +0200
Message-ID: <CAE7qMrraUD6-4KWVJfLV5-fDNWHhoGDFOx4r9RuLFG5m1sarwQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] HID: Fix missing Unifying device issue
To: Apostolos Bartziokas <barz621@gmail.com>
Cc: Josip Rodin <joy@debbugs.entuzijast.net>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        685360@bugs.debian.org, john.ettedgui@gmail.com,
        dh.herrmann@googlemail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Apostolos,

Your problem is unrelated to hid-logitech-dj. This seems an usb driver
issue. It seems that your motherboard has different usb controllers
for the rear and front ports. There may be an issue with the usb
drivers for the xhci controllers.

Cheers,
Nestor.

On Mon, Oct 8, 2012 at 9:42 PM, Apostolos Bartziokas <barz621@gmail.com> wrote:
>
> Nestor hello
>
> Sorry for bringing this up again but i tested the patch now that it
> reached the stable kernels and when i connect it to the rear panel of my
> motherboard i get:
>
> Oct 08 22:11:43 mainland kernel: usb 3-2: >USB disconnect, device number 2
> Oct 08 22:12:04 mainland kernel: usb 1-2: >new full-speed USB device
> number 3 using xhci_hcd
> Oct 08 22:12:05 mainland kernel: logitech-djreceiver 0003:046D:C52B.0009:
> >hiddev0,hidraw2: USB HID v1.11 Device [Logitech USB Receiver] on
> usb-0000:00:14.0-2/input2
> Oct 08 22:12:05 mainland kernel: logitech-djreceiver 0003:046D:C52B.0009:
> >logi_dj_probe:logi_dj_recv_query_paired_devices error:-32
> Oct 08 22:12:05 mainland kernel: logitech-djreceiver: probe of
> 0003:046D:C52B.0009 failed with error -32
> Oct 08 22:13:50 mainland kernel: usb 1-2: >USB disconnect, device number 3
> Oct 08 22:13:57 mainland kernel: usb 5-1.6: >new full-speed USB device
> number 3 using ehci_hcd
> Oct 08 22:13:58 mainland kernel: logitech-djreceiver 0003:046D:C52B.000C:
> >hiddev0,hidraw2: USB HID v1.11 Device [Logitech USB Receiver] on
> usb-0000:00:1a.0-1.6/input2
> Oct 08 22:14:01 mainland kernel: input: Logitech Unifying Device. Wireless
> PID:101a as
> /devices/pci0000:00/0000:00:1a.0/usb5/5-1/5-1.6/5-1.6:1.2/0003:046D:C52B.000C/input/input15
> Oct 08 22:14:01 mainland kernel: logitech-djdevice 0003:046D:C52B.000D:
> >input,hidraw3: USB HID v1.11 Mouse [Logitech Unifying Device. Wireless
> PID:101a] on usb-0000:00:1a.0-1.6:1
> Oct 08 22:14:17 mainland kernel: usb 5-1.6: >USB disconnect, device number
> 3
> Oct 08 22:14:20 mainland kernel: usb 1-2: >new full-speed USB device
> number 4 using xhci_hcd
> Oct 08 22:14:20 mainland kernel: logitech-djreceiver 0003:046D:C52B.0010:
> >hiddev0,hidraw2: USB HID v1.11 Device [Logitech USB Receiver] on
> usb-0000:00:14.0-2/input2
> Oct 08 22:14:20 mainland kernel: logitech-djreceiver 0003:046D:C52B.0010:
> >logi_dj_probe:logi_dj_recv_query_paired_devices error:-32
> Oct 08 22:14:20 mainland kernel: logitech-djreceiver: probe of
> 0003:046D:C52B.0010 failed with error -32
>
> When i use a usb3 port it doesn't move at all and if i use a usb2 port its
> slow. When i use the front panel it works flawlessly. Could this be related
> to my POS Intel motherboard?
>
> Kind regards and apologies if i raise a false alarm.
>
> Apostolos B.
> On 09/28/2012 10:57 AM, Nestor Lopez Casado wrote:
>
> Hello Josip,
>
> This really looks like a different problem from the one addressed with
> this patch.
>
> I'll try to work on it as soon as I find some time for that.
>
> Thanks,
> Nestor.
>
> On Thu, Sep 27, 2012 at 8:56 PM, Josip Rodin <joy@debbugs.entuzijast.net>
> wrote:
>>
>> On Thu, Sep 27, 2012 at 09:04:26AM +0200, Josip Rodin wrote:
>> > On Mon, Sep 24, 2012 at 11:30:28AM +0200, Nestor Lopez Casado wrote:
>> > > Josip, this is a different issue from the one addressed with the
>> > > patch.
>> > >
>> > > 1) Can you try it on a 3.2 kernel ?
>> >
>> > I can try that too, I'll let you know how it went.
>>
>> Same thing, it doesn't work.
>>
>> --
>>      2. That which causes joy or happiness.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-input" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
