Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab2LCLQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 06:16:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab2LCLQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 06:16:11 -0500
Date: Mon, 3 Dec 2012 13:18:48 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, krkumar2@in.ibm.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        bhutchings@solarflare.com, jwhan@filewood.snu.ac.kr, shiyer@redhat.com
Subject: Re: [net-next rfc v7 1/3] virtio-net: separate fields of
 sending/receiving queue from virtnet_info
Message-ID: <20121203111848.GD26167@redhat.com>
References: <1354011360-39479-1-git-send-email-jasowang@redhat.com>
 <1354011360-39479-2-git-send-email-jasowang@redhat.com>
 <87y5hfj3vl.fsf@rustcorp.com.au>
 <3524590.ZWGua7A8ne@jason-thinkpad-t430s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3524590.ZWGua7A8ne@jason-thinkpad-t430s>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 01:15:01PM +0800, Jason Wang wrote:
> > > +
> 
> > > + /* Work struct for refilling if we run low on memory. */
> 
> > > + struct delayed_work refill;
> 
> >
> 
> > I can't really see the justificaiton for a refill per queue. Just have
> 
> > one work iterate all the queues if it happens, unless it happens often
> 
> > (in which case, we need to look harder at this anyway).
> 
>  
> 
> But during this kind of iteration, we may need enable/disable the napi
> regardless of whether the receive queue has lots to be refilled. This may add
> extra latency.

We are running from the timer, so latency is not a concern I think.

-- 
MST
