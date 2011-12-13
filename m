Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab1LNXvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 18:51:00 -0500
Received: from ozlabs.org ([203.10.76.45]:56358 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196Ab1LNXu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 18:50:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Amit Shah <amit.shah@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] virtio_net: fix refill related races
In-Reply-To: <20111212115405.GB7946@redhat.com>
References: <20111207152120.GA23417@redhat.com> <8739cvisqe.fsf@rustcorp.com.au> <20111211144428.GB14381@redhat.com> <878vmioh10.fsf@rustcorp.com.au> <20111212115405.GB7946@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 13 Dec 2011 13:05:11 +1030
Message-ID: <87iplltd0g.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011 13:54:06 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Mon, Dec 12, 2011 at 09:25:07AM +1030, Rusty Russell wrote:
> > Orthogonally, the refill-stop code is still buggy, as you noted.
> 
> Sorry I don't understand how it's still buggy.

Both places where we call:

	cancel_delayed_work_sync(&vi->refill);

Do not actually guarantee that vi->refill isn't running, because it
can requeue itself.  A 'bool no_more_refill' field seems like the
simplest fix for this, but I don't think it's sufficient.

Tejun, is this correct?  What's the correct way to synchronously stop a
delayed_work which can "schedule_delayed_work(&vi->refill, HZ/2);" on
itself?

Thanks,
Rusty.
