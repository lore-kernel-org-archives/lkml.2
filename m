Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab1LNXyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 18:54:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57151 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab1LNXyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 18:54:17 -0500
Date: Wed, 14 Dec 2011 15:54:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit.shah@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] virtio_net: fix refill related races
Message-ID: <20111214235412.GA29835@google.com>
References: <20111207152120.GA23417@redhat.com>
 <8739cvisqe.fsf@rustcorp.com.au>
 <20111211144428.GB14381@redhat.com>
 <878vmioh10.fsf@rustcorp.com.au>
 <20111212115405.GB7946@redhat.com>
 <87iplltd0g.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iplltd0g.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rusty.

On Tue, Dec 13, 2011 at 01:05:11PM +1030, Rusty Russell wrote:
> Both places where we call:
> 
> 	cancel_delayed_work_sync(&vi->refill);
> 
> Do not actually guarantee that vi->refill isn't running, because it
> can requeue itself.  A 'bool no_more_refill' field seems like the
> simplest fix for this, but I don't think it's sufficient.
> 
> Tejun, is this correct?  What's the correct way to synchronously stop a
> delayed_work which can "schedule_delayed_work(&vi->refill, HZ/2);" on
> itself?

cancel_delayed_work_sync() itself should be good enough.  It first
steals the pending state and then waits for it to finish if in-flight.
Queueing itself afterwards becomes noop.

Thanks.

-- 
tejun
