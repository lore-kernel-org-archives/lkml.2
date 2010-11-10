Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab0KJRhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:37:21 -0500
Received: from b.mail.sonic.net ([64.142.19.5]:59022 "EHLO b.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab0KJRhQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:37:16 -0500
Subject: Re: usbmon: size of different fields?
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=iso-8859-1
From: Guy Harris <guy@alum.mit.edu>
In-Reply-To: <20101110082123.2dc1d361@lembas.zaitcev.lan>
Date: Wed, 10 Nov 2010 09:36:58 -0800
Cc: Developer support list for Wireshark 
	<wireshark-dev@wireshark.org>,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <4F035C08-41FC-4898-93A2-96D86E3F31C1@alum.mit.edu>
References: <4CD8ECE4.1090206@freemail.hu> <20101109075056.59a2e7d8@lembas.zaitcev.lan> <4CD9A96D.1010306@freemail.hu> <E6FD75ED-7E13-47DC-B9F9-6C8C09C3C4AC@alum.mit.edu> <20101110082123.2dc1d361@lembas.zaitcev.lan>
To: Pete Zaitcev <zaitcev@redhat.com>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 10, 2010, at 7:21 AM, Pete Zaitcev wrote:

> On Tue, 9 Nov 2010 13:23:28 -0800
> Guy Harris <guy@alum.mit.edu> wrote:
>> On Nov 9, 2010, at 12:05 PM, Németh Márton wrote:
>> 
>>> OK, that's clear, the byte order of the API structure fields are in "host endian"
>>> order. The API structures are already saved by Wireshark into file for quite some
>>> time.
>> 
>> ...and tcpdump.  Support for capturing on USB on Linux has been in
>> libpcap since at least libpcap 1.0.
> 
> I imagined that Nemeth wanted to implement an alternative to that.

I hadn't heard him propose that.

It might be a good idea...

> Surely he knows how libpcap works. In that case a new, host-independent
> format may be introduced.

...and, if done, it would be ideal if it were also designed to be platform-dependent, so that it didn't have Linux implementation details leaking through; that could let it be used if other platforms offer a way to watch USB operations.

Are the formats of the USB header and the isochronous descriptors guaranteed never to change?  If not, a new format should definitely be introduced, as, for example, with the mmapped buffer, we just pass to the capture callback a pointer to the item in that buffer.  However, given that the capture callback is just passed a single pointer to the packet data, access to the mmapped buffer would have to be done by constructing the new header in a mallocated buffer *AND* all the packet data will have to be copied to that buffer, so a lot more data copying will be done.