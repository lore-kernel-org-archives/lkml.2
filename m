Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab1EYLLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 07:11:25 -0400
Received: from mail001.aei.ca ([206.123.6.130]:50134 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab1EYLLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 07:11:23 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Corey Boyle <corey.j.boyle@gmail.com>,
        Bluettooth Linux <linux-bluetooth@vger.kernel.org>
Subject: Re: Linux 2.6.39
Date: Wed, 25 May 2011 07:11:17 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.39-crc+; KDE/4.6.3; x86_64; ; )
Cc: ville.tervo@nokia.com, linux-kernel@vger.kernel.org
References: <BANLkTinG_qCtHQYRYFQUJ9oGv4H1cuznWg@mail.gmail.com>
In-Reply-To: <BANLkTinG_qCtHQYRYFQUJ9oGv4H1cuznWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105250711.17971.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 May 2011 06:54:54 Corey Boyle wrote:
> > On Mon, May 23, 2011 at 06:08:36PM -0400, ext Ed Tomlinson wrote:
> > > On Saturday 21 May 2011 16:31:00 Ed Tomlinson wrote:
> > > > On Saturday 21 May 2011 13:56:20 Milan Oravec wrote:
> > > > > Hi Linus, I'm sorry bothering you, but my usb-bluetooth dongle stop working in
> > > > > 2.6.39 kernel series.
> > > > > I know it is nothing ground breaking but it is bug.
> > > > > I'm using this hardware from 2.6.11 kernel series.
> > > > > Details are included in this thread:
> > > > >
> > > > > https://lkml.org/lkml/2011/4/18/481
> > > > >
> > > > > I hope I'm doing nothing false writing this email.
> > > >
> > > > Same device, same problem here.
> > > >
> > > > You are not alone
> > >
> > > I had some time this afternood so I tried bisecting without much luck.  I ended up \
> > > somewhere rc1 ish with a system that would paniced during boot.  Here is the bisect \
> > > log incase it helps:
> > > # bad: [61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf] Linux 2.6.39
> > > # good: [521cb40b0c44418a4fd36dc633f575813d59a43d] Linux 2.6.38
> > > git bisect start 'v2.6.39' 'v2.6.38' '--' 'drivers/bluetooth'
> > > # bad: [7a6362800cb7d1d618a697a650c7aaed3eb39320] Merge \
> > > git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6 git bisect bad \
> > > 7a6362800cb7d1d618a697a650c7aaed3eb39320 # bad: \
> > > [0a0e9ae1bd788bc19adc4d4ae08c98b233697402] Merge branch 'master' of \
> > > master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6 git bisect bad \
> > > 0a0e9ae1bd788bc19adc4d4ae08c98b233697402 # skip: \
> > > [03c2d0e89409b59c1ec9d9511533cedc0b7aaa69] Bluetooth: Use usb_fill_int_urb() git \
> > > bisect skip 03c2d0e89409b59c1ec9d9511533cedc0b7aaa69 # skip: \
> > > [7f4b2b04c88377af30c022f36c060190182850fb] Bluetooth: Make hci a child of the \
> > > corresponding tty device. git bisect skip 7f4b2b04c88377af30c022f36c060190182850fb
> > > # skip: [84f0e17f78471857104a20dfc57711409f68d7bf] Bluetooth: ath3k: Avoid \
> > > duplication of code git bisect skip 84f0e17f78471857104a20dfc57711409f68d7bf
> > >
> > > Ring any bells for anyone?
> > >
> > > Probably should open a regression bug for this too....
> >
> > I think this is regression with d5859e22cd40b73164b3e5d8d5d796f96edcc6af
> > commit. Probably the code tries to enable something that is not supported.
> >
> > Could you pastebin hcidump while doing hciconfig hci0 up?

hcidump
HCI sniffer - Bluetooth packet analyzer ver 2.0
device: hci0 snap_len: 1028 filter: 0xffffffffffffffff
< HCI Command: Reset (0x03|0x0003) plen 0
> HCI Event: Command Complete (0x0e) plen 4
    Reset (0x03|0x0003) ncmd 1
    status 0x00
< HCI Command: Read Local Supported Features (0x04|0x0003) plen 0
> HCI Event: Command Complete (0x0e) plen 12
    Read Local Supported Features (0x04|0x0003) ncmd 1
    status 0x00
    Features: 0xff 0xff 0x0f 0x00 0x00 0x00 0x00 0x00
< HCI Command: Read Local Version Information (0x04|0x0001) plen 0
> HCI Event: Command Complete (0x0e) plen 12
    Read Local Version Information (0x04|0x0001) ncmd 1
    status 0x00
    HCI Version: 1.1 (0x1) HCI Revision: 0x20d
    LMP Version: 1.1 (0x1) LMP Subversion: 0x20d
    Manufacturer: Cambridge Silicon Radio (10)
< HCI Command: Read Buffer Size (0x04|0x0005) plen 0
> HCI Event: Command Complete (0x0e) plen 11
    Read Buffer Size (0x04|0x0005) ncmd 1
    status 0x00
    ACL MTU 192:8 SCO MTU 64:8
< HCI Command: Read BD ADDR (0x04|0x0009) plen 0
> HCI Event: Command Complete (0x0e) plen 10
    Read BD ADDR (0x04|0x0009) ncmd 1
    status 0x00 bdaddr 00:0A:3A:55:07:5A
< HCI Command: Read Class of Device (0x03|0x0023) plen 0
> HCI Event: Command Complete (0x0e) plen 7
    Read Class of Device (0x03|0x0023) ncmd 1
    status 0x00 class 0x000000
< HCI Command: Read Local Name (0x03|0x0014) plen 0
> HCI Event: Command Complete (0x0e) plen 252
    Read Local Name (0x03|0x0014) ncmd 1
    status 0x00 name 'grover-0'
< HCI Command: Read Voice Setting (0x03|0x0025) plen 0
> HCI Event: Command Complete (0x0e) plen 6
    Read Voice Setting (0x03|0x0025) ncmd 1
    status 0x00 voice setting 0x0060
< HCI Command: Set Event Filter (0x03|0x0005) plen 1
    type 0 condition 0
    Clear all filters
> HCI Event: Command Complete (0x0e) plen 4
    Set Event Filter (0x03|0x0005) ncmd 1
    status 0x00
< HCI Command: Write Connection Accept Timeout (0x03|0x0016) plen 2
    timeout 32000
> HCI Event: Command Complete (0x0e) plen 4
    Write Connection Accept Timeout (0x03|0x0016) ncmd 1
    status 0x00
< HCI Command: Delete Stored Link Key (0x03|0x0012) plen 7
    bdaddr 00:00:00:00:00:00 all 1
> HCI Event: Command Complete (0x0e) plen 6
    Delete Stored Link Key (0x03|0x0012) ncmd 1
    status 0x00 deleted 0
< HCI Command: Set Event Mask (0x03|0x0001) plen 8
    Mask: 0xfffffbff00000000
> HCI Event: Command Complete (0x0e) plen 4
    Set Event Mask (0x03|0x0001) ncmd 1
    status 0x12
    Error: Invalid HCI Command Parameters

Thanks
Ed

> This sounds like it could be the same problem I mailed about here:
> http://marc.info/?l=linux-bluetooth&m=130610549726588&w=2.
> I still haven't determined why the HCI_OP_SET_EVENT_MASK command was failing.
> 
> Hope this helps!
> 
> 
