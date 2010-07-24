Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab0GXQna (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 12:43:30 -0400
Received: from gherkin.frus.com ([192.158.254.49]:42713 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038Ab0GXQn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 12:43:28 -0400
Date: Sat, 24 Jul 2010 11:43:26 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: [BUG] dm9601 driver won't init device properly
Message-ID: <20100724164326.GA7686@gherkin.frus.com>
References: <20100723195736.GA4321@gherkin.frus.com> <93420.1279982681@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93420.1279982681@localhost>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 24, 2010 at 10:44:41AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 23 Jul 2010 14:57:36 CDT, Bob Tracy said:
> > I've got one of the inexpensive Davicom DM9601 USB to fast Ethernet
> > devices, commonly available on eBay for under $10 including shipping.
> > It works fairly well in a WinXP environment with a MTU of 1000: 1500
> > and 1492 are confirmed not working, and values between 1000 and 1492
> > have not been tested at this point.
> 
> Wow. An "ethernet" card that won't do an MTU of 1500 even under Windows.  May I
> add this to my gallery of examples I use when people say "no vendor could
> *possibly* ship hardware that fscked up"? :)

You may :-), although I wouldn't assume the Windows driver is blameless.
At 100 Mbit/s, flow-control simply has to work if the device is USB 1.1.
According to the data sheet, there's a total of 16 kB of on-chip SRAM
available for buffering (oddly enough, the documentation indicates the
device *could* support up to 64 kB of SRAM).  Gotta shovel out that
stall quickly, and I suspect using a smaller MTU is simply giving an
inefficient driver more time to do that.  If I don't get tired of
messing around with this adapter, I may experiment a little to see what
happens when I lock the interface speed at 10 Mbit/s (instead of letting
it auto-sense).

Another respondent said MTU >= 1280 is required for IPv6, so I gave that
a try just to see if the floor could be raised a bit above 1000.  For
what it's worth, 1280 works.

--Bob
