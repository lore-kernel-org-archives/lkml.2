Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347Ab1KVUvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:51:51 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:37336 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192Ab1KVUvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:51:50 -0500
Date: Tue, 22 Nov 2011 20:51:45 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Eugeni Dodonov <eugeni@dodonov.net>
Cc: Keith Packard <keithp@keithp.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: By default, enable RC6 on IVB and SNB when
 reasonable
Message-ID: <20111122205145.GA7206@srcf.ucam.org>
References: <1321684889-18691-1-git-send-email-keithp@keithp.com>
 <20111122201531.GD5547@srcf.ucam.org>
 <CAC7Lmnts+QwZ2XTvbTQa=aa3XO5_Sna0vk3KHWJJ6oi6+D5BXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC7Lmnts+QwZ2XTvbTQa=aa3XO5_Sna0vk3KHWJJ6oi6+D5BXw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 06:46:21PM -0200, Eugeni Dodonov wrote:
> On Tue, Nov 22, 2011 at 18:15, Matthew Garrett <mjg@redhat.com> wrote:
> 
> > On Fri, Nov 18, 2011 at 10:41:29PM -0800, Keith Packard wrote:
> >
> > > +     /*
> > > +      * Only enable RC6 if all dma remapping is disabled, or if
> > > +      * there's no iommu present in the machine.
> > > +      */
> > > +     if (INTEL_INFO(dev)->gen == 6)
> > > +             return no_iommu || dmar_disabled;
> >
> > So the user has to choose between 5W of power saving or having dmar? And
> > we default to giving them dmar?
> 
> 
> From the latest investigations, it is either this, or random gpu hangs and
> crashes when both are enabled :(.

So blacklist dmar on sandybridge. The power saving is going to be more 
important for most users.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
