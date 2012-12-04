Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab2LDJXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 04:23:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab2LDJXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 04:23:34 -0500
From: Jason Wang <jasowang@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: mst@redhat.com, krkumar2@in.ibm.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        bhutchings@solarflare.com, jwhan@filewood.snu.ac.kr, shiyer@redhat.com
Subject: Re: [net-next rfc v7 1/3] virtio-net: separate fields of sending/receiving queue from virtnet_info
Date: Tue, 04 Dec 2012 17:23:21 +0800
Message-ID: <1586636.MnKZJZo7n1@jason-thinkpad-t430s>
User-Agent: KMail/4.9.2 (Linux/3.7.0-rc6+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <87zk1uh48g.fsf@rustcorp.com.au>
References: <1354011360-39479-1-git-send-email-jasowang@redhat.com> <3524590.ZWGua7A8ne@jason-thinkpad-t430s> <87zk1uh48g.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 04, 2012 02:13:11 PM Rusty Russell wrote:
> Jason Wang <jasowang@redhat.com> writes:
> > On Monday, December 03, 2012 12:25:42 PM Rusty Russell wrote:
> >> > +
> >> > +	/* Work struct for refilling if we run low on memory. */
> >> > +	struct delayed_work refill;
> >> 
> >> I can't really see the justificaiton for a refill per queue.  Just have
> >> one work iterate all the queues if it happens, unless it happens often
> >> (in which case, we need to look harder at this anyway).
> > 
> > But during this kind of iteration, we may need enable/disable the napi
> > regardless of whether the receive queue has lots to be refilled. This may
> > add extra latency.
> 
> Sure, but does it actually happen?  We only use the work when we run out
> of memory.  If this happens in normal behaviour we need to change
> something else...

True, I will change to use a global one.

Thanks
> 
> Thanks,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
