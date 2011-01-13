Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab1AMTHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 14:07:14 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58947 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab1AMTHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 14:07:12 -0500
Date: Thu, 13 Jan 2011 20:07:00 +0100
From: Borislav Petkov <bp@amd64.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Manoj Iyer <manoj.iyer@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
Message-ID: <20110113190700.GB30866@kryptos.osrc.amd.com>
References: <1294934542-2411-2-git-send-email-manoj.iyer@canonical.com>
 <20110113164616.GB21289@srcf.ucam.org>
 <alpine.LFD.2.00.1101131808450.2678@localhost6.localdomain6>
 <20110113172205.GA30866@kryptos.osrc.amd.com>
 <AANLkTinw23rtSERxAy6G_cu5=rvQeEzxvf3snsUOZE+z@mail.gmail.com>
 <20110113175531.GD2006@aftab>
 <AANLkTikDoRMoQjtN03eMoeacwottEixrFqcF8nJZWgKy@mail.gmail.com>
 <20110113183025.GE2006@aftab>
 <alpine.LFD.2.00.1101131946560.2678@localhost6.localdomain6>
 <20110113185807.GA24720@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110113185807.GA24720@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 06:58:07PM +0000, Matthew Garrett wrote:
> On Thu, Jan 13, 2011 at 07:51:49PM +0100, Thomas Gleixner wrote:
> 
> > What's odd is that the machines actually boot. I would have expected
> > that they do not boot at all if the BIOS IRQ0 pin2 override is
> > ignored. But it seems that takes effect just when the machine does a
> > suspend/resume. Weird!
> 
> The only thing that springs to mind is some BIOS code making incorrect 
> assumptions about timer setup when we trap into it. Is reprogramming the 
> timer back to the boot state over suspend plausible? If so, that'd 
> probably be a more general fix.

Well, Andreas did boot with 'hpet=verbose' on an affected machine here
and did a suspend/resume and the hpet config registers looked ok before
suspend and after resume. It might be that the HPET is temporarily
"insane" while resume lasts but we don't have any hard facts confirming
that so far. We've contemplated switching to the pit timer before
suspend and back to hpet after resume, as a brown-paper bag solution.
And this issue pertains only to SB800, that's why my machine here wasn't
affected - it has an SB700.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
