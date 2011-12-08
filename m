Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1LHJMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 04:12:30 -0500
Received: from ozlabs.org ([203.10.76.45]:50672 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab1LHJMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:12:08 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit.shah@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] virtio_net: fix refill related races
In-Reply-To: <20111207152120.GA23417@redhat.com>
References: <20111207152120.GA23417@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 08 Dec 2011 15:07:29 +1030
Message-ID: <8739cvisqe.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Dec 2011 17:21:22 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> Fix theoretical races related to refill work:
> 1. After napi is disabled by ndo_stop, refill work
>    can run and re-enable it.
> 2. Refill can reschedule itself, if this happens
>    it can run after cancel_delayed_work_sync,
>    and will access device after it is destroyed.
> 
> As a solution, add flags to track napi state and
> to disable refill, and toggle them on start, stop
> and remove; check these flags on refill.

Why isn't a "dont-readd" flag sufficient?

Cheers,
Rusty.
