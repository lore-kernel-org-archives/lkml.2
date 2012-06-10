Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab2FJKVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 06:21:20 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40668 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab2FJKVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 06:21:19 -0400
Subject: Re: [PATCH] virtio-net: fix a race on 32bit arches
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stephen Hemminger <shemminger@vyatta.com>
In-Reply-To: <20120610070325.GA14010@redhat.com>
References: <1338971724.2760.3913.camel@edumazet-glaptop>
	 <1338972341.2760.3944.camel@edumazet-glaptop>
	 <87ipezhdvx.fsf@rustcorp.com.au>  <20120610070325.GA14010@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jun 2012 12:21:14 +0200
Message-ID: <1339323674.6001.246.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-06-10 at 10:03 +0300, Michael S. Tsirkin wrote:

> One question though: do we want to lay the structure
> out so that the rx sync structure precedes the rx counters?
> 

I am not sure its worth having holes in the structure, since its percpu
data.

That would be 8 bytes lost per cpu and per device.


