Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2KDXsI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 18:48:08 -0500
Received: from ozlabs.org ([203.10.76.45]:35634 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab2KDXrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 18:47:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jason Wang <jasowang@redhat.com>, mst@redhat.com, davem@davemloft.net,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        krkumar2@in.ibm.com
Cc: kvm@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: Re: [rfc net-next v6 3/3] virtio-net: change the number of queues through ethtool
In-Reply-To: <1351591403-23065-4-git-send-email-jasowang@redhat.com>
References: <1351591403-23065-1-git-send-email-jasowang@redhat.com> <1351591403-23065-4-git-send-email-jasowang@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 05 Nov 2012 10:16:02 +1030
Message-ID: <871ug9yls5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wang <jasowang@redhat.com> writes:
> This patch implement the {set|get}_channels method of ethool to allow user to
> change the number of queues dymaically when the device is running. This would
> let the user to tune the device for specific applications.
...
> +	/* Only two modes were support currently */
> +	if (queue_pairs == 0)
> +		return -EINVAL;
> +	if (queue_pairs != vi->total_queue_pairs - 1 && queue_pairs != 1)
> +		return -EINVAL;

OK, so you let them do all or nothing, but this three-way test is
pretty unclear.

In fact, the whole total_queue_pairs/num_queue_pairs thing is weird (and
uncommented).  I think for "total" you mean "max"; the maximum possible
queue pair number.

Let me go back and review the previous patch again...

Cheers,
Rusty.
