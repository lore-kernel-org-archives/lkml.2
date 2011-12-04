Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1LDP7T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 10:59:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab1LDP7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 10:59:16 -0500
Date: Sun, 4 Dec 2011 18:00:54 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        markmc@redhat.com
Subject: Re: [PATCH] virtio-ring: Use threshold for switching to indirect
 descriptors
Message-ID: <20111204160053.GA22501@redhat.com>
References: <20111201075847.GA5479@redhat.com>
 <1322726977.3259.3.camel@lappy>
 <20111201102640.GB8822@redhat.com>
 <87zkfbre9x.fsf@rustcorp.com.au>
 <1322913028.3782.4.camel@lappy>
 <4EDB5EF0.2010909@redhat.com>
 <20111204120132.GB18758@redhat.com>
 <4EDB624A.3030403@redhat.com>
 <20111204151148.GA21851@redhat.com>
 <4EDB8EEB.4070309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDB8EEB.4070309@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 04, 2011 at 05:16:59PM +0200, Avi Kivity wrote:
> On 12/04/2011 05:11 PM, Michael S. Tsirkin wrote:
> > > There's also the used ring, but that's a
> > > mistake if you have out of order completion.  We should have used copying.
> >
> > Seems unrelated... unless you want used to be written into
> > descriptor ring itself?
> 
> The avail/used rings are in addition to the regular ring, no?

Yes. A couple of extra pages, if we reduce alignment we could pack this
in a single extra page.

>  If you
> copy descriptors, then it goes away.

The avail ring could go away. used could if we make descriptors
writeable. IIUC it was made RO in the hope that will make it
easier for xen to adopt. Still relevant?

> > But, I don't really know why does virtio ring insist on
> > making the 3 buffers (avail/used/descriptor)
> > physically contigious. Rusty?
> 
> Let's drop them instead.
> 
> >
> > > 16kB worth of descriptors is 1024 entries.  With 4kB buffers, that's 4MB
> > > worth of data, or 4 ms at 10GbE line speed.  With 1500 byte buffers it's
> > > just 1.5 ms.  In any case I think it's sufficient.
> >
> > Right. So I think that without indirect, we waste about 3 entries
> > per packet for virtio header and transport etc headers.
> 
> That does suck.  Are there issues in increasing the ring size?  Or
> making it discontiguous?

discontiguous ring is what indirect is, basically.

> Can you take a peek at how Xen manages its rings?  They have the same
> problems we do.
> 
> -- 
> error compiling committee.c: too many arguments to function
