Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356Ab1AMTL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 14:11:58 -0500
Received: from www.tglx.de ([62.245.132.106]:52058 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932676Ab1AMTLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 14:11:55 -0500
Date: Thu, 13 Jan 2011 20:11:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Borislav Petkov <bp@amd64.org>, Manoj Iyer <manoj.iyer@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
In-Reply-To: <20110113185807.GA24720@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1101132006190.2678@localhost6.localdomain6>
References: <1294934542-2411-1-git-send-email-manoj.iyer@canonical.com> <1294934542-2411-2-git-send-email-manoj.iyer@canonical.com> <20110113164616.GB21289@srcf.ucam.org> <alpine.LFD.2.00.1101131808450.2678@localhost6.localdomain6> <20110113172205.GA30866@kryptos.osrc.amd.com>
 <AANLkTinw23rtSERxAy6G_cu5=rvQeEzxvf3snsUOZE+z@mail.gmail.com> <20110113175531.GD2006@aftab> <AANLkTikDoRMoQjtN03eMoeacwottEixrFqcF8nJZWgKy@mail.gmail.com> <20110113183025.GE2006@aftab> <alpine.LFD.2.00.1101131946560.2678@localhost6.localdomain6>
 <20110113185807.GA24720@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Matthew Garrett wrote:

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

Well, it's even more odd that it comes back after 5 minutes with the
HPET enabled. How the hell is this related to the irq pin routing?

I'm really curious to see what differences we get for the irq pin
routing with and w/o the dmi quirk.

Thanks,

	tglx
