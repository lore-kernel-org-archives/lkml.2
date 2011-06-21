Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab1FUPXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:23:38 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33947 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab1FUPXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:23:32 -0400
From: Tom Lendacky <tahm@linux.vnet.ibm.com>
Organization: IBM Linux Performance
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: RFT: virtio_net: limit xmit polling
Date: Tue, 21 Jun 2011 10:23:22 -0500
User-Agent: KMail/1.13.7 (Linux/2.6.35.13-91.fc14.i686.PAE; KDE/4.6.3; i686; ; )
Cc: Krishna Kumar2 <krkumar2@in.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Carsten Otte <cotte@de.ibm.com>, habanero@linux.vnet.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>, kvm@vger.kernel.org,
        lguest@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux390@de.ibm.com,
        netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, steved@us.ibm.com,
        virtualization@lists.linux-foundation.org, Shirley Ma <xma@us.ibm.com>,
        roprabhu@cisco.com
References: <20110619102700.GA11198@redhat.com>
In-Reply-To: <20110619102700.GA11198@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106211023.24643.tahm@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 19, 2011 05:27:00 AM Michael S. Tsirkin wrote:
> OK, different people seem to test different trees.  In the hope to get
> everyone on the same page, I created several variants of this patch so
> they can be compared. Whoever's interested, please check out the
> following, and tell me how these compare:

I'm in the process of testing these patches.  Base and v0 are complete
and v1 is near complete with v2 to follow.  I'm testing with a variety
of TCP_RR and TCP_STREAM/TCP_MAERTS tests involving local guest-to-guest
tests and remote host-to-guest tests.  I'll post the results in the next
day or two when the tests finish.

Thanks,
Tom

> 
> kernel:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
> 
> virtio-net-limit-xmit-polling/base - this is net-next baseline to test
> against virtio-net-limit-xmit-polling/v0 - fixes checks on out of capacity
> virtio-net-limit-xmit-polling/v1 - previous revision of the patch
> 		this does xmit,free,xmit,2*free,free
> virtio-net-limit-xmit-polling/v2 - new revision of the patch
> 		this does free,xmit,2*free,free
> 
> There's also this on top:
> virtio-net-limit-xmit-polling/v3 -> don't delay avail index update
> I don't think it's important to test this one, yet
> 
> Userspace to use: event index work is not yet merged upstream
> so the revision to use is still this:
> git://git.kernel.org/pub/scm/linux/kernel/git/mst/qemu-kvm.git
> virtio-net-event-idx-v3
