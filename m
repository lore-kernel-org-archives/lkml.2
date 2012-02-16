Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab2BPDbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 22:31:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35775 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980Ab2BPDbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 22:31:10 -0500
Date: Wed, 15 Feb 2012 20:31:08 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Please add irqdomain branch to linux-next
Message-ID: <20120216033108.GL25779@ponder.secretlab.ca>
References: <CACxGe6sTO_Jy-vecKS9SoVs55ZA8BMc+O0NODLdq6KvkcbPByg@mail.gmail.com>
 <1328492111.30631.24.camel@pasglop>
 <20120206061517.GD21449@ponder.secretlab.ca>
 <CACxGe6tAVW2zCrWFPDgvu8sjd4KXJnfqhT16sYa1UvyRVEVyhQ@mail.gmail.com>
 <1329361898.3772.43.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329361898.3772.43.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 02:11:38PM +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2012-02-15 at 18:32 -0700, Grant Likely wrote:
> 
> > Only nomap users will care about this, and of those 5, only iseries
> > and ps3 actually change it.  How about I add a max_virq parameter to
> > only be used by the nomap revmap?  That seems to be cleaner than a
> > global setting.  I've crafted a patch and will post it with v5 of the
> > series.
> 
> Right, I don't see an obvious need elsewhere so it could be a flag
> specific to nomap, tho it still needs to be taken into account in the
> main allocation code.
> 
> > For now I'll use numa_node_id() at allocation time.  I'll craft a
> > follow-on patch to change the API since it touches a lot of call
> > sites.
> 
> But which node ? :-)
> 
> I'd rather you add a new API, no need to change the call sites:
> 
> Add foo_node(xxx,node); and have the existing foo() be implemented
> as a static inline calling foo_node(xxx,0); or something like that, then
> I can change the powerpc code to use the later & pass the PCI device
> node (which should be in the pci_controller structure). We can add more
> later.

Okay, fair enough.  Instead of changing the series then, adding the new
api can be the follow on patch.

g.

