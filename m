Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab2KAHnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 03:43:12 -0400
Received: from ozlabs.org ([203.10.76.45]:56908 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab2KAHnJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 03:43:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur@brendeland.net>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        sjur@brendeland.net, dmitry.tarnyagin@stericsson.com
Subject: Re: [RFC virtio-next 0/4] Introduce CAIF Virtio and reversed Vrings
In-Reply-To: <1351723614-4145-1-git-send-email-sjur@brendeland.net>
References: <1351723614-4145-1-git-send-email-sjur@brendeland.net>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 01 Nov 2012 18:11:35 +1030
Message-ID: <87wqy54vo0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sjur Brændeland <sjur@brendeland.net> writes:
> Zero-Copy data transport on the modem is primary goal for CAIF Virtio.
> In order to achieve Zero-Copy the direction of the Virtio rings are
> flipped in the RX direction. So we have implemented the Virtio
> access-function similar to what is found in vhost.c.

So, this adds another host-side virtqueue implementation.

Can we combine them together conveniently?  You pulled out more stuff
into vring.h which is a start, but it's a bit overloaded.

Perhaps we should separate the common fields into struct vring, and use
it to build:

        struct vring_guest {
                struct vring vr;
                u16 last_used_idx;
        };

        struct vring_host {
                struct vring vr;
                u16 last_avail_idx;
        };

I haven't looked closely at vhost to see what it wants, but I would
think we could share more code.

Cheers,
Rusty.
