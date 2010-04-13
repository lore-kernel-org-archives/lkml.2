Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0DMUak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:30:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143Ab0DMUai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:30:38 -0400
Date: Tue, 13 Apr 2010 23:25:48 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>,
       "David S. Miller" <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.hengli.com.au>,
       Paul Moore <paul.moore@hp.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH] tun: orphan an skb on tx
Message-ID: <20100413202548.GA3582@redhat.com>
References: <20100413145944.GA7716@redhat.com> <4BC48F79.5090409@siemens.com> <1271176838.16881.537.camel@edumazet-laptop> <20100413173919.GC26011@redhat.com> <1271183463.16881.545.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1271183463.16881.545.camel@edumazet-laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 08:31:03PM +0200, Eric Dumazet wrote:
> Le mardi 13 avril 2010 à 20:39 +0300, Michael S. Tsirkin a écrit :
> 
> > > When a socket with inflight tx packets is closed, we dont block the
> > > close, we only delay the socket freeing once all packets were delivered
> > > and freed.
> > > 
> > 
> > Which is wrong, since this is under userspace control, so you get
> > unkillable processes.
> > 
> 
> We do not get unkillable processes, at least with sockets I was thinking
> about (TCP/UDP ones).
> 
> Maybe tun sockets can behave the same ?

Looks like that's what my patch does: ip_rcv seems to call
skb_orphan too.

> Herbert Acked your patch, so I guess its OK, but I think it can be
> dangerous.
> Anyway my feeling is that we try to add various mechanisms to keep a
> hostile user flooding another one.
> 
> For example, UDP got memory accounting quite recently, and we added
> socket backlog limits very recently. It was considered not needed few
> years ago.
> 



