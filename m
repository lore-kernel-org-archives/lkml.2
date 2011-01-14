Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab1ANC0C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 21:26:02 -0500
Received: from straum.hexapodia.org ([207.7.131.186]:43606 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1ANCZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 21:25:55 -0500
Date: Thu, 13 Jan 2011 18:25:54 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-nfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marc Kleine-Budde <m.kleine-budde@pengutronix.de>
Subject: Re: still nfs problems [Was: Linux 2.6.37-rc8]
Message-ID: <20110114022554.GA17397@hexapodia.org>
References: <20101230171453.GA5787@pengutronix.de> <1293731992.4919.5.camel@heimdal.trondhjem.org> <20101230191846.GB14221@pengutronix.de> <20110103213850.GC25121@pengutronix.de> <1294100558.25100.8.camel@heimdal.trondhjem.org> <20110105084014.GN25121@pengutronix.de> <20110105110517.GQ25121@pengutronix.de> <20110105112701.GA8638@n2100.arm.linux.org.uk> <20110105134045.GS25121@pengutronix.de> <1294239193.3014.9.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294239193.3014.9.camel@heimdal.trondhjem.org>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 09:53:13AM -0500, Trond Myklebust wrote:
> > There was a bug in at least -rc5[1] that was considered already fixed in
> > -rc4[2]. The later announcements didn't mention it anymore. 
> > 
> > > I don't know why it's stopped producing the errors, although once it
> > > went I never investigated it any further (was far too busy trying to
> > > get AMBA DMA support working.)
> > It seems it was fixed for most users though. Trond?
> 
> As I said, I can't reproduce it.
> 
> I'm seeing a lot of mention of ARM above. Is anyone seeing this bug on
> x86, or does it appear to be architecture-specific?

I'm seeing processes stuck in D with "fileid changed" in dmesg, on
x86_64 (both server and client).  The repro testcase is to run an
executable off of NFS, recompile it on the server, and then try to tab
complete the executable name.  The client prints

    NFS: server <hostname> error: fileid changed
    fsid 0:18: expected fileid 0x107aa4a, got 0x107ad3e

and /bin/zsh hangs in D.

My server is running 2.6.36.1, filesystem is ext3 on sda3 on AHCI,
client is currently running 2.6.37-rc1.  I'm assuming that 37a09f will
fix it.

-andy
