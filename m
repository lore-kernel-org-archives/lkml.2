Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab0JIIG5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 04:06:57 -0400
Received: from senator.holtmann.net ([87.106.208.187]:39597 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab0JIIGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 04:06:53 -0400
Subject: Re: Firmware versioning best practices: ath3k-2.fw rename or
 replace ath3k-1.fw ?
From: Marcel Holtmann <marcel@holtmann.org>
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Suraj Sumangala <Suraj.Sumangala@atheros.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1010090040240.19472@aurora.sdinet.de>
References: <20101008170258.GJ10149@tux> <4CAF5488.3030706@Atheros.com>
	 <20101008181508.GM10149@tux>
	 <alpine.DEB.2.02.1010090040240.19472@aurora.sdinet.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 09 Oct 2010 10:06:39 +0200
Message-ID: <1286611599.6145.435.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sven-Haeger,

> > > > I last tried to document a thread we had over this here:
> > > >
> > > > http://wireless.kernel.org/en/developers/Documentation/firmware-versioning
> > > >
> > 
> > Thanks, I've updated that link above to document bug fixing does not require
> > a filename change.
> 
> I would summarize it as:
> 
> If a new firmware version also works with an old driver, keep the filename.

correct.

> If a new firmware version also requires a new driver, change the name.
> 
> If a new driver requires a new firmware, change the name.

These two depend. The exposed API stays the same. The firmware file
itself is the same. Just the loading procedure is different. So no need
to change the firmware name.

Let me repeat this. If the API of the firmware exposed after loading it,
breaks or is incompatible, then you need a new name.

If you have generic commands to detect features in the firmware, then
you should never be needed to change your firmware name. So you could
extend the API as much as you like with keeping the same name.

The different firmware names are for the driver to be able to detect the
API of the firmware. And only if that is only possible via the filename
you should use different filenames. Otherwise don't bother and use the
generic feature detection of the firmware itself.

And for Bluetooth in specific that is HCI. So any company needed
different firmware filenames for Bluetooth have done something really
really wrong in their development cycles.

Regards

Marcel


