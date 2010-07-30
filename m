Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0G3QrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 12:47:13 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:28155 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab0G3QrM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 12:47:12 -0400
Date: Fri, 30 Jul 2010 18:48:41 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv5 2/3] USB: gadget: Use new composite features in some
 gadgets
In-reply-to: <231296.268.qm@web180308.mail.gq1.yahoo.com>
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <op.vgn0zfyq7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <231296.268.qm@web180308.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- On Wed, 7/28/10, Michal Nazarewicz <m.nazarewicz@samsung.com> wrote:
>> use the new features of composite framework.  Because it
>> handles default strings there is no longer the need for
>> the gadgets drivers to handle many of the strings.

On Fri, 30 Jul 2010 00:21:18 +0200, David Brownell <david-b@pacbell.net> wrote:
> The gadgets should always identify the same, and
> thus handle their strings -- *unless* module params
> are applied by users to override those defaults.

This is not how many gadgets seem to work at least as
far as the iManufacturer is concerned which is usually built
at run-time as "Linux <version> with <gadget-name>".

The patch does not change the behaviour of the gadget since all
it does is take advantage of code put in composite.c in the 1/2
patch.  Therefore, modified gadgets will still use the same
strings only code that handles string ID reservation is placed in
composite.c now (since it needs to be there to fix the module
parameters anyway).

>> -static unsigned short gfs_vendor_id    = 0x0525;    /* XXX NetChip */
>> -static unsigned short gfs_product_id   = 0xa4ac;    /* XXX */

> Look -- you can't assign NetChip numbers!!!

/me ashamed

Obviously, you're absolutely right.  I left the XXX mark to remember
to clear the situation with the IDs but then completely forgot about
it after g_multi got pulled. (It's especially bad since there is a
conflict with hid.c).

So, to fix the situation, I need to ask Greg for the IDs?

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
