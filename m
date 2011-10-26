Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180Ab1JZNyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:54:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52013 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932680Ab1JZNyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:54:36 -0400
Date: Wed, 26 Oct 2011 08:54:32 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Azael Avalos <coproscefalo@gmail.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] toshiba_acpi: Cleanup and TOS1900 device support
Message-ID: <20111026135432.GA31917@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Azael Avalos <coproscefalo@gmail.com>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1316555754-25949-1-git-send-email-seth.forshee@canonical.com>
 <20110921153137.GA26436@srcf.ucam.org>
 <20110921161043.GC29983@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921161043.GC29983@thinkpad-t410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 11:10:44AM -0500, Seth Forshee wrote:
> On Wed, Sep 21, 2011 at 04:31:37PM +0100, Matthew Garrett wrote:
> > On Tue, Sep 20, 2011 at 04:55:48PM -0500, Seth Forshee wrote:
> > > Hi Matthew,
> > > 
> > > Please consider merging the following patches. They represent a
> > > signficant cleanup of toshiba_acpi as well as adding support for SPFC as
> > > an HCI method. The latter provides basic but functional support for the
> > > TOS1900 devices found on newer Toshiba models, which will serve as a
> > > good starting point for further enhancements. I've tried to leave the
> > > details of the hardware interaction unchanged to reduce the risk of
> > > regression for machines already supported by the driver.
> > 
> > Great. Has this been tested on any older hardware? I'd think that the 
> > risk of regression is pretty low, but it'd be a nice sanity check. I've 
> > only got one TOS1800 type around here, and it's a 1.2GHz Pentium M, so 
> > I'd prefer to have got someone else to do it :)
> 
> No, I don't have any older hardware to test on, and I'm pretty sure
> Azael doesn't either. Not that I want to afflict any additional pain
> beyond what you already have from dealing with firmware all day ;)

I managed to find some volunteers with machines that use the GHCI
interface to do some regression testing for me. They aren't exactly
older hardware, all of them with TOS6208 and being made within the last
2 or 3 years. But it's the best I could do.

None of the machines tested showed any regressions as a result of these
patches. I also got testing of using the INFO method to read hotkey
scancodes, and that's working on those machines as well. (I did however
find that I had to reintroduce the global toshiba_acpi pointer for the
i8042 filter, since it doesn't have any mechanism for passing private
data to the callback.)

Any chance of seeing these patches in 3.2?
