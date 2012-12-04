Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab2LDJXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 04:23:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab2LDJXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 04:23:03 -0500
From: Jason Wang <jasowang@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, krkumar2@in.ibm.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        bhutchings@solarflare.com, jwhan@filewood.snu.ac.kr, shiyer@redhat.com
Subject: Re: [net-next rfc v7 1/3] virtio-net: separate fields of sending/receiving queue from virtnet_info
Date: Tue, 04 Dec 2012 17:22:46 +0800
Message-ID: <33871315.gHWf0QtYzd@jason-thinkpad-t430s>
User-Agent: KMail/4.9.2 (Linux/3.7.0-rc6+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121203111848.GD26167@redhat.com>
References: <1354011360-39479-1-git-send-email-jasowang@redhat.com> <3524590.ZWGua7A8ne@jason-thinkpad-t430s> <20121203111848.GD26167@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 03, 2012 01:18:48 PM Michael S. Tsirkin wrote:
> On Mon, Dec 03, 2012 at 01:15:01PM +0800, Jason Wang wrote:
> > > > +
> > > > 
> > > > + /* Work struct for refilling if we run low on memory. */
> > > > 
> > > > + struct delayed_work refill;
> > > 
> > > I can't really see the justificaiton for a refill per queue. Just have
> > > 
> > > one work iterate all the queues if it happens, unless it happens often
> > > 
> > > (in which case, we need to look harder at this anyway).
> > 
> > But during this kind of iteration, we may need enable/disable the napi
> > regardless of whether the receive queue has lots to be refilled. This may
> > add extra latency.
> 
> We are running from the timer, so latency is not a concern I think.

Maybe, anyway it's only called when avaiable memory is low, so it should not 
be an issue.
