Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab0KIUFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:05:09 -0500
Received: from relay02.digicable.hu ([92.249.128.188]:48317 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab0KIUFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:05:06 -0500
Message-ID: <4CD9A96D.1010306@freemail.hu>
Date: Tue, 09 Nov 2010 21:05:01 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Pete Zaitcev <zaitcev@redhat.com>
CC: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Developer support list for Wireshark 
	<wireshark-dev@wireshark.org>
Subject: Re: usbmon: size of different fields?
References: <4CD8ECE4.1090206@freemail.hu> <20101109075056.59a2e7d8@lembas.zaitcev.lan>
In-Reply-To: <20101109075056.59a2e7d8@lembas.zaitcev.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 94.21.97.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pete Zaitcev wrote:
> On Tue, 09 Nov 2010 07:40:36 +0100
> Németh Márton <nm127@freemail.hu> wrote:
> 
>> I'm looking at the struct mon_bin_hdr and struct mon_bin_isodesc in file
>> f=drivers/usb/mon/mon_bin.c
> 
> Actually you're supposed to be looking at Documentation/usb/usbmon.txt.
> If there is a discrepancy between the usbmon.txt and mon_bin.c, I want
> to know about it.

There is only minor differences between Documentation/usb/usbmon.txt and
drivers/usb/mon/mon_bin.c . These are as follows:
 - the busnum field is u16 in txt and "unsigned short" in c file
 - the field "length" (in txt) has different name "len_urb" (in c)

The ISO description structure is missing from the txt description but
this can be found in drivers/usb/mon/mon_bin.c .

>> As far as I understand u64, s64, u32 and s32 have always fixed bit lengths.
>>
>> What about "unsigned char", "char", "unsigned int" and "int"? May their size in bits
>> differ in different architecture?
> 
> No they may not. They sizes are always the same on any architecture,
> as long as Linux supports it.

So to summarize, the following table is valid on all architectures. Right?

  type in Linux  | size in bits
  ---------------+---------------
  unsigned char  | 8bit
  char           | 8bit
  unsigned int   | 32bit
  int            | 32bit

>> I'm asking this because I was dealing with the USB packet dissectors for Wireshark
>> and it is possible to capture the USB traffic on one computer and then transfer
>> the file to another computer.
> 
> Do be careful here, because the struct you're talking about is a part
> of API, not a network stream. Its field sizes are rigidly defined, but
> the byte order is host! You MUST NOT attempt to store it in pcap files.

OK, that's clear, the byte order of the API structure fields are in "host endian"
order. The API structures are already saved by Wireshark into file for quite some
time. There is already a discussion on endianness topic together with ISO descritors:

  Wireshark Bug 5370 - Add support for USB isochronous
  https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=5370

There is an other problem which I found about capturing ISO USB packets with
mmap, this problem seems to be originated from Linux kernel:

  Kernel Bug Tracker Bug 22182 - usbmon: completed ISO packet content is not fully arriving with mmap
  https://bugzilla.kernel.org/show_bug.cgi?id=22182

	Márton Németh
