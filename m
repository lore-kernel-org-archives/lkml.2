Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab2G3OFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:05:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51040 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab2G3OFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:05:40 -0400
Date: Mon, 30 Jul 2012 09:05:33 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andreas Heider <andreas@meetr.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Arun Raghavan <arun.raghavan@collabora.co.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apple-gmux: Restore switch registers on suspend/resume
Message-ID: <20120730140533.GA18692@thinkpad-t410>
Mail-Followup-To: David Woodhouse <dwmw2@infradead.org>,
	Andreas Heider <andreas@meetr.de>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Arun Raghavan <arun.raghavan@collabora.co.uk>,
	linux-kernel@vger.kernel.org
References: <1341891593-6485-1-git-send-email-arun.raghavan@collabora.co.uk>
 <20120710160555.GA31562@srcf.ucam.org>
 <20120710163516.GE10194@thinkpad-t410>
 <4FFCC7FB.1090609@meetr.de>
 <1343522547.2488.12.camel@shinybook.infradead.org>
 <1343524730.1962.5.camel@shinybook.infradead.org>
 <5014EA3B.4010305@meetr.de>
 <1343601889.2487.3.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343601889.2487.3.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2012 at 11:44:49PM +0100, David Woodhouse wrote:
> On Sun, 2012-07-29 at 09:46 +0200, Andreas Heider wrote:
> > The gmux code you're using is a bit outdated, but if you use 
> > git://kernel.ubuntu.com/sforshee/linux.git gmux-switcheroo and connect 
> > an external display (I tested it with a DP one) you should be able to 
> > boot to DIS and switch to the IGD and get output on the external display. 
> 
> Matthew's version has changes to the core vga_switcheroo code too, to
> add the ->client_active() method which lets it pick the right client at
> init time. I'll let you work out how to merge the two, but in the
> meantime here's what I needed to do to Matthew's one to make it work...

But that code is only needed if you've hacked in the port writes to
switch to IGD in the early boot code, right? It's fine as a local hack
when trying to get things working, but I don't see it as something
that's going to be mainlined. Putting togethter something we can
mainline is my goal with the patches I've got queued up in the
referenced repository.

Fwiw on the Macbook Pro 8,2, using my tree with the patches from
http://www.codon.org.uk/~mjg59/tmp/radeon_efi/ and no port writes hacked
into early boot, the active client as seen by vga_switcheroo and
apple_gmux are the same.

Seth

