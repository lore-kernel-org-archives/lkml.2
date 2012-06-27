Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab2F0JER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:04:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab2F0JEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:04:14 -0400
Date: Wed, 27 Jun 2012 12:04:10 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Frank Swiderski <fes@google.com>
Cc: Rik van Riel <riel@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Andrea Arcangeli <aarcange@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mikew@google.com,
        Ying Han <yinghan@google.com>, Rafael Aquini <aquini@redhat.com>
Subject: Re: [PATCH] Add a page cache-backed balloon device driver.
Message-ID: <20120627090410.GB17507@redhat.com>
References: <1340742778-11282-1-git-send-email-fes@google.com>
 <4FEA1E2E.4020806@redhat.com>
 <CAK+C7kWKtoYC=1fBQ45RTFfNc3p2PwZbLMOefMTtzOfsqe_k8w@mail.gmail.com>
 <4FEA2D85.60002@redhat.com>
 <CAK+C7kVHeUz7nUV1vtSHrK6vXorLsZoos82NFm0P0Ux0rEOZGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK+C7kVHeUz7nUV1vtSHrK6vXorLsZoos82NFm0P0Ux0rEOZGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 04:45:36PM -0700, Frank Swiderski wrote:
> On Tue, Jun 26, 2012 at 2:45 PM, Rik van Riel <riel@redhat.com> wrote:
> > On 06/26/2012 05:31 PM, Frank Swiderski wrote:
> >>
> >> On Tue, Jun 26, 2012 at 1:40 PM, Rik van Riel<riel@redhat.com>  wrote:
> >
> >
> >>> The code looks good to me, my only worry is the
> >>> code duplication. We now have 5 balloon drivers,
> >>> for 4 hypervisors, all implementing everything
> >>> from scratch...
> >>
> >>
> >> Do you have any recommendations on this?  I could (I think reasonably
> >> so) modify the existing virtio_balloon.c and have it change behavior
> >> based on a feature bit or other configuration.  I'm not sure that
> >> really addresses the root of what you're pointing out--it's still
> >> adding a different implementation, but doing so as an extension of an
> >> existing one.
> >
> >
> > Ideally, I believe we would have two balloon
> > top parts in a guest (one classical balloon,
> > one on the LRU), and four bottom parts (kvm,
> > xen, vmware & s390).
> >
> > That way the virt specific bits of a balloon
> > driver would be essentially a ->balloon_page
> > and ->release_page callback for pages, as well
> > as methods to communicate with the host.
> >
> > All the management of pages, including stuff
> > like putting them on the LRU, or isolating
> > them for migration, would be done with the
> > same common code, regardless of what virt
> > software we are running on.
> >
> > Of course, that is a substantial amount of
> > work and I feel it would be unreasonable to
> > block anyone's code on that kind of thing
> > (especially considering that your code is good),
> > but I do believe the explosion of balloon
> > code is a little worrying.
> >
> 
> Hm, that makes a lot of sense.  That would be a few patches definitely
> worth doing, IMHO.  I'm not entirely sure how I feel about inflating
> the balloon drivers in the meantime.  Sigh, and I didn't even mean
> that as a pun.
> 
> fes

Actually I'm not 100% sure the num_pages interface
of the classical balloon is a good fit for the LRU
balloon. Let's figure that out first: if we fork the interface
there might not be all that much common code ...

-- 
MST
