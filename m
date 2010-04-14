Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab0DNH5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 03:57:37 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:61542 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab0DNH5f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 03:57:35 -0400
Date: Wed, 14 Apr 2010 09:57:20 +0200
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH] Fix Oops with Atmel SPI
To: Iwo Mergler <iwo@call-direct.com.au>
Cc: linux-mtd@lists.infradead.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Ian McDonnell <ian@brightstareng.com>, Nicolas Pitre <nico@fluxnic.net>,
       linux-kernel@vger.kernel.org, Matthias Kaehlcke <matthias@kaehlcke.net>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <4BC56F21.6040909@call-direct.com.au> (from
	iwo@call-direct.com.au on Wed Apr 14 09:30:41 2010)
X-Mailer: Balsa 2.3.14
Message-Id: <1271231840l.5270l.0l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
References: <4BC56F21.6040909@call-direct.com.au>
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Iwo,

On 2010-04-14 09:30:41, Iwo Mergler wrote:
> I wouldn't recommend that. MTD erase blocks are 64K or more. In a typical
> embedded system you will not be able to kmalloc that much memory after
> a few day's of operation - the page pool gets fragmented.

the original problem occurs with SPI flashes, which typically have a much
smaller erase block size (and it only occurs when they are driven by an Atmel
SoC SPI controller, hence the #ifdefs)

> A possibly better approach is to arrange for that memory to get allocated
> at driver start time.

The buffer in question is indeed allocated _once_ (at the first write
operation to the device) and only deallocated when the device is unmounted,
so allocating it at driver load time wouldn't make much difference IMHO.

I realize that my patch also affects e.g. parallel NOR flash on the system,
but unless an MTD device is unmounted/remounted over and over again, I don't
see a problem.

Did I miss something else?

> An even better approach would be to change the algorithm to operate on
> a list of smaller allocations, e.g. MTD page size.

That's unfortunately beyond my abilities, I fear.

Cheers
Anders

> Anders Larsen wrote:
> > Tweak MTD's cache allocation to make it work with the atmel DMA'ed SPI.
> > Substitute kmalloc for vmalloc so the cache buffer is mappable as per
> > the Atmel SPI driver's requirements, otherwise an Oops would occur.
> > 
> > The original patch by Ian McDonnell <ian@brightstareng.com> was found here:
> > http://lists.infradead.org/pipermail/linux-mtd/2007-December/020184.html
> > 
> > Signed-off-by: Anders Larsen <al@alarsen.net>
> > Cc: Ian McDonnell <ian@brightstareng.com>
> > Cc: David Woodhouse <dwmw2@infradead.org>
> > Cc: Matthias Kaehlcke <matthias@kaehlcke.net>
> > Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> > Cc: Nicolas Pitre <nico@fluxnic.net>

