Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab0DGSIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 14:08:53 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:20378 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab0DGSIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 14:08:52 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andy Isaacson <adi@hexapodia.org>
Subject: Re: [2.6.34-rc1 REGRESSION] ahci 0000:00:1f.2: controller reset failed (0xffffffff)
Date: Wed, 7 Apr 2010 12:08:49 -0600
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Matthew Wilcox <willy@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>
References: <20100406225425.GA8292@hexapodia.org> <1270614080.8518.26.camel@dc7800.home> <20100407171610.GH29192@hexapodia.org>
In-Reply-To: <20100407171610.GH29192@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004071208.50483.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 April 2010 11:16:10 am Andy Isaacson wrote:
> On Tue, Apr 06, 2010 at 10:21:20PM -0600, Bjorn Helgaas wrote:
> > > The machine only has Linux installed, but I may have access to another
> > > T3400 that can dual-boot.  Any preference for XP versus Win7?
> > 
> > Nope, whatever's more convenient for you should be fine.
> 
> On another T3400 with BIOS A03, Win7's Device Manager -> IDE ATA/ATAPI
> controllers -> Standard AHCI 1.0 -> Resources -> Memory Range setting is
> ff97f800-ff97ffff.

Assuming this is the same AHCI controller (probably is, because I only
see one mentioned in your logs), I think Win7 moved it from where BIOS
left it.  It probably started at 0xff970000, and Win7 moved it into one
of the host bridge windows (but not the legacy VGA one):

  pci_root PNP0A03:00: host bridge window [mem 0xff980800-0xff980bff]
  pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
  pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]

Bjorn
