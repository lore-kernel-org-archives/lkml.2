Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab1CaOQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:16:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:32402 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab1CaOQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:16:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,275,1299484800"; 
   d="scan'208";a="727483573"
Date: Thu, 31 Mar 2011 16:16:51 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Waldemar.Rymarkiewicz@tieto.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, hthebaud@insidefr.com,
        matti.j.aaltonen@nokia.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Message-ID: <20110331141650.GB2704@sortiz-mobl>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <20110325142648.GC3879@sortiz-mobl>
 <99B09243E1A5DA4898CDD8B7001114481085E2375D@EXMB04.eu.tieto.com>
 <201103291305.02293.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103291305.02293.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 01:05:02PM +0200, Arnd Bergmann wrote:
> On Tuesday 29 March 2011, Waldemar.Rymarkiewicz@tieto.com wrote:
> > >Yes, NFC seems to be a good fit for a new socket family. 
> > >Especially if we ever want to have a proper NFC p2p support 
> > >from the kernel.
> > >Sending HCI commands should be done through a dedicated 
> > >netlink socket too.
> > >
> > >I am currently strting to work on such solution, and I hope to 
> > >be able to come up with a basic prototype for it in a few weeks.
> > 
> > What about common drivers interface in this case.
> > Should we go for common /dev/nfcX interface as well?
> 
> I fear there can only be one. A good implementation of a socket
> interface would mean that there is no need for a character device.
My idea of an initial NFC subsystem architecture was actually the following
one:
- A core NFC layer against which NFC drivers would register.
- A netlink socket for handling the HCI commands. That would put a big part of
the NFC HCI layer in kernel land and could potentially simplify the existing
NFC stacks.
- A socket family for the LLCP abstraction, a.k.a. NFC peer to peer mode.

We can start working on the first 2 items and leave the last one as a future
enhancement, since what NFC is currently mostly used for is tag
reading/writing and smartcard emulation.

Basically, we'd replace the current character device option with a netlink
one, allowing for a single kernel entry point for multiple applications
willing to do NFC.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
