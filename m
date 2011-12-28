Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab1L1B2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 20:28:18 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59204 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab1L1B2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 20:28:15 -0500
Date: Tue, 27 Dec 2011 23:28:50 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: Rene Herman <rene.herman@gmail.com>
Cc: Andre Guedes <andre.guedes@openbossa.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [bluetooth] linux-3.x regression (bisected)
Message-ID: <20111228012850.GD13870@joana>
Mail-Followup-To: Rene Herman <rene.herman@gmail.com>,
	Andre Guedes <andre.guedes@openbossa.org>,
	linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
References: <4EF3BACA.1080405@gmail.com>
 <CACJA=fVezGGcgAtbzG=+ouWq0PiHbgXN1YPwL+VDUphWS7wnrw@mail.gmail.com>
 <4EFA1EB8.9090005@gmail.com>
 <20111227203008.GA13870@joana>
 <4EFA447C.3030906@gmail.com>
 <20111228012248.GC13870@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228012248.GC13870@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gustavo Padovan <padovan@profusion.mobi> [2011-12-27 23:22:48 -0200]:

> Hi Rene,
> 
> * Rene Herman <rene.herman@gmail.com> [2011-12-27 23:19:40 +0100]:
> 
> > On 27-12-11 21:30, Gustavo Padovan wrote:
> > 
> > >Seems your extfeatures is telling you something different from what it really
> > >supports. Can you try with the following diff (use the dynamic debug that Andre
> > >told you)
> > 
> > Attached. The result is "features: 0xff".
> > 
> > I suppose that (should) mean(s) "all features"; if that's not
> > actually a valid possibility due, perhaps, to undefined or mutually
> > exclusive bits then maybe it's an option to take 0xff to mean that
> > the adapter doesn't in fact support any of them?
> > 
> > >Also the output of hcidump would nice.
> > 
> > If the below (which is what hcidump spit back at me at some as far
> > as I could determine random moment) is not what you wanted, I
> > believe you will need to specify which action to take while
> > monitoring things with hcidump.
> > 
> > ==============
> > HCI sniffer - Bluetooth packet analyzer ver 2.1
> > device: hci0 snap_len: 1028 filter: 0xffffffff
> > < HCI Command: Reset (0x03|0x0003) plen 0
> > > HCI Event: Command Complete (0x0e) plen 4
> >     Reset (0x03|0x0003) ncmd 1
> >     status 0x00
> > < HCI Command: Read Local Supported Features (0x04|0x0003) plen 0
> > > HCI Event: Command Complete (0x0e) plen 12
> >     Read Local Supported Features (0x04|0x0003) ncmd 1
> >     status 0x00
> >     Features: 0xff 0xfe 0xff 0x7e 0x98 0x19 0x00 0x80
> > < HCI Command: Read Local Version Information (0x04|0x0001) plen 0
> > > HCI Event: Command Complete (0x0e) plen 12
> >     Read Local Version Information (0x04|0x0001) ncmd 1
> >     status 0x00
> >     HCI Version: 2.0 (0x3) HCI Revision: 0x2da
> >     LMP Version: 2.0 (0x3) LMP Subversion: 0x2da
> >     Manufacturer: Integrated System Solution Corp. (57)
> > < HCI Command: Read Buffer Size (0x04|0x0005) plen 0
> > > HCI Event: Command Complete (0x0e) plen 11
> >     Read Buffer Size (0x04|0x0005) ncmd 1
> >     status 0x00
> >     ACL MTU 1021:4 SCO MTU 48:10
> > < HCI Command: Read BD ADDR (0x04|0x0009) plen 0
> > > HCI Event: Command Complete (0x0e) plen 10
> >     Read BD ADDR (0x04|0x0009) ncmd 1
> >     status 0x00 bdaddr 00:11:67:C0:12:9E
> > < HCI Command: Read Class of Device (0x03|0x0023) plen 0
> > > HCI Event: Command Complete (0x0e) plen 7
> >     Read Class of Device (0x03|0x0023) ncmd 1
> >     status 0x00 class 0x000000
> > < HCI Command: Read Local Name (0x03|0x0014) plen 0
> > > HCI Event: Command Complete (0x0e) plen 252
> >     Read Local Name (0x03|0x0014) ncmd 1
> >     status 0x00 name 'ISSCEDRBTA'
> > < HCI Command: Read Voice Setting (0x03|0x0025) plen 0
> > > HCI Event: Command Complete (0x0e) plen 6
> >     Read Voice Setting (0x03|0x0025) ncmd 1
> >     status 0x00 voice setting 0x0060
> > < HCI Command: Set Event Filter (0x03|0x0005) plen 1
> >     type 0 condition 0
> >     Clear all filters
> > > HCI Event: Command Complete (0x0e) plen 4
> >     Set Event Filter (0x03|0x0005) ncmd 1
> >     status 0x00
> > < HCI Command: Write Connection Accept Timeout (0x03|0x0016) plen 2
> >     timeout 32000
> > > HCI Event: Command Complete (0x0e) plen 4
> >     Write Connection Accept Timeout (0x03|0x0016) ncmd 1
> >     status 0x00
> > < HCI Command: Delete Stored Link Key (0x03|0x0012) plen 7
> >     bdaddr 00:00:00:00:00:00 all 1
> > > HCI Event: Command Complete (0x0e) plen 6
> >     Delete Stored Link Key (0x03|0x0012) ncmd 1
> >     status 0x00 deleted 0
> > < HCI Command: Set Event Mask (0x03|0x0001) plen 8
> >     Mask: 0xfffffbff07180000
> > > HCI Event: Command Complete (0x0e) plen 4
> >     Set Event Mask (0x03|0x0001) ncmd 1
> >     status 0x00
> > < HCI Command: Read Local Supported Commands (0x04|0x0002) plen 0
> > > HCI Event: Command Complete (0x0e) plen 68
> >     Read Local Supported Commands (0x04|0x0002) ncmd 1
> >     status 0x00
> >     Commands: ffffef03ceffffffffffff9ff30fe8ff3c
> > < HCI Command: Write Inquiry Mode (0x03|0x0045) plen 1
> >     mode 1
> > > HCI Event: Command Complete (0x0e) plen 4
> >     Write Inquiry Mode (0x03|0x0045) ncmd 1
> >     status 0x00
> > < HCI Command: Read Local Extended Features (0x04|0x0004) plen 1
> >     page 1
> > > HCI Event: Command Complete (0x0e) plen 14
> >     Read Local Extended Features (0x04|0x0004) ncmd 1
> >     status 0x00 page 0 max 0
> >     Features: 0xff 0xfe 0xff 0x7e 0x98 0x19 0x00 0x80
> 
> For some reason your adapter is returning here the same value of Read Local
> Features. I would say your device is broken.  The only fix I have in mind now
> is throw away the device.

Yes, I have one of these ISSC devices, it's completely broken device. 

	Gustavo
