Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab1JVCCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 22:02:04 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:47847 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab1JVCCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 22:02:03 -0400
Date: Sat, 22 Oct 2011 04:02:05 +0200
From: Nico Schottelius <nico-linux-20111017@schottelius.org>
To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
        Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Keyboard and mouse issues on MacBook Air (4,2)
Message-ID: <20111022020205.GA26724@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
	Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
References: <20111017175906.GA3461@schottelius.org>
 <alpine.LRH.2.00.1110172015050.3869@twin.jikos.cz>
 <20111017214050.GA1408@schottelius.org>
 <20111019150122.GA6157@schottelius.org>
 <alpine.LNX.2.00.1110191702470.3541@pobox.suse.cz>
 <20111019210742.GA2432@schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019210742.GA2432@schottelius.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jiri,

I've found the problematic block in drivers/hid/hid-apple.c:180:

180    if (fnmode) {
181       int do_translate;
182 
183       if (hid->product >= USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI &&
184             hid->product <= USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS)
185          table = macbookair_fn_keys;
186       else if (hid->product >= USB_DEVICE_ID_APPLE_WELLSPRING6_ANSI &&
187             hid->product <= USB_DEVICE_ID_APPLE_WELLSPRING6_JIS)
188          table = macbookair_fn_keys;
189       else if (hid->product < 0x21d || hid->product >= 0x300)
190          table = powerbook_fn_keys;
191       else
192          table = apple_fn_keys;

The second range (186-188) specified matches my MacBookAir, which needs the new table I defined
in my previous commit: My device matches USB_DEVICE_ID_APPLE_WELLSPRING6_ISO (024D):

[    2.639063] apple 0003:05AC:024D.0001: input,hidraw0: USB HID v1.11 Keyboard [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1a.7-1.2/input0
[    2.694742] usb 2-1.1: new high speed USB device number 3 using ehci_hcd
[    2.736895] apple 0003:05AC:024D.0002: hidraw1: USB HID v1.11 Device [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1a.7-1.2/input1

The question for me is know, which range matches to the table I am using
and which range maps to the original table.

I know that the MacBook Air 3,1 must use the old table, so I IMAGINE this is
the first block (183-185).

So my next guess is that MBA 3,1 - 3,2 need to use the first table, while MBA 4,1 - 4,2 need
the second one.

Can you verify my assumption or do you have any hints on how the MacBook Airs and
the Keyboard layouts match? 

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
