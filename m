Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab1EPU5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:57:05 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:59169 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab1EPU5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:57:02 -0400
Subject: Re: [PATCH V5 4/6 net-next] vhost: vhost TX zero-copy support
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110516204540.GD18148@redhat.com>
References: <1305574484.3456.30.camel@localhost.localdomain>
	 <20110516204540.GD18148@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 13:56:54 -0700
Message-ID: <1305579414.3456.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 23:45 +0300, Michael S. Tsirkin wrote:
> > +/* Since we need to keep the order of used_idx as avail_idx, it's
> possible that
> > + * DMA done not in order in lower device driver for some reason. To
> prevent
> > + * used_idx out of order, upend_idx is used to track avail_idx
> order, done_idx
> > + * is used to track used_idx order. Once lower device DMA done,
> then upend_idx
> > + * can move to done_idx.
> 
> Could you clarify this please? virtio explicitly allows out of order
> completion of requests. Does it simplify code that we try to keep
> used index updates in-order? Because if not, this is not
> really a requirement.

Hello Mike,

Based on my testing, vhost_add_used() must be in order from
vhost_get_vq_desc(). Otherwise, virtio_net ring seems get double
freed. I didn't spend time on debugging this.

in virtqueue_get_buf

        if (unlikely(!vq->data[i])) {
                BAD_RING(vq, "id %u is not a head!\n", i);
                return NULL;
        }

That's the reason I created the upend_idx and done_idx.

Thanks
Shirley

