Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab1LKW15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 17:27:57 -0500
Received: from gate.crashing.org ([63.228.1.57]:52250 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab1LKW1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 17:27:55 -0500
Message-ID: <1323642447.19891.8.camel@pasglop>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, akong@redhat.com,
        Ohad Ben-Cohen <ohad@wizery.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Mon, 12 Dec 2011 09:27:27 +1100
In-Reply-To: <20111211122544.GC11504@redhat.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>
	 <1322867384.11728.20.camel@pasglop> <87hb1iqls3.fsf@rustcorp.com.au>
	 <20111211122544.GC11504@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-11 at 14:25 +0200, Michael S. Tsirkin wrote:

> Forwarding some results by Amos, who run multiple netperf streams in
> parallel, from an external box to the guest.  TCP_STREAM results were
> noisy.  This could be due to buffering done by TCP, where packet size
> varies even as message size is constant.
> 
> TCP_RR results were consistent. In this benchmark, after switching
> to mandatory barriers, CPU utilization increased by up to 35% while
> throughput went down by up to 14%. the normalized throughput/cpu
> regressed consistently, between 7 and 35%
> 
> The "fix" applied was simply this:

What machine & processor was this  ?

Cheers,
Ben.

> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 3198f2e..fdccb77 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -23,7 +23,7 @@
>  
>  /* virtio guest is communicating with a virtual "device" that actually runs on
>   * a host processor.  Memory barriers are used to control SMP effects. */
> -#ifdef CONFIG_SMP
> +#if 0
>  /* Where possible, use SMP barriers which are more lightweight than mandatory
>   * barriers, because mandatory barriers control MMIO effects on accesses
>   * through relaxed memory I/O windows (which virtio does not use). */
> 
> 
> 


