Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab2LDDsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 22:48:07 -0500
Received: from ozlabs.org ([203.10.76.45]:58271 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab2LDDsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 22:48:06 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, krkumar2@in.ibm.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        bhutchings@solarflare.com, jwhan@filewood.snu.ac.kr, shiyer@redhat.com
Subject: Re: [net-next rfc v7 1/3] virtio-net: separate fields of sending/receiving queue from virtnet_info
In-Reply-To: <3524590.ZWGua7A8ne@jason-thinkpad-t430s>
References: <1354011360-39479-1-git-send-email-jasowang@redhat.com> <1354011360-39479-2-git-send-email-jasowang@redhat.com> <87y5hfj3vl.fsf@rustcorp.com.au> <3524590.ZWGua7A8ne@jason-thinkpad-t430s>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 04 Dec 2012 14:13:11 +1030
Message-ID: <87zk1uh48g.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wang <jasowang@redhat.com> writes:
> On Monday, December 03, 2012 12:25:42 PM Rusty Russell wrote:
>> > +
>> > +	/* Work struct for refilling if we run low on memory. */
>> > +	struct delayed_work refill;
>> 
>> I can't really see the justificaiton for a refill per queue.  Just have
>> one work iterate all the queues if it happens, unless it happens often
>> (in which case, we need to look harder at this anyway).
>
> But during this kind of iteration, we may need enable/disable the napi 
> regardless of whether the receive queue has lots to be refilled. This may add 
> extra latency. 

Sure, but does it actually happen?  We only use the work when we run out
of memory.  If this happens in normal behaviour we need to change
something else...

Thanks,
Rusty.
