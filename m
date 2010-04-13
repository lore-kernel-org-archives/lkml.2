Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab0DMUiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:38:14 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:35777 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab0DMUiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:38:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wbqhxsyyb0SWfpzd6ioCYyUqhwOM2YgJEjsDUQBoX3S2ZKF+xYfAp27lkZS4Rt2FEN
         srAlUcZKHd1k8SiXbEpL8Q+hs4rqmKdxOf9VRXxTnQCCMooAN6LKCK3/AucewKrXHeiq
         zbCry/BG3tx/JZqLCJExBXFPQ+XYuS0DGGMOM=
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
In-Reply-To: <20100413202548.GA3582@redhat.com>
References: <20100413145944.GA7716@redhat.com>
	 <4BC48F79.5090409@siemens.com> <1271176838.16881.537.camel@edumazet-laptop>
	 <20100413173919.GC26011@redhat.com>
	 <1271183463.16881.545.camel@edumazet-laptop>
	 <20100413202548.GA3582@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 22:38:06 +0200
Message-ID: <1271191086.16881.570.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 13 avril 2010 à 23:25 +0300, Michael S. Tsirkin a écrit :
> On Tue, Apr 13, 2010 at 08:31:03PM +0200, Eric Dumazet wrote:
> > Le mardi 13 avril 2010 à 20:39 +0300, Michael S. Tsirkin a écrit :
> > 
> > > > When a socket with inflight tx packets is closed, we dont block the
> > > > close, we only delay the socket freeing once all packets were delivered
> > > > and freed.
> > > > 
> > > 
> > > Which is wrong, since this is under userspace control, so you get
> > > unkillable processes.
> > > 
> > 
> > We do not get unkillable processes, at least with sockets I was thinking
> > about (TCP/UDP ones).
> > 
> > Maybe tun sockets can behave the same ?
> 
> Looks like that's what my patch does: ip_rcv seems to call
> skb_orphan too.

Well, I was speaking of tx side, you speak of receiving side.
An external flood (coming from another domain) is another problem.

A sender might flood the 'network' inside our domain. How can we
reasonably limit the sender ?

Maybe the answer is 'We can not', but it should be stated somewhere, so
that someone can address this point later.



