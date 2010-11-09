Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab0KIOud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 09:50:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab0KIOub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 09:50:31 -0500
Date: Tue, 9 Nov 2010 07:50:56 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Developer support list for Wireshark 
	<wireshark-dev@wireshark.org>,
        zaitcev@redhat.com
Subject: Re: usbmon: size of different fields?
Message-ID: <20101109075056.59a2e7d8@lembas.zaitcev.lan>
In-Reply-To: <4CD8ECE4.1090206@freemail.hu>
References: <4CD8ECE4.1090206@freemail.hu>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Nov 2010 07:40:36 +0100
Németh Márton <nm127@freemail.hu> wrote:

> I'm looking at the struct mon_bin_hdr and struct mon_bin_isodesc in file
> f=drivers/usb/mon/mon_bin.c

Actually you're supposed to be looking at Documentation/usb/usbmon.txt.
If there is a discrepancy between the usbmon.txt and mon_bin.c, I want
to know about it.

> As far as I understand u64, s64, u32 and s32 have always fixed bit lengths.
> 
> What about "unsigned char", "char", "unsigned int" and "int"? May their size in bits
> differ in different architecture?

No they may not. They sizes are always the same on any architecture,
as long as Linux supports it.

> I'm asking this because I was dealing with the USB packet dissectors for Wireshark
> and it is possible to capture the USB traffic on one computer and then transfer
> the file to another computer.

Do be careful here, because the struct you're talking about is a part
of API, not a network stream. Its field sizes are rigidly defined, but
the byte order is host! You MUST NOT attempt to store it in pcap files.

-- Pete
