Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab1FVCn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 22:43:57 -0400
Received: from ozlabs.org ([203.10.76.45]:34240 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757816Ab1FVCnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 22:43:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ohad Ben-Cohen <ohad@wizery.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, Brian Swetland <swetland@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [RFC 7/8] drivers: introduce rpmsg, a remote-processor messaging bus
In-Reply-To: <1308640714-17961-8-git-send-email-ohad@wizery.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com> <1308640714-17961-8-git-send-email-ohad@wizery.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Wed, 22 Jun 2011 12:12:33 +0930
Message-ID: <87liwu8u3q.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jun 2011 10:18:33 +0300, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Add a virtio-based IPC bus, which enables kernel users to communicate
> with remote processors over shared memory using a simple messaging
> protocol.

Wow, sometimes one writes a standard and people use it.  Thanks!

I'm still digesting exactly what you're doing, but this is a bit
unconventional:

> +	/* Platform must supply pre-allocated uncached buffers for now */
> +	vdev->config->get(vdev, VPROC_BUF_ADDR, &addr, sizeof(addr));
> +	vdev->config->get(vdev, VPROC_BUF_NUM, &num_bufs, sizeof(num_bufs));
> +	vdev->config->get(vdev, VPROC_BUF_SZ, &buf_size, sizeof(buf_size));
> +	vdev->config->get(vdev, VPROC_BUF_PADDR, &vrp->phys_base,
> +						sizeof(vrp->phys_base));

The normal way is to think of the config space as a structure, and use
offsets rather than using an enum value to distinguish the fields.

> +#define RPMSG_NAME_SIZE			32
> +#define RPMSG_DEVICE_MODALIAS_FMT	"rpmsg:%s"
> +
> +struct rpmsg_device_id {
> +	char name[RPMSG_NAME_SIZE];
> +	kernel_ulong_t driver_data	/* Data private to the driver */
> +			__attribute__((aligned(sizeof(kernel_ulong_t))));
> +};

This alignment directive seems overkill...

> +#define VIRTIO_ID_RPMSG		10 /* virtio remote processor messaging */

I think you want 6.  Plan 9 jumped ahead to grab 9 :)

Cheers,
Rusty.
