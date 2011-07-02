Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1GBNE1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 09:04:27 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34918 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab1GBNEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 09:04:25 -0400
Date: Sat, 2 Jul 2011 06:04:17 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: jbarnes@virtuousgeek.org, torvalds@linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, socketcan@hartkopp.net, bhelgaas@google.com,
        linux@dominikbrodowski.net
Subject: Re: [PATCH 0/5 v2] PCI: fix cardbus and sriov regressions
Message-ID: <20110702130417.GA4016@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1309477662-18680-1-git-send-email-linuxram@us.ibm.com>
 <1309561669.2693.20.camel@bwh-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309561669.2693.20.camel@bwh-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 02, 2011 at 12:07:48AM +0100, Ben Hutchings wrote:
> On Thu, 2011-06-30 at 16:47 -0700, Ram Pai wrote:
> > The following patch-set fixes regressions caused by:
> > 
> > the commit "PCI: update bridge resources to get more big ranges when allocating space (again)"
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=da7822e5ad71ec9b745b412639f1e5e0ba795a20
> > 
> > patch 1/5: fix calculation of additional resource size for hotplug bridges
> > patch 2/5: ability to resize assigned pci-resource
> > patch 3/5: make SRIOV BARs resources optional
> > patch 4/5: make cardbus bridge resources optional
> > patch 5/5: code and terminology cleanup
> > 
> > The regression was caused on some platforms with limited i/o and memory
> > resources, the optional resources were allocated ahead of required resources,
> > thus starving the latter. The patchset ensures that all the required resources
> > are satisfied before any optional resources are satisfied.
> 
> This certainly fixes the problem I originally reported: all the basic
> BARs for devices with SR-IOV enabled are mapped.
> 
> When testing this, I noticed that a BAR which we fail to allocate space
> for may be left configured with an address range that overlaps that of
> other BARs.  However, that does not appear to be a regression.

overlaps the other SRIOV BARs of the same device?

Can you send me the dmesg output?
RP
