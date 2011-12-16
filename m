Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660Ab1LPOTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:19:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34358 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759524Ab1LPOS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:18:59 -0500
Date: Fri, 16 Dec 2011 08:18:54 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
        Azael Avalos <coproscefalo@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 1/4] ACPI: EC: Add ec_get_handle()
Message-ID: <20111216141854.GA11653@thinkpad-t410>
Mail-Followup-To: Thomas Renninger <trenn@suse.de>,
	Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
	Azael Avalos <coproscefalo@gmail.com>,
	platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>
References: <1323972371-13189-1-git-send-email-seth.forshee@canonical.com>
 <201112160122.36100.trenn@suse.de>
 <20111216003333.GA18489@srcf.ucam.org>
 <201112161419.32775.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112161419.32775.trenn@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 02:19:32PM +0100, Thomas Renninger wrote:
> On Friday, December 16, 2011 01:33:33 AM Matthew Garrett wrote:
> > On Fri, Dec 16, 2011 at 01:22:35AM +0100, Thomas Renninger wrote:
> > 
> > > I think best is to move the thinkpad implementation of getting
> > > ACPI handles based on HIDs to osl.c and make it global.
> > > I'll send patches.
> > > Please review them carefully, they are only compile tested.
> > 
> > The ec driver is already finding the hardware on the basis of the HID - 
> > is there any reason to do this twice rather than just exporting the 
> > information the ec driver already has?
> 
> I don't object to export ec_handle, but thinkpad_acpi.c should get
> adjusted as well.
> 
> I had a closer look and can come up with a replacement for acpi_get_devices
> using bus.c matching function bus_find_device() avoiding the namespace
> walk.

My thought was the same as Matthew's, why bother redoing the work that
the EC driver has already done. I'm open to doing it either way though.
What your proposing does look useful independant of whether or not we
use it for finding the EC.

