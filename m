Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab1FBN3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 09:29:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab1FBN3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 09:29:53 -0400
Date: Thu, 2 Jun 2011 16:28:52 +0300
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
Subject: Re: [PATCH RFC 2/3] virtio_net: fix tx capacity checks using new API
Message-ID: <20110602132852.GH7141@redhat.com>
References: <cover.1306921434.git.mst@redhat.com>
 <110045d5bf250e6ed9c739f8cc6adbbf54e3cc9c.1306921434.git.mst@redhat.com>
 <87vcwphtkd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vcwphtkd.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 11:40:26AM +0930, Rusty Russell wrote:
> On Wed, 1 Jun 2011 12:49:54 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > In the (rare) case where new descriptors are used
> > while virtio_net enables vq callback for the TX vq,
> > virtio_net uses the number of sg entries in the skb it frees to
> > calculate how many descriptors in the ring have just been made
> > available.  But this value is an overestimate: with indirect buffers
> > each skb only uses one descriptor entry, meaning we may wake the queue
> > only to find we still can't transmit anything.
> 
> This is a bit misleading.
> 
> The value is an overestimate, but so is the requirement for
> 2+MAX_SKB_FRAGS, *unless* we suddenly drop into direct mode due to OOM.
> 
> Thanks,
> Rusty.

I agree, it's unlikely.

s/still can't transmit anything/are still out of space and need to stop
the ring almost at once/

Better?
