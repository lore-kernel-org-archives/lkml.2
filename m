Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab0JKHON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 03:14:13 -0400
Received: from mail.atheros.com ([12.19.149.2]:52637 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab0JKHOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 03:14:12 -0400
Date: Mon, 11 Oct 2010 12:44:09 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@atheros.com>
CC: Suraj Sumangala <Suraj.Sumangala@atheros.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Firmware versioning best practices: ath3k-2.fw rename or
 replace ath3k-1.fw ?
Message-ID: <20101011071409.GA2640@senthil-lnx.users.atheros.com>
References: <20101008170258.GJ10149@tux>
 <1286611288.6145.430.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1286611288.6145.430.camel@aeonflux>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 01:31:28PM +0530, Marcel Holtmann wrote:
> Hi Luis,
> 
> > What is the difference between ath3k-2.fw and ath3k-1.fw ?
> > 
> > Won't the API change now that you are addressing the sflash
> > configuration fix? Would it not help to identify the two
> > different firmwares then?
> > 
> > David, Marcel, what are your preferences for a firmware upgrade
> > where the firmware does not change API (lets just pretend it does
> > not for a moment) ? Do we keep the same filename?
> 
> that is what most companies do and that is what iwlwifi has done so far.
Luis

this is what we have been doing for our ath9k_htc driver. We kept the same
fie name for firmware updates as we haven't changed any APIs/interfaces that
host driver depends on.

> Only if the API breaks a different suffix is used.
> 
> With Bluetooth this should be never needed at all. The reason is that
> you need to expose Bluetooth HCI. And that has generic version, support
> commands and supported features commands.
> 
> We are not even using the version information for anything useful these
> days since the firmware has to identify its features and its supported
> commands with standard HCI commands. So it is pretty simple to detect
> what Bluetooth subsystem needs to do.
> 
> > In this particular case I would assume our new sflash configuration
> > fix that might be being worked on might change the re-enumerated
> > USB device IDs so it seems to me a good idea to use a new filename.
> > I should note ath3k-2.fw already made it to linux-firmware.git...
> 
> No it does not. The changed PID is not a breakage. It will just keep
> working. So please fix this in linux-firmware.git right away and remove
> the new firmware file.
> 
> And here is something that is wrong with your process as well. Don't
> submit firmware files upstream before the upstream maintainers accepted
> your driver or patch.
> 
> I know it is nice to have the firmware available quickly, but if your
> driver gets rejected for the reason we have stated in this thread, you
> have dangling firmware somewhere.
> 
> > I last tried to document a thread we had over this here:
> > 
> > http://wireless.kernel.org/en/developers/Documentation/firmware-versioning
> > 
> > Does this sound sane? If so then the sflash configuration fix
> > would seem to me like it would require a new filename. Now, while
> > we're at it, how about bug fixes?
> 
> If your firmware files are identical and the exposed API is identical
> (in this case Bluetooth HCI), then you do NO need a new filename.
> 
> Regards
> 
> Marcel
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
