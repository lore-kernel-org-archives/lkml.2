Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab1DKXbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 19:31:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57428 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab1DKXbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 19:31:13 -0400
MIME-Version: 1.0
In-Reply-To: <20110409130945.GC3248@prithivi.gnumonks.org>
References: <BANLkTik1wb6Px+K+bBkzkt=dEMi_Xx3T3Q@mail.gmail.com>
	<20110409130945.GC3248@prithivi.gnumonks.org>
Date: Mon, 11 Apr 2011 20:31:11 -0300
Message-ID: <BANLkTinTXNby_zc7yz29hAdRmNK3rRht9A@mail.gmail.com>
Subject: Re: [RFC] NFC subsystem prototype
From: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
To: Harald Welte <laforge@gnumonks.org>
Cc: linux-kernel@vger.kernel.org,
        Aloisio Almeida <aloisio.almeida@openbossa.org>,
        Arnd Bergmann <arnd@arndb.de>, Waldemar.Rymarkiewicz@tieto.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harald,

2011/4/9 Harald Welte <laforge@gnumonks.org>:
> Hi Lauro,
>
> On Wed, Apr 06, 2011 at 07:17:19PM -0300, Lauro Ramos Venancio wrote:
>> As previously mentioned in this list, a NFC (Near Field Communication)
>> subsystem is required to standardize the NFC device drivers
>> development and create an unified userspace interface. This email
>> describes our NFC subsystem proposal.
>
> given that I've done quite some work on RFID (mifare, iso14443) and NFC
> software + hardware some years ago, here is some feedback from my side:
>
> 0) why not create a general RFID subsystem instead of locking it down to
>   NFC?  NFC is sort-of a superset of ISO 14443, so it would make more
>   sense to have a generic framework that can support not only Mifare + NFC
>   but all types of ISO 14443 (A / B) as well as ISO 15693.  This would mean
>   other applications like electronic ID cards and ICAO-compliant passports
>   would fit into the picture - even though not being NFC

The prototype supports ISO 14443 (A/B), MIFARE, Felica and Jewel. It's
straightforward to add ISO 15693 support. So I think it is possible to
support these applications using the NFC subsystem.

>
> 1) do you really think a kernel subsystem is the best idea for this?
>   normally, the RFID/NFC ASIC is attached either to USB or serial lines,
>   and there are no timing constraints against userspace drivers using libusb,
>   like the existing libnfc or librfid.
>
>   Yes, there may be multiple applications using RFID/NFC services, but
>   if you look at e.g. the smart card frameworks like OpenCT and/or pcsc-lite,
>   they can do that very well in userspace, without any kernel support.
>
>   If you're worried about SPI-attached RFID/NFC ASICs, then I think the
>   propper approach is to have a generic support for exporting SPI devices to
>   userspace (similar to what we have with usb + libusb).
>
>   I simply do not see the advantage of having this in the kenrel.  There are
>   no latency/timing constraints, and the amount of data you are moving is so
>   small, that performance considerations also don't really play any role.

The advantages appear when you consider the NFC peer-to-peer use case
(LLCP). A socket interface for LLCP would fit better for implementing
some features, such as OBEX over LLCP and IP over LLCP.
The prototype implements in the kernel the minimal set of operations
that will be required by a future LLCP implementation. The same set of
operations are used by userspace applications to implements tag
read/write.



Regards,

Lauro Ramos Venancio
INdT - Instituto Nokia de Tecnologia
