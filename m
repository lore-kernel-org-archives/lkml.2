Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab0KIPFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:05:40 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44619 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751436Ab0KIPFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:05:38 -0500
Date: Tue, 9 Nov 2010 10:05:37 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
cc: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Developer support list for Wireshark 
	<wireshark-dev@wireshark.org>
Subject: Re: usbmon: size of different fields?
In-Reply-To: <4CD8ECE4.1090206@freemail.hu>
Message-ID: <Pine.LNX.4.44L0.1011091001210.1556-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, [UTF-8] Németh Márton wrote:

> Hi,
> 
> I'm looking at the struct mon_bin_hdr and struct mon_bin_isodesc in file
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/usb/mon/mon_bin.c;h=44cb37b5a4dc1f9b27075e3db5346b9ebe307b22;hb=HEAD
> 
> As far as I understand u64, s64, u32 and s32 have always fixed bit lengths.

That's right.

> What about "unsigned char", "char", "unsigned int" and "int"? May their size in bits
> differ in different architecture?

char and unsigned char are always 8 bits.  int and unsigned int are 
always 32 bits.  long and unsigned long can be either 32 or 64 bits, 
depending on the architecture.

> I'm asking this because I was dealing with the USB packet dissectors for Wireshark
> and it is possible to capture the USB traffic on one computer and then transfer
> the file to another computer.

There shouldn't be any trouble with the field sizes.  The endianness
could cause a problem, though.

Alan Stern

