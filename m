Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab3AJBVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 20:21:20 -0500
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:46593 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932323Ab3AJBVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 20:21:19 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Dan Williams <dcbw@redhat.com>, Lubomir Rintel <lkundrak@v3.sk>
CC: David Woodhouse <dwmw2@infradead.org>, Ben Hutchings <ben@decadent.org.uk>,
        "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 9 Jan 2013 17:20:46 -0800
Subject: RE: sd8688 firmware location
Thread-Topic: sd8688 firmware location
Thread-Index: Ac3uuq/5nS79KVprSkeEnUej1e6k2gAEoYiw
Message-ID: <477F20668A386D41ADCC57781B1F70430D13FDBA55@SC-VEXCH1.marvell.com>
References: <1357689361-7969-1-git-send-email-lkundrak@v3.sk>
 <1357771504.12030.59.camel@dcbw.foobar.com>
In-Reply-To: <1357771504.12030.59.camel@dcbw.foobar.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0A1LKbC011821

Hi Dan,

> > btmrvl_sdio and libertas_sdio both use firmware files sd8688.bin and
> > sd8688_helper.bin. In linux-firmware, they're present in libertas/ tree and
> > (since 3d32a58b) libertas_sdio perfers loading it from there, while it is able
> > to fallback to load it from linux-firmware root. btmrvl_sdio, on the other hand
> > only looks in the root and ends up not being successful.
> >
> > Obviously, there are two solutions to the problem -- either teach btmrvl_sdio
> > to look into libertas/, or move the files in linux-firmware tree. I don't
> > really have a strong preference, though it probably makes less sense to keep in
> > in libertas/, since the bluetooth hardware is not really marketed as "Libertas."
> >
> > I'm following up with patches to linux and linux-firmware and I'd be very
> > thankful if you could pick one (not both of them).
> 
> So the BT part and the wifi part have different SDIO IDs; are they
> actually connected separately to the SDIO bus?  Or is the chip only in
> one mode at one time or something like that?  Is there a problem with
> having both libertas and btmrvl loaded at the same time since they're
> essentially the same chip?

SD8688 is a combo chip with different device IDs for WLAN (function 1) and BT (function 2). WLAN + BT together are connected to the bus with a single SDIO interface. Both libertas and btmrvl drivers can be loaded at the same time, and WLAN & BT functions work concurrently. Of course the SDIO bus is shared between WLAN and BT.

The firmware image can be downloaded from host to device by either libertas or btmrvl driver whoever becomes the winner from firmware downloading perspective.

Regards,
Bing

> 
> I don't really mind moving stuff to mrvl/ out of libertas/ for these
> devices, but I do want some backwards compat code in libertas for that.
> Unless, of course, Marcel was talking about symlinks in the
> linux-firmware git tree, which would be fine with me.  The important
> point is that simply updating your linux-firmware package or install or
> whatever *should not* result in a failed firmware load.
> 
> Dan
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
