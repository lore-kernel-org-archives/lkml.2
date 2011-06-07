Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab1FGQIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 12:08:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab1FGQI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:08:29 -0400
Date: Tue, 7 Jun 2011 19:08:30 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: Re: [PATCHv2 RFC 0/4] virtio and vhost-net capacity handling
Message-ID: <20110607160830.GB17581@redhat.com>
References: <cover.1307029008.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1307029008.git.mst@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 06:42:35PM +0300, Michael S. Tsirkin wrote:
> OK, here's a new attempt to use the new capacity api.  I also added more
> comments to clarify the logic.  Hope this is more readable.  Let me know
> pls.
> 
> This is on top of the patches applied by Rusty.
> 
> Warning: untested. Posting now to give people chance to
> comment on the API.

OK, this seems to have survived some testing so far,
after I dropped patch 4 and fixed build for patch 3
(build fixup patch sent in reply to the original).

I'll be mostly offline until Sunday, would appreciate
testing reports.

git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
virtio-net-xmit-polling-v2
git://git.kernel.org/pub/scm/linux/kernel/git/mst/qemu-kvm.git
virtio-net-event-idx-v3

Thanks!

> Changes from v1:
> - fix comment in patch 2 to correct confusion noted by Rusty
> - rewrite patch 3 along the lines suggested by Rusty
>   note: it's not exactly the same but I hope it's close
>   enough, the main difference is that mine does limited
>   polling even in the unlikely xmit failure case.
> - added a patch to not return capacity from add_buf
>   it always looked like a weird hack
> 
> Michael S. Tsirkin (4):
>   virtio_ring: add capacity check API
>   virtio_net: fix tx capacity checks using new API
>   virtio_net: limit xmit polling
>   Revert "virtio: make add_buf return capacity remaining:
> 
>  drivers/net/virtio_net.c     |  111 ++++++++++++++++++++++++++----------------
>  drivers/virtio/virtio_ring.c |   10 +++-
>  include/linux/virtio.h       |    7 ++-
>  3 files changed, 84 insertions(+), 44 deletions(-)
> 
> -- 
> 1.7.5.53.gc233e
