Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab1EQPWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 11:22:33 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35260 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225Ab1EQPWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 11:22:31 -0400
Subject: Re: [PATCH V5 4/6 net-next] vhost: vhost TX zero-copy support
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110517055503.GA26989@redhat.com>
References: <1305574484.3456.30.camel@localhost.localdomain>
	 <20110516204540.GD18148@redhat.com>
	 <1305579414.3456.49.camel@localhost.localdomain>
	 <20110516212401.GF18148@redhat.com>
	 <1305606683.10756.3.camel@localhost.localdomain>
	 <20110517055503.GA26989@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 08:22:14 -0700
Message-ID: <1305645734.10756.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 08:55 +0300, Michael S. Tsirkin wrote:
> Something in your patch that overwrites the id in vhost
> and makes it put the wrong id in the used ring?
> 
> By the way, need to keep in mind that a guest can
> give us the same head twice, need to make sure this
> at least does not corrupt host memory.

I think I didn't explain the problem very well here.

This patch doesn't overwrite the id. It just keeps the same coming
sequence from "head return vhost_get_vq_desc()" to pass to
vhost_add_used.

The same ids can be used many times once it passes to guest from
vhost_add_used. There is no problem. The zero copy patch doesn't have
any issue.

The problem is the order of head from return vhost_get_vq_desc should be
in sequence when it passes to vhost_add_used.

The original code has no problem, because it gets one head and pass that
head to vhost_add_used one by one once done the copy. So it's in
sequence.

This issue can easily recreate without zerocopy patch by simply changing
the order from "head return vhost_get_vq_desc" when passing to
vhost_add_used.

Thanks
Shirley

