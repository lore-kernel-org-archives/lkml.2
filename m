Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab1KLA6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 19:58:42 -0500
Received: from sous-sol.org ([216.99.217.87]:53116 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755227Ab1KLA6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 19:58:40 -0500
Date: Fri, 11 Nov 2011 16:58:33 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Chris Wright <chrisw@sous-sol.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: Default to non-coherent for domains
 unattached to iommus
Message-ID: <20111112005833.GS14486@sequoia.sous-sol.org>
References: <20111111224849.9756.13368.stgit@bling.home>
 <1321058267.2006.21.camel@shinybook.infradead.org>
 <20111112004513.GP14486@sequoia.sous-sol.org>
 <1321059108.2006.24.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1321059108.2006.24.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Woodhouse (dwmw2@infradead.org) wrote:
> On Fri, 2011-11-11 at 16:45 -0800, Chris Wright wrote:
> > > So if you were to ditch the whole idea of a per-domain runtime update,
> > > and instead calculate a global value for 'iommu_coherency' at boot time,
> > > by iterating over for_each_active_iommu()¹, I think that would be a
> > > better way to deal with the issue. And you *could* really call that a
> > > 'fix'.
> > > 
> > > Make sense?
> > 
> > Ideally, yes.  Not sure we can practically do it though.  Would have to
> > be sure we force incoherent access mode for the busted hw. 
> 
> Why's it not practical? You do the *same* loop we currently have in
> domain_update_iommu_coherency(), except that you do it just *once*, over
> all active IOMMUs, at boot time. And then you just use that result
> forever more.

Yeah, you're right, that should be simple enough.  What about snoop
control?  Same thing...should we expect it to be system wide?  Because
that one's exported out to KVM and used.

> So if *any* IOMMU in the system is non-coherent, you run them all that
> way.

Minus the measureable slowdown for some devices that were behind coherent
IOMMU (IIRC, the chipsets that had this issue were mobile anyway, so
not as performance sensitive), *nod* .

thanks,
-chris
