Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0DMQkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 12:40:46 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:56681 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab0DMQko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 12:40:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=A9X1Lu5hCjXKrswtn+K1EsWirgWBayuPtNU7mJsb7kM0vxiqAGGx4o4NSHyFXz/zy1
         ZnUjyNo1QUiyOT4zHECoW7aX0ASeoY4TVjab8iVasLJKoH/XrTu/HTLdxjCQ4MF5jtzU
         CvxaTMqFOdPkREBUNGQKkqK0567ygTIDmO8N8=
Subject: Re: [PATCH] tun: orphan an skb on tx
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.hengli.com.au>,
       Paul Moore <paul.moore@hp.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       qemu-devel <qemu-devel@nongnu.org>
In-Reply-To: <4BC48F79.5090409@siemens.com>
References: <20100413145944.GA7716@redhat.com>
	 <4BC48F79.5090409@siemens.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 18:40:38 +0200
Message-ID: <1271176838.16881.537.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 13 avril 2010 à 17:36 +0200, Jan Kiszka a écrit :
> Michael S. Tsirkin wrote:
> > The following situation was observed in the field:
> > tap1 sends packets, tap2 does not consume them, as a result
> > tap1 can not be closed.
> 
> And before that, tap1 may not be able to send further packets to anyone
> else on the bridge as its TX resources were blocked by tap2 - that's
> what we saw in the field.
> 

After the patch, tap1 is able to flood tap2, and tap3/tap4 not able to
send one single frame. Is it OK ?

Back to the problem : tap1 cannot be closed.

Why ? because of refcounts ?

When a socket with inflight tx packets is closed, we dont block the
close, we only delay the socket freeing once all packets were delivered
and freed.



