Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab1ERFoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 01:44:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab1ERFn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 01:43:58 -0400
Date: Wed, 18 May 2011 08:43:40 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: Re: [PATCH 09/18] virtio: use avail_event index
Message-ID: <20110518054340.GE7589@redhat.com>
References: <cover.1304541918.git.mst@redhat.com>
 <8bba6a0a8eee17e741c5155b04ff1b1c9f34bf94.1304541919.git.mst@redhat.com>
 <874o54h4rt.fsf@rustcorp.com.au>
 <20110515135541.GF24932@redhat.com>
 <87ei3zdsq2.fsf@rustcorp.com.au>
 <20110517061031.GC26989@redhat.com>
 <87tycsn9lt.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tycsn9lt.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 09:49:42AM +0930, Rusty Russell wrote:
> On Tue, 17 May 2011 09:10:31 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > Well one can imagine a driver doing:
> > 
> > 	while (virtqueue_get_buf()) {
> > 		virtqueue_add_buf()
> > 	}
> > 	virtqueue_kick()
> > 
> > which looks sensible (batch kicks) but might
> > process any number of bufs between kicks.
> 
> No, we currently only expose the buffers in the kick, so it can only
> fill the ring doing that.
> 
> We could change that (and maybe that's worth looking at)...

Yes, I think we should - this way host and guest can process
data in parallel without a kick.

My patchset included that simply because it's one index
less to be confused about.


> > If we look at drivers closely enough, I think none
> > of them do the equivalent of the above, but not 100% sure.
> 
> I'm pretty sure we don't have this kind of 'echo' driver yet.  Drivers
> tend to take OS requests and queue them.  The only one which does
> anything even partially sophisticated is the net driver...
> 
> Thanks,
> Rusty.
