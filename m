Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab1CUQGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:06:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53779 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750734Ab1CUQF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:05:56 -0400
Date: Mon, 21 Mar 2011 16:06:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, dzickus@redhat.com
Subject: Re: [PATCH]: SMBIOS: Add initial code and export version via sysfs
Message-ID: <20110321160608.42dc371b@lxorguk.ukuu.org.uk>
In-Reply-To: <4D8772B6.80302@redhat.com>
References: <20110317135754.25241.88177.sendpatchset@prarit.bos.redhat.com>
	<20110317193023.GA16790@kroah.com>
	<4D826718.3030001@redhat.com>
	<20110317200701.GB17827@kroah.com>
	<4D8772B6.80302@redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In this way we would limit the amount of change to external packages
> (ie, initscripts, network init, etc.) to hopefully only filename changes.

Why change them at all. SMBIOS provides everything DMI BIOS interfaces
did, so we should just continue to provide them to userspace exactly as
before, but possibly sourced from other locations. There simply isn't a
need to break anything user side. Maybe in five or ten years time someone
will delete the old stuff as nobody uses it any more but it's not an item
that needs hurrying.

Also distinguish between DMI and the DMI BIOS interfaces, the two are
rather different beasts.

> drivers & subsystems to link back to the files.  Of course, the SMBIOS code
> would provide lookup functions similar to the ones provided by the existing
> DMI code to aid drivers in their lookups.

I'm wondering why put all the SMBIOS complexity into the kernel, but then
I wonder likewise about some of the DMI stuff still 8)

> 3.  Modify drivers to use the new SMBIOS table lookups, etc, instead of
> DMI table lookups.  This is relatively easy, IMO.  I will try to keep
> dmi* functions identical to the new smbios* lookup functions.  That code
> works
> well, and isn't in need of change.

I'd actually suggest one change. In using dmi_ naming and DMI alone the
original code made the assumption it was a PC specific tool for doing
fixups and the like. If we are going to tweak it then we should probably
recognize that want the kernel needs to provide to drivers isn't (for the
most case) SMBIOS lookup it's generic "Platform name" etc and these could
have been populated from things other than SMBIOS (OpenFirmware,
DeviceTree, whatever).

It doesn't really change the interface but if you are going to be
renaming things maybe a better naming would be worth it ?

> 5.  After a release (or some other set period of time defined in
> feature-removal-schedule.txt), remove the old DMI code.

This is a user API so really it wants to hang around for a long time, and
given SMBIOS can just provide the same names as well trivially it might
as well just stay there until no distro is using it, then get a _LEGACY
config, then vanish. Think multiples of years.

Alan
