Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275Ab1FBDzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 23:55:40 -0400
Received: from ozlabs.org ([203.10.76.45]:40100 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab1FBDzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 23:55:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: Re: [PATCH RFC 2/3] virtio_net: fix tx capacity checks using new API
In-Reply-To: <110045d5bf250e6ed9c739f8cc6adbbf54e3cc9c.1306921434.git.mst@redhat.com>
References: <cover.1306921434.git.mst@redhat.com> <110045d5bf250e6ed9c739f8cc6adbbf54e3cc9c.1306921434.git.mst@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 02 Jun 2011 11:40:26 +0930
Message-ID: <87vcwphtkd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011 12:49:54 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> In the (rare) case where new descriptors are used
> while virtio_net enables vq callback for the TX vq,
> virtio_net uses the number of sg entries in the skb it frees to
> calculate how many descriptors in the ring have just been made
> available.  But this value is an overestimate: with indirect buffers
> each skb only uses one descriptor entry, meaning we may wake the queue
> only to find we still can't transmit anything.

This is a bit misleading.

The value is an overestimate, but so is the requirement for
2+MAX_SKB_FRAGS, *unless* we suddenly drop into direct mode due to OOM.

Thanks,
Rusty.
