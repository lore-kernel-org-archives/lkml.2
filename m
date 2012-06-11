Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab2FKDXn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 23:23:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39472 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab2FKDXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 23:23:42 -0400
Date: Sun, 10 Jun 2012 20:23:41 -0700 (PDT)
Message-Id: <20120610.202341.2146277133562218686.davem@davemloft.net>
To: mst@redhat.com
Cc: eric.dumazet@gmail.com, jasowang@redhat.com, netdev@vger.kernel.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, shemminger@vyatta.com
Subject: Re: [PATCH] virtio-net: fix a race on 32bit arches
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120610102512.GB6793@redhat.com>
References: <1338971724.2760.3913.camel@edumazet-glaptop>
	<20120610102512.GB6793@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Sun, 10 Jun 2012 13:25:12 +0300

> On Wed, Jun 06, 2012 at 10:35:24AM +0200, Eric Dumazet wrote:
>> From: Eric Dumazet <edumazet@google.com>
>> 
>> commit 3fa2a1df909 (virtio-net: per cpu 64 bit stats (v2)) added a race
>> on 32bit arches.
>> 
>> We must use separate syncp for rx and tx path as they can be run at the
>> same time on different cpus. Thus one sequence increment can be lost and
>> readers spin forever.
>> 
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Cc: Stephen Hemminger <shemminger@vyatta.com>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Cc: Jason Wang <jasowang@redhat.com>
> 
> I'm still thinking about moving tx to take a xmit lock long term,
> meanwhile this fix appears appropriate for 3.5.
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Dave, can you pick this up pls?

Done, thanks.
