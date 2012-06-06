Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab2FFUAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:00:07 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64762 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2FFUAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:00:04 -0400
Subject: Re: [PATCH] virtio-net: fix a race on 32bit arches
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stephen Hemminger <shemminger@vyatta.com>
In-Reply-To: <20120606165754.GA19357@redhat.com>
References: <1338971724.2760.3913.camel@edumazet-glaptop>
	 <1338972341.2760.3944.camel@edumazet-glaptop>
	 <20120606111357.GA15070@redhat.com>
	 <1338988210.2760.4485.camel@edumazet-glaptop>
	 <20120606144941.GA17092@redhat.com>
	 <1338995944.26966.6.camel@edumazet-glaptop>
	 <20120606165754.GA19357@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jun 2012 22:00:00 +0200
Message-ID: <1339012800.26966.53.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 19:57 +0300, Michael S. Tsirkin wrote:

> So for virtio since all counters get incremented from bh we can
> ensure they are read atomically, simply but reading them
> from the correct CPU with bh disabled.
> And then we don't need u64_stats_sync at all.
> 

Really ? How are you going to read 64bit stats from foreign cpus on
32bit arches, without additional cost in fast path ?

You should read include/linux/u64_stats_sync.h to fully understand the
issues.



