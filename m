Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1ACTkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 14:40:24 -0500
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:48364
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966Ab1ACTkX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 14:40:23 -0500
Subject: Re: Using s3virge card in Sun Blade 2000
From: Alex Buell <alex.buell@munted.org.uk>
Reply-To: alex.buell@munted.org.uk
To: David Miller <davem@davemloft.net>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110103.105827.112602895.davem@davemloft.net>
References: <1294072336.17576.7.camel@lithium>
	 <20110103.105827.112602895.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: One very high maintenance cat for company
Date: Mon, 03 Jan 2011 19:39:01 +0000
Message-ID: <1294083541.17576.11.camel@lithium>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-Gradwell-MongoId: 4d222624.140e2-6d5e-2
X-Gradwell-Auth-Method: mailbox
X-Gradwell-Auth-Credentials: postmaster@pop3.munted.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-03 at 10:58 -0800, David Miller wrote:
> From: Alex Buell <alex.buell@munted.org.uk>
> Date: Mon, 03 Jan 2011 16:32:16 +0000
> 
> > I'm aware the s3fb driver has big endian issues, I can help fix those
> > issues so I can get the card working. Or in other words, I'd welcome
> > advice on how to proceed with this. 
> 
> It's not endian issues, this driver has other problems.
> 
> It uses the VGA register accessors with a NULL regbase, which is not
> going to work on sparc64.
> 
> It needs to access the VGA register space relative to the I/O space
> of the PCI controller domain it is behind.
> 
> Probably if you replace the NULL values passes to vga_r*() and
> vga_w*() with the I/O space resource base of the chip (should be
> resource "1") it might work.

I've had a look at linux/include/video/vga.h, and yes I see what you
mean now.

Secondly, is Linux fully capable of handling different graphic cards
simultaneously? For example, plug in a pair of monitors and have
consoles on both with disparate graphic cards i.e. XVR-500 and S3ViRGE
etc? 
-- 
Tactical Nuclear Kittens
