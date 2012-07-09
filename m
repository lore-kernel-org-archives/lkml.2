Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab2GIOCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:02:25 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46161 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab2GIOCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:02:24 -0400
Date: Mon, 9 Jul 2012 15:02:22 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, grant.likely@secretlab.ca
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120709140222.GA30838@srcf.ucam.org>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20120707032907.GA15120@srcf.ucam.org>
 <20120709123253.GA31383@sirena.org.uk>
 <20120709130629.GA29130@srcf.ucam.org>
 <20120709132420.GF3934@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120709132420.GF3934@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 02:56:26PM +0100, Mark Brown wrote:
> On Mon, Jul 09, 2012 at 02:06:29PM +0100, Matthew Garrett wrote:
> 
> > There's ongoing discussion about unifying ACPI and ftd representation, 
> > and once that's done this isn't a problem, but right now there's no 
> 
> Where is this discussion?

My part of it has pretty much been in-person discussion with Grant 
Likely, but there was some on ksummit-discuss last month.

> > terribly straightforward way to do this without a lot of basically 
> > boilerplate code. The biggest issue is that ACPI has a very different 
> > idea about event delivery and we'd need some way to abstract that.
> 
> Right, but there's lots of bolierplate code with this stuff anyway and
> it's not fundamentally hard.  Last time I looked at ACPI it had a rather
> different model for how all this stuff would work than DT did which
> isn't terribly helpful here.

ACPI 5 lets devices expose their GPIO resources directly, so in some 
cases a driver will just be able to request that and handle things as it 
would in ftd. But the more traditional ACPI method is to use ACPI 
notifications, and those happen in process context. It seems unlikely 
that everyone's going to get it right unless there's existing in-kernel 
infrastructure for handling this.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
