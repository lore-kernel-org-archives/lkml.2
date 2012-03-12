Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab2CLPHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:07:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49083 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab2CLPHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:07:21 -0400
Date: Mon, 12 Mar 2012 15:07:17 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] platform/x86: Add driver for Apple gmux device
Message-ID: <20120312150717.GA13211@srcf.ucam.org>
References: <1329424465-1211-1-git-send-email-seth.forshee@canonical.com>
 <1329921457-26887-1-git-send-email-seth.forshee@canonical.com>
 <20120312142126.GA11969@srcf.ucam.org>
 <20120312145701.GA12322@ubuntu-macmini>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312145701.GA12322@ubuntu-macmini>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 09:57:01AM -0500, Seth Forshee wrote:
> On Mon, Mar 12, 2012 at 02:21:26PM +0000, Matthew Garrett wrote:
> > apple_bl probably needs some matching work to disable itself if there's 
> > a gmux present? Otherwise, this looks good.
> 
> How do you suggest doing this? The tricky point is that the gmux object
> can be present in ACPI when the gmux hardware isn't really present
> (which is what the version check really does, verifies the hardware is
> actually there). So apple_bl can't just look for the ACPI object; it
> needs to either communicate with apple-gmux or duplicate some of its
> logic.

The alternative is for apple_bl to export its unregister function and 
have gmux call that - downside is obviously that that results in gmux 
depending on apple_bl. Maybe some sort of notification list in the 
backlight core?

> We also have the problem of gmux_backlight versus acpi_video. On most
> machines with a gmux the acpi_video backlight interface is present but
> just doesn't work. This problem isn't just limited to Apples. I'm of the
> opinion that we need a more generalized solution for arbitrating between
> the backlight interfaces present on a given machine, but I haven't had a
> chance to really think about what that would look like.

The ACPI code appears to be trapping into system management mode, so 
figuring out what it's meant to do is going to be awkward. I think 
having a hook in the ACPI video driver to deregister it in cases where 
we know it doesn't work is legitimate, but since it presumably works 
under Windows it'd be nice to figure out what's broken about it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
