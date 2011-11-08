Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab1KHRcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:32:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab1KHRcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:32:03 -0500
Message-ID: <1320773518.19116.30.camel@bling.home>
Subject: Re: [PATCH] pci: More PRI/PASID cleanup
From: Alex Williamson <alex.williamson@redhat.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>
Date: Tue, 08 Nov 2011 10:31:58 -0700
In-Reply-To: <20111108171725.GE5182@amd.com>
References: <20111103034359.10286.19062.stgit@bling.home>
	 <20111108162826.GD5182@amd.com> <1320770670.19116.23.camel@bling.home>
	 <20111108171725.GE5182@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-08 at 18:17 +0100, Roedel, Joerg wrote:
> On Tue, Nov 08, 2011 at 09:44:30AM -0700, Alex Williamson wrote:
> 
> > bit 0 (PCI_PASID_ENABLE) is reserved in the CAP register...
> 
> Is it? Which spec are you using? In my version it is not reserved but
> states if it is supported to set the enable-bit.

Latest I can find is the March 31, 2011 PASID ECN, which just lists that
bit as reserved.

> > Which means we need to check CTRL, not CAP to see if it was previously
> > enabled... or maybe this check is entirely wrong and we're was trying to
> > see if enable is supported.
> 
> I will check how this looks in my test environment.
> 
> > And nobody exposes PCI_PASID_ENABLE because it doesn't exist as a
> > capability.
> > 
> > It's easy to see this if the bit definitions are named appropriately and
> > specified per register instead of being lumped together as "close
> > enough".  Thanks,
> 
> I don't object against your renames as long as it doesn't cause
> merge-conflicts with what I plan to send upstream.

I can drop it if need be, was just trying to do some cleanup on the
consistency of pci_reg.h before adding a bunch more defines to help
bounds checking and parsing for vfio-pci.  Unless my spec is outdated,
it seems like there's more than an aesthetic change here though, so
resolving the conflicts with your latest work might be warranted.
Thanks,

Alex

