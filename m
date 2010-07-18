Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab0GRUew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 16:34:52 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56928 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757252Ab0GRUev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 16:34:51 -0400
Message-ID: <4C436566.8060609@fusionio.com>
Date: Sun, 18 Jul 2010 14:34:46 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, "jgarzik@pobox.com" <jgarzik@pobox.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH[RFC] Quirk macbook pro 6,2 into ahci mode
References: <4C4325E0.5020407@fusionio.com> <20100718184243.GA4062@srcf.ucam.org>
In-Reply-To: <20100718184243.GA4062@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2010 12:42 PM, Matthew Garrett wrote:
> On Sun, Jul 18, 2010 at 10:03:44AM -0600, Jens Axboe wrote:
> 
>> So while the below works, it doesn't work when the laptop is
>> coming out of suspend. I can't seem to find out why, since it's
>> a bit hard to debug when you are on the road. What happens is
>> that it comes back with a bit of a delay, and then the disks are
>> apparently gone. I've tried adding a resume quirk to re-AHCI the
>> thing, but it doesn't help.
> 
> You'll certainly need to re-quirk on resume, since there's no guarantee 
> that the firmware will do it for you. My suspicion is that it comes up 
> in PATA mode with legacy firmware in order to improve compatibility with 
> XP, and you'd have ahci if you booted through EFI. I don't have 
> something handy to test that right now, though.

See this is where I'm getting confused, since I'm not entirely sure what
the boot process is. If I boot a DVD directly, then it's in piix mode.
Booting through refit -> Linux, it's in piix mode. So my logic was that
it is probably getting switched into ahci mode by the OSX boot loader or
perhaps the driver does it there.

The resume re-quirk makes no difference, so it's likely that it needs a
bit more love when it's coming out of that state.

>> Looking at the specs, I don't see what I am missing to make this
>> work for resume. I'm assuming that EFI did initialize some bits
>> that am missing when coming out of resume, but I don't know which
>> bits.
> 
> There's no guarantee that the AHCI BAR is programmed by the firmware (it 
> seems to be on the Macs, but won't be on most hardware). Is it getting 
> reprogrammed on resume?

The BARs are fine with just the patch I sent:

Region 0: I/O ports at 3128 [size=8]
Region 1: I/O ports at 313c [size=4]
Region 2: I/O ports at 0170 [size=8]
Region 3: I/O ports at 0374 [size=1]
Region 4: I/O ports at 3020 [size=32]
Region 5: Memory at a2800000 (32-bit, non-prefetchable) [size=2K]

Since everything is screwed on resume and all file systems are gone,
there's no easy way for me to printk() and verify anything on resume. So
unless anyone has any stellar ideas on what to try, I guess it'll have
to wait until I can log some output somehow.

-- 
Jens Axboe

