Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab0GRSmz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 14:42:55 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34303 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025Ab0GRSmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 14:42:53 -0400
Date: Sun, 18 Jul 2010 19:42:43 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, jgarzik@pobox.com,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH[RFC] Quirk macbook pro 6,2 into ahci mode
Message-ID: <20100718184243.GA4062@srcf.ucam.org>
References: <4C4325E0.5020407@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4325E0.5020407@fusionio.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 18, 2010 at 10:03:44AM -0600, Jens Axboe wrote:

> So while the below works, it doesn't work when the laptop is
> coming out of suspend. I can't seem to find out why, since it's
> a bit hard to debug when you are on the road. What happens is
> that it comes back with a bit of a delay, and then the disks are
> apparently gone. I've tried adding a resume quirk to re-AHCI the
> thing, but it doesn't help.

You'll certainly need to re-quirk on resume, since there's no guarantee 
that the firmware will do it for you. My suspicion is that it comes up 
in PATA mode with legacy firmware in order to improve compatibility with 
XP, and you'd have ahci if you booted through EFI. I don't have 
something handy to test that right now, though.

> Looking at the specs, I don't see what I am missing to make this
> work for resume. I'm assuming that EFI did initialize some bits
> that am missing when coming out of resume, but I don't know which
> bits.

There's no guarantee that the AHCI BAR is programmed by the firmware (it 
seems to be on the Macs, but won't be on most hardware). Is it getting 
reprogrammed on resume?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
