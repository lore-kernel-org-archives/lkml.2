Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2DCBxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 21:53:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65381 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab2DCBxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 21:53:23 -0400
Subject: Re: [PATCH] phonet: Check input from user before allocating
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: remi@remlab.net, levinsasha928@gmail.com, remi.denis-courmont@nokia.com,
        davej@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120402.174006.70116829696492189.davem@davemloft.net>
References: <1333398660-11552-1-git-send-email-levinsasha928@gmail.com>
	 <201204022201.41808.remi@remlab.net>
	 <20120402.174006.70116829696492189.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Apr 2012 03:53:17 +0200
Message-ID: <1333417997.18626.1.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 17:40 -0400, David Miller wrote:
> From: "Rémi Denis-Courmont" <remi@remlab.net>
> Date: Mon, 2 Apr 2012 22:01:40 +0300
> 
> > Le lundi 2 avril 2012 23:31:00 Sasha Levin, vous avez écrit :
> >> A phonet packet is limited to USHRT_MAX bytes, this is never checked during
> >> tx which means that the user can specify any size he wishes, and the kernel
> >> will attempt to allocate that size.
> > 
> > Does this really solve the problem?  I guess 128kb is still possible with 
> > USHRT_MAX plus skbuff overhead, which might still trigger OOM relatively 
> > easily once the memory gets sufficiently fragmented.
> > 
> > How does UDP deal with this?
> 
> UDP generates a fragment list of MTU sized SKBs.
> 
> Phonet could avoid the large allocations by building page based
> SKBs.

Not that AF_UNIX does nothing in this respect, it can use order-XX pages
for large datagrams.

(I beleve I sent a patch some time ago to address this point)



