Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab2FFPOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:14:37 -0400
Received: from mail.vyatta.com ([76.74.103.46]:54533 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533Ab2FFPOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:14:35 -0400
Date: Wed, 6 Jun 2012 08:14:32 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-net: fix a race on 32bit arches
Message-ID: <20120606081432.6b602065@nehalam.linuxnetplumber.net>
In-Reply-To: <20120606144941.GA17092@redhat.com>
References: <1338971724.2760.3913.camel@edumazet-glaptop>
	<1338972341.2760.3944.camel@edumazet-glaptop>
	<20120606111357.GA15070@redhat.com>
	<1338988210.2760.4485.camel@edumazet-glaptop>
	<20120606144941.GA17092@redhat.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012 17:49:42 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Sounds good, but I have a question: this realies on counters
> being atomic on 64 bit.
> Would not it be better to always use a seqlock even on 64 bit?
> This way counters would actually be correct and in sync.
> As it is if we want e.g. average packet size,
> we can not rely e.g. on it being bytes/packets.

This has not been a requirement on real physical devices; therefore
the added overhead is not really justified.

Many network cards use counters in hardware to count packets/bytes
and there is no expectation of atomic access there.
