Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab1KWG6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 01:58:24 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47710 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600Ab1KWG6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 01:58:22 -0500
MIME-Version: 1.0
In-Reply-To: <20111122221633.GA24283@suse.de>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
	<1321999366-23784-4-git-send-email-corentincj@iksaif.net>
	<20111122221633.GA24283@suse.de>
Date: Wed, 23 Nov 2011 07:58:20 +0100
Message-ID: <CAHR064jucMdu3KKctTTE=peNjhZ8TNvh6WecUrGc+HQp9BFpvg@mail.gmail.com>
Subject: Re: [PATCH 03/15] samsung-laptop: don't handle backlight if handled
 by acpi/video
From: Corentin Chary <corentin.chary@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:16 PM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Nov 22, 2011 at 11:02:34PM +0100, Corentin Chary wrote:
>> samsung-laptop is not at all related to ACPI, but since this interface
>> is not documented at all, and the driver has to use it at load to
>> understand how it works on the laptop, I think it's a good idea to
>> disable it if a better solution is available.
>
> I wish this would work, but on the machine that I had, there was a valid
> ACPI table for the video device, yet I was told to "ignore it, it
> doesn't work and use the sabi interface instead", so this patch would
> break that machine :(

Well, it's why acpi_backlight=vendor is here: to enable and use the
vendor backlight instead of using the standard ACPI interface.
And nowadays, even gpu drivers provide a backlight class (at least for
intel, nvidia/nouveau, and maybe radeon.

> We might want to trigger off of the machine type for this kind of
> thing, that's the only way I can see this working properly.

But, yes, this is a "regression". Maybe we should do that:
- enable the backlight by default for all SECLINUX models
- disable it by default for swsmi, but let the user be able to enable
it with acpi_backlight=vendor (this is what is done with this patch).




-- 
Corentin Chary
http://xf.iksaif.net
