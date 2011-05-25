Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab1EYEk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 00:40:59 -0400
Received: from ozlabs.org ([203.10.76.45]:44628 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab1EYEk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 00:40:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
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
Subject: Re: [PATCHv2 10/14] virtio_net: limit xmit polling
In-Reply-To: <20110523111900.GB27212@redhat.com>
References: <cover.1305846412.git.mst@redhat.com> <aced8619c07018b5495f9ceb2c02d4fbf897a098.1305846412.git.mst@redhat.com> <877h9kvlps.fsf@rustcorp.com.au> <20110522121008.GA12155@redhat.com> <87boyutbjg.fsf@rustcorp.com.au> <20110523111900.GB27212@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Wed, 25 May 2011 11:05:04 +0930
Message-ID: <8739k3k1fb.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011 14:19:00 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> I do understand how it seems a waste to leave direct space
> in the ring while we might in practice have space
> due to indirect. Didn't come up with a nice way to
> solve this yet - but 'no worse than now :)'

Let's just make it "bool free_old_xmit_skbs(unsigned int max)".  max ==
2 for the normal xmit path, so we're low latency but we keep ahead on
average.  max == -1 for the "we're out of capacity, we may have to stop
the queue".

That keeps it simple and probably the right thing...

Thanks,
Rusty.
