Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab1AMS6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 13:58:18 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46101 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab1AMS6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 13:58:15 -0500
Date: Thu, 13 Jan 2011 18:58:07 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@amd64.org>, Manoj Iyer <manoj.iyer@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
Message-ID: <20110113185807.GA24720@srcf.ucam.org>
References: <1294934542-2411-1-git-send-email-manoj.iyer@canonical.com> <1294934542-2411-2-git-send-email-manoj.iyer@canonical.com> <20110113164616.GB21289@srcf.ucam.org> <alpine.LFD.2.00.1101131808450.2678@localhost6.localdomain6> <20110113172205.GA30866@kryptos.osrc.amd.com> <AANLkTinw23rtSERxAy6G_cu5=rvQeEzxvf3snsUOZE+z@mail.gmail.com> <20110113175531.GD2006@aftab> <AANLkTikDoRMoQjtN03eMoeacwottEixrFqcF8nJZWgKy@mail.gmail.com> <20110113183025.GE2006@aftab> <alpine.LFD.2.00.1101131946560.2678@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101131946560.2678@localhost6.localdomain6>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 07:51:49PM +0100, Thomas Gleixner wrote:

> What's odd is that the machines actually boot. I would have expected
> that they do not boot at all if the BIOS IRQ0 pin2 override is
> ignored. But it seems that takes effect just when the machine does a
> suspend/resume. Weird!

The only thing that springs to mind is some BIOS code making incorrect 
assumptions about timer setup when we trap into it. Is reprogramming the 
timer back to the boot state over suspend plausible? If so, that'd 
probably be a more general fix.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
