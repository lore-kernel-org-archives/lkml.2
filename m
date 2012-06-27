Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab2F0Pj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:39:26 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23608 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab2F0PjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:39:25 -0400
Date: Wed, 27 Jun 2012 11:30:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Rafael Aquini <aquini@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/4] mm: introduce compaction and migration for virtio
 ballooned pages
Message-ID: <20120627153023.GF17154@phenom.dumpdata.com>
References: <cover.1340665087.git.aquini@redhat.com>
 <7f83427b3894af7969c67acc0f27ab5aa68b4279.1340665087.git.aquini@redhat.com>
 <20120626235754.GB14782@localhost.localdomain>
 <20120627151716.GA3653@t510.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627151716.GA3653@t510.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 12:17:17PM -0300, Rafael Aquini wrote:
> On Tue, Jun 26, 2012 at 07:57:55PM -0400, Konrad Rzeszutek Wilk wrote:
> > > +#if defined(CONFIG_VIRTIO_BALLOON) || defined(CONFIG_VIRTIO_BALLOON_MODULE)
.. snip..
> > > +struct address_space *balloon_mapping;
> > > +EXPORT_SYMBOL(balloon_mapping);
> > 
> > Why don't you call this kvm_balloon_mapping - and when other balloon
> > drivers use it, then change it to something more generic. Also at that
> > future point the other balloon drivers might do it a bit differently so
> > it might be that will be reworked completly.
> 
> Ok, I see your point. However I really think it's better to keep the naming as
> generic as possible today and, in the future, those who need to change it a bit can
> do it with no pain at all. I believe this way we potentially prevent unnecessary code
> duplication, as it will just be a matter of adjusting those preprocessor checking to
> include other balloon driver to the scheme, or get rid of all of them (in case all 
> balloon drivers assume the very same technique for their page mobility primitives).

Either way, if a driver is going to use this, they would need to adjust the
preprocessor checking (as you pointed out) to include: #ifdef CONFIG_HYPERVISORX_BALLOON
in this file. At which point they might as well rename the exported symbol to be more
generic - and do whatever else they need to do (add extra stuff maybe?).

> 
> As I can be utterly wrong on this, lets see if other folks raise the same
> concerns about this naming scheme I'm using here. If it ends up being a general
> concern that it would be better not being generic at this point, I'll happily
> switch my approach to whatever comes up to be the most feasible way of doing it.

My point here is that its more of name-space pollution. I've gotten flak on doing
this with drivers - which had very generic sounding names, and it made more sense
to rename them with a proper prefix. You are adding pieces of code for the
benefit of one driver.

But that (getting flak on the namespace) might be because the mailing list where I
had posted had more aggressive reviewers and this one is composed of more mellow folks
who are OK with this. Andrew is the final man - and I am not sure what he
prefers.
