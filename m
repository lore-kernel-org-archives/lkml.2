Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab0JIIBm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 04:01:42 -0400
Received: from senator.holtmann.net ([87.106.208.187]:47116 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab0JIIBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 04:01:40 -0400
Subject: Re: Firmware versioning best practices: ath3k-2.fw rename or
 replace ath3k-1.fw ?
From: Marcel Holtmann <marcel@holtmann.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Suraj Sumangala <Suraj.Sumangala@atheros.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20101008170258.GJ10149@tux>
References: <20101008170258.GJ10149@tux>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 09 Oct 2010 10:01:28 +0200
Message-ID: <1286611288.6145.430.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

> What is the difference between ath3k-2.fw and ath3k-1.fw ?
> 
> Won't the API change now that you are addressing the sflash
> configuration fix? Would it not help to identify the two
> different firmwares then?
> 
> David, Marcel, what are your preferences for a firmware upgrade
> where the firmware does not change API (lets just pretend it does
> not for a moment) ? Do we keep the same filename?

that is what most companies do and that is what iwlwifi has done so far.
Only if the API breaks a different suffix is used.

With Bluetooth this should be never needed at all. The reason is that
you need to expose Bluetooth HCI. And that has generic version, support
commands and supported features commands.

We are not even using the version information for anything useful these
days since the firmware has to identify its features and its supported
commands with standard HCI commands. So it is pretty simple to detect
what Bluetooth subsystem needs to do.

> In this particular case I would assume our new sflash configuration
> fix that might be being worked on might change the re-enumerated
> USB device IDs so it seems to me a good idea to use a new filename.
> I should note ath3k-2.fw already made it to linux-firmware.git...

No it does not. The changed PID is not a breakage. It will just keep
working. So please fix this in linux-firmware.git right away and remove
the new firmware file.

And here is something that is wrong with your process as well. Don't
submit firmware files upstream before the upstream maintainers accepted
your driver or patch.

I know it is nice to have the firmware available quickly, but if your
driver gets rejected for the reason we have stated in this thread, you
have dangling firmware somewhere.

> I last tried to document a thread we had over this here:
> 
> http://wireless.kernel.org/en/developers/Documentation/firmware-versioning
> 
> Does this sound sane? If so then the sflash configuration fix
> would seem to me like it would require a new filename. Now, while
> we're at it, how about bug fixes?

If your firmware files are identical and the exposed API is identical
(in this case Bluetooth HCI), then you do NO need a new filename.

Regards

Marcel


