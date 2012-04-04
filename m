Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab2DDQFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 12:05:03 -0400
Received: from mail.vyatta.com ([76.74.103.46]:55666 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620Ab2DDQFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 12:05:00 -0400
Date: Wed, 4 Apr 2012 09:04:52 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] marvell sky2 driver: fix so it works without
 unaligned accesses
Message-ID: <20120404090452.7f13a652@s6510.linuxnetplumber.net>
In-Reply-To: <201204041419.q34EJ49H025297@farm-0012.internal.tilera.com>
References: <20120403.174610.2089715131687430500.davem@davemloft.net>
	<1333469916.18626.284.camel@edumazet-glaptop>
	<201204031527.q33FR04i031747@farm-0027.internal.tilera.com>
	<201204041419.q34EJ49H025297@farm-0012.internal.tilera.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2012 10:13:32 -0400
Chris Metcalf <cmetcalf@tilera.com> wrote:

> The driver uses a receive_new() routine that ends up requiring unaligned
> accesses in IP header processing.  If the architecture doesn't support
> efficient unaligned accesses, and SKY2_HW_RAM_BUFFER is set,
> just copy all ingress packets to the bounce buffers instead.
> Thanks to Eric Dumazet for pointing out the SKY2_HW_RAM_BUFFER issue.
> 
> This allows the driver to be used on the Tilera TILEmpower-Gx, since
> the tile architecture doesn't currently handle kernel unaligned accesses,
> just userspace.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Still kind of ugly, I will cleanup

