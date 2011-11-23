Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab1KWHRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 02:17:11 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42366 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab1KWHRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 02:17:09 -0500
MIME-Version: 1.0
In-Reply-To: <20111122222730.GM24283@suse.de>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
	<1321999366-23784-14-git-send-email-corentincj@iksaif.net>
	<20111122222730.GM24283@suse.de>
Date: Wed, 23 Nov 2011 08:17:08 +0100
Message-ID: <CAHR064igjTPmeeXrnO2BxNn_U0RXiw9fVJnERYj6f_Y1tChM0w@mail.gmail.com>
Subject: Re: [PATCH 13/15] samsung-laptop: make the dmi check less strict
From: Corentin Chary <corentin.chary@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:27 PM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Nov 22, 2011 at 11:02:44PM +0100, Corentin Chary wrote:
>> This enable the driver for everything that look like
>> a laptop and is from vendor "SAMSUNG ELECTRONICS CO., LTD.".
>> Note that laptop supported by samsung-q10 seem to have a different
>> vendor strict.
>>
>> Also remove every log output until we know that we have a SABI interface
>> (except if the driver is forced to load, or debug is enabled).
>>
>> Keeping a whitelist of laptop with a model granularity is something that can't
>> work without close vendor cooperation (and we don't have that).
>>
>> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
>
> Oh, this is bold.
>
> I would like to see this work, but I would need to see it tested on a
> bunch of machines before I trust it.
>
> I guess you now have the acpi video backlight check, which is good, but
> again, doesn't work for all devices.
>
> And yeah, a whitelist is tough, especially as the vendor isn't working
> with us at all, but I don't want to break machines that don't need this
> driver (and there are some, although I thought the newest ones would not
> need it, but that might be true.)

Here is what the driver does with the patch:
- automatically load the driver and each machine with vendor =
"SAMSUNG ELECTRONICS CO., LTD." and type looks like a laptop or
netbook
- map the f0000 segment (or exit gracefully)
- find SwSMI or SECLINUX in this segment (or exit gracefully)

At this point, if the driver is still loaded, but the laptop doesn't
support SABI, then it really looks like a model that should be
blacklisted.
I'm ok to use dmi for quirks, or blacklist, but honestly if a *samsung
laptop* advertise SABI support, the driver should be loaded.
We can't prevent samsung to built a laptop that will burn if we use
SABI, but if samsung does that, they can also add some fake DMI
strings too ! And has I said in the changelog, all models supported by
samsung-q10 are not affected because they don't use the same vendor
string, and even if they were, I doubt we would found a valid
signature.

But yes, it needs testing, so if you know a samsung laptop user,
please ask him to test this patch.

I set up a git repo that can help to build the driver more easilly:
https://github.com/iksaif/samsung-laptop-dkms (yeah, it's named dkms,
but there is no dkms.conf yet, that will come later).

> Hm, if you can figure out how to get the acpi-video thing working for
> some machines properly, I'll support this kind of change.

For those, boot with acpi_backlight=vendor  :)

Thanks,

-- 
Corentin Chary
http://xf.iksaif.net
