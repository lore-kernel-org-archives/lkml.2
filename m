Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab1KWW2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 17:28:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab1KWW2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 17:28:40 -0500
Date: Wed, 23 Nov 2011 12:30:46 -0800
From: Greg KH <gregkh@suse.de>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] samsung-laptop: make the dmi check less strict
Message-ID: <20111123203046.GC1355@suse.de>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
 <1321999366-23784-14-git-send-email-corentincj@iksaif.net>
 <20111122222730.GM24283@suse.de>
 <CAHR064igjTPmeeXrnO2BxNn_U0RXiw9fVJnERYj6f_Y1tChM0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHR064igjTPmeeXrnO2BxNn_U0RXiw9fVJnERYj6f_Y1tChM0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 08:17:08AM +0100, Corentin Chary wrote:
> On Tue, Nov 22, 2011 at 11:27 PM, Greg KH <gregkh@suse.de> wrote:
> > On Tue, Nov 22, 2011 at 11:02:44PM +0100, Corentin Chary wrote:
> >> This enable the driver for everything that look like
> >> a laptop and is from vendor "SAMSUNG ELECTRONICS CO., LTD.".
> >> Note that laptop supported by samsung-q10 seem to have a different
> >> vendor strict.
> >>
> >> Also remove every log output until we know that we have a SABI interface
> >> (except if the driver is forced to load, or debug is enabled).
> >>
> >> Keeping a whitelist of laptop with a model granularity is something that can't
> >> work without close vendor cooperation (and we don't have that).
> >>
> >> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
> >
> > Oh, this is bold.
> >
> > I would like to see this work, but I would need to see it tested on a
> > bunch of machines before I trust it.
> >
> > I guess you now have the acpi video backlight check, which is good, but
> > again, doesn't work for all devices.
> >
> > And yeah, a whitelist is tough, especially as the vendor isn't working
> > with us at all, but I don't want to break machines that don't need this
> > driver (and there are some, although I thought the newest ones would not
> > need it, but that might be true.)
> 
> Here is what the driver does with the patch:
> - automatically load the driver and each machine with vendor =
> "SAMSUNG ELECTRONICS CO., LTD." and type looks like a laptop or
> netbook
> - map the f0000 segment (or exit gracefully)
> - find SwSMI or SECLINUX in this segment (or exit gracefully)
> 
> At this point, if the driver is still loaded, but the laptop doesn't
> support SABI, then it really looks like a model that should be
> blacklisted.
> I'm ok to use dmi for quirks, or blacklist, but honestly if a *samsung
> laptop* advertise SABI support, the driver should be loaded.
> We can't prevent samsung to built a laptop that will burn if we use
> SABI, but if samsung does that, they can also add some fake DMI
> strings too ! And has I said in the changelog, all models supported by
> samsung-q10 are not affected because they don't use the same vendor
> string, and even if they were, I doubt we would found a valid
> signature.

Ok, as long as non-sabi modules will not have problems, I'm ok with
this.

thanks,

greg k-h
