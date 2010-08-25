Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab0HYMRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 08:17:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41220 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab0HYMRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 08:17:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iLCzlQFP65qbt+QWVUPkdlLqQPCi3efz82EJAwyUeXsuK7Qbkg23gL3pwK5HeWaai3
         bo3cPJxljgHYjaY9bpnMUj4LuWPeC2SPNM3z+J1A5kWa4ZZ+YbdXql3yX1peOnLBpvvd
         FOatAXhMJ2FPfdnA0iuxIH9W+pXAYUznGF0UI=
Subject: Re: RFC: MTU for serving NFS on Infiniband
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Marc Aurele La France <tsi@ualberta.ca>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
In-Reply-To: <20100825121058.GA28498@ms2.inr.ac.ru>
References: <alpine.LNX.2.00.1008230842290.9325@abcyxhiz.aict.ualberta.ca>
	 <20100823080543.319143e3@nehalam>
	 <alpine.WNT.2.00.1008240856170.2000@cluij.ucs.ualberta.ca>
	 <1282672647.2302.15.camel@achroite.uk.solarflarecom.com>
	 <alpine.WNT.2.00.1008241338470.1132@cluij.ucs.ualberta.ca>
	 <1282688441.22839.34.camel@localhost> <20100824153920.63360072@s6510>
	 <1282715698.2467.681.camel@edumazet-laptop>
	 <20100825121058.GA28498@ms2.inr.ac.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 14:17:43 +0200
Message-ID: <1282738663.2487.207.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 25 août 2010 à 16:10 +0400, Alexey Kuznetsov a écrit :
> Hello!
> 
> > It is, but ip_append_data() is allocating a huge head if MTU is huge.
> 
> Hmm, strange, as I remember, it was supposed to work right.
> 
> If the device supports SG (which is required to accept non-linear skbs anyway),
> then ip_append_* should allocate skbs not rounded up to mtu and we should
> allocate small skb with NFS header only. Does not it work?
> 
> I can only guess one possible trap: people could do _one_ huge ip_append_data()
> (instead of "planned" scenario, when the header is sent with ip_append_data()
> and the following payload is appended with ip_append_page()). Huge ip_append_data()
> will generate huge skb indeed. Is this the problem?
> 
> 
> BTW this issue could be revisited and this "will generate huge" can be reconsidered.
> Automatic generation of fragmented skbs was deliberately suppressed, because it was
> found that all devices existing at the moment when this code was written
> are strongly biased against SG. Current code tries to _avoid_ generating
> non-linear skbs, unless it is intended for zero-copy, which compensated
> bias against SG. Modern hardware should work better.
> 
> Alexey

Hi Alexey,

Few hours ago, I privately asked to Marc Aurele if its infiniband device
was supporting NETIF_F_SG in its features ;)

Thanks !


