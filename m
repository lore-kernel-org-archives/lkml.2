Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab0DMSbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:31:11 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33126 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab0DMSbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:31:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eFMh/L7PefmmWfCcZyAhGbi/TIxTrYTie0aWrX0wEt190Y6qQeFaKCNtaKivlWfLeY
         DbED+6PABDI75dhkv+/In0IGg2psL2B2z5nfORLlPM8Hsx9YactBk0pYxZIg4NV2imZ3
         Sz1rX6Qhisoc3laqlJ7vQ2YI+1TexVSNsaSxY=
Subject: Re: [PATCH] tun: orphan an skb on tx
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>,
       "David S. Miller" <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.hengli.com.au>,
       Paul Moore <paul.moore@hp.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       qemu-devel <qemu-devel@nongnu.org>
In-Reply-To: <20100413173919.GC26011@redhat.com>
References: <20100413145944.GA7716@redhat.com>
	 <4BC48F79.5090409@siemens.com> <1271176838.16881.537.camel@edumazet-laptop>
	 <20100413173919.GC26011@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 20:31:03 +0200
Message-ID: <1271183463.16881.545.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 13 avril 2010 à 20:39 +0300, Michael S. Tsirkin a écrit :

> > When a socket with inflight tx packets is closed, we dont block the
> > close, we only delay the socket freeing once all packets were delivered
> > and freed.
> > 
> 
> Which is wrong, since this is under userspace control, so you get
> unkillable processes.
> 

We do not get unkillable processes, at least with sockets I was thinking
about (TCP/UDP ones).

Maybe tun sockets can behave the same ?

Herbert Acked your patch, so I guess its OK, but I think it can be
dangerous.

Anyway my feeling is that we try to add various mechanisms to keep a
hostile user flooding another one.

For example, UDP got memory accounting quite recently, and we added
socket backlog limits very recently. It was considered not needed few
years ago.



