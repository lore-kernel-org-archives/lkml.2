Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab1EPUpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:45:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab1EPUpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:45:51 -0400
Date: Mon, 16 May 2011 23:45:40 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 4/6 net-next] vhost: vhost TX zero-copy support
Message-ID: <20110516204540.GD18148@redhat.com>
References: <1305574484.3456.30.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305574484.3456.30.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/* Since we need to keep the order of used_idx as avail_idx, it's possible that
> + * DMA done not in order in lower device driver for some reason. To prevent
> + * used_idx out of order, upend_idx is used to track avail_idx order, done_idx
> + * is used to track used_idx order. Once lower device DMA done, then upend_idx
> + * can move to done_idx.

Could you clarify this please? virtio explicitly allows out of order
completion of requests. Does it simplify code that we try to keep
used index updates in-order? Because if not, this is not
really a requirement.

-- 
MST
