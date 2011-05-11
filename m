Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab1EKTbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:31:47 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:33354 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814Ab1EKTbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:31:22 -0400
Message-ID: <4DCAE408.4010205@msgid.tls.msk.ru>
Date: Wed, 11 May 2011 23:31:20 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Jiri Slaby <jslaby@suse.cz>, Linux-kernel <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>, stable@kernel.org,
        Wolfgang Walter <wolfgang.walter@stwm.de>
Subject: Re: apparent regression (crash) - 2.6.38.6
References: <4DC9983B.4070006@msgid.tls.msk.ru>  <4DCA2D14.3040500@suse.cz> <1305141557.2606.33.camel@mulgrave.site>
In-Reply-To: <1305141557.2606.33.camel@mulgrave.site>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11.05.2011 23:19, James Bottomley wrote:
> On Wed, 2011-05-11 at 08:30 +0200, Jiri Slaby wrote:
>> On 05/10/2011 09:55 PM, Michael Tokarev wrote:
>>> Hello.
>>>
>>> I just tried 2.6.38.6 (which has been released today), and
>>> discovered that it crashes during bootup on my machine.
>>> 2.6.38.5 with exactly the same config works.
>>
>> Is it reproducible?

Yes it is 100% reproducible on at least 2 of my machines,
happens on every boot.

>>> Unfortunately I don't have time _right now_ to debug the

>>> [  106.761932] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:12.1/usb2/2-2/2-2:1.0/input/input6
>>> [  106.762170] generic-usb 0003:046D:C044.0004: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:12.1-2/input0
>>> [  106.994177] scsi 10:0:0:0: Direct-Access     Kingston DT HyperX        HMAP PQ: 0 ANSI: 0 CCS
>>> [  106.994458] sd 10:0:0:0: Attached scsi generic sg3 type 0
>>> [  106.994628] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
>>> [  106.994755] IP: [<ffffffff811bec1b>] elv_queue_empty+0x1b/0x30
> 
> Hmm, it's another missing elevator guard, like this patch:
> 
> http://marc.info/?l=linux-scsi&m=130348673628282
> 
> I think the bug here is that q->elevator is null, so dereferencing
> elevator->ops gives the bug.

With that patch, both problem machines are now booting
ok here, so you can add my Tested-By line if you want.

I wonder why there's so many reports about this issue.

Speaking of elevator, I've "elevator=cfq" in kernel command
line, fwiw.


11.05.2011 11:58, Wolfgang Walter wrote:
> I got almost the same crash with 2.6.32.40 (whereas 2.6.32.39 worked)
> with a certain machine. It only (and always) happens if a certain usb-stick is
> attached when booting. Replacing it with another model "fixed" it.

I too have an usb storage adaptor here, but it's an internal
card reader connected to an onboard usb header.

What's common in both 2.6.38.6 and 2.6.32.40 series in this area?

Thank you!

/mjt
