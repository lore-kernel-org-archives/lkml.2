Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab2F0PSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:18:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016Ab2F0PSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:18:23 -0400
Date: Wed, 27 Jun 2012 12:17:17 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/4] mm: introduce compaction and migration for virtio
 ballooned pages
Message-ID: <20120627151716.GA3653@t510.redhat.com>
References: <cover.1340665087.git.aquini@redhat.com>
 <7f83427b3894af7969c67acc0f27ab5aa68b4279.1340665087.git.aquini@redhat.com>
 <20120626235754.GB14782@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120626235754.GB14782@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 07:57:55PM -0400, Konrad Rzeszutek Wilk wrote:
> > +#if defined(CONFIG_VIRTIO_BALLOON) || defined(CONFIG_VIRTIO_BALLOON_MODULE)
> > +/*
> > + * Balloon pages special page->mapping.
> > + * users must properly allocate and initiliaze an instance of balloon_mapping,
> 
> initialize
>
Thanks! will fix it.
 
> > + * and set it as the page->mapping for balloon enlisted page instances.
> > + *
> > + * address_space_operations necessary methods for ballooned pages:
> > + *   .migratepage    - used to perform balloon's page migration (as is)
> > + *   .invalidatepage - used to isolate a page from balloon's page list
> > + *   .freepage       - used to reinsert an isolated page to balloon's page list
> > + */
> > +struct address_space *balloon_mapping;
> > +EXPORT_SYMBOL(balloon_mapping);
> 
> Why don't you call this kvm_balloon_mapping - and when other balloon
> drivers use it, then change it to something more generic. Also at that
> future point the other balloon drivers might do it a bit differently so
> it might be that will be reworked completly.

Ok, I see your point. However I really think it's better to keep the naming as
generic as possible today and, in the future, those who need to change it a bit can
do it with no pain at all. I believe this way we potentially prevent unnecessary code
duplication, as it will just be a matter of adjusting those preprocessor checking to
include other balloon driver to the scheme, or get rid of all of them (in case all 
balloon drivers assume the very same technique for their page mobility primitives).

As I can be utterly wrong on this, lets see if other folks raise the same
concerns about this naming scheme I'm using here. If it ends up being a general
concern that it would be better not being generic at this point, I'll happily
switch my approach to whatever comes up to be the most feasible way of doing it.

Thanks a lot for taking such consideration and provide good feedback on this
work.

