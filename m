Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab2LQApR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 19:45:17 -0500
Received: from mail.us.es ([193.147.175.20]:57969 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab2LQApL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 19:45:11 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus2 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.97.6/15856. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-99.2/7.5):. 
 Processed in 11.732339 secs); 17 Dec 2012 00:45:10 -0000
X-Envelope-From: pneira@us.es
Date: Mon, 17 Dec 2012 01:44:57 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Kevin Cernekee <cernekee@gmail.com>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] netfilter: nf_conntrack_sip: Handle Cisco 7941/7945
 IP phones
Message-ID: <20121217004457.GA12234@1984>
References: <f0955e6c2110044fa058d0f3ecf945ca@localhost>
 <1290412334.2756.141.camel@edumazet-laptop>
 <1355703441.18919.6.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1355703441.18919.6.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, Dec 17, 2012 at 12:17:21AM +0000, David Woodhouse wrote:
> On Mon, 2010-11-22 at 08:52 +0100, Eric Dumazet wrote:
> > Le dimanche 21 novembre 2010 à 18:40 -0800, Kevin Cernekee a écrit :
> > > [v3:
> > >   Only activate the new forced_dport logic if the IP matches, but the
> > >   port does not. ]
> > > 
> > > Most SIP devices use a source port of 5060/udp on SIP requests, so the
> > > response automatically comes back to port 5060:
> > > 
> > > phone_ip:5060 -> proxy_ip:5060   REGISTER
> > > proxy_ip:5060 -> phone_ip:5060   100 Trying
> > > 
> > > The newer Cisco IP phones, however, use a randomly chosen high source
> > > port for the SIP request but expect the response on port 5060:
> > > 
> > > phone_ip:49173 -> proxy_ip:5060  REGISTER
> > > proxy_ip:5060 -> phone_ip:5060   100 Trying
> > > 
> > > Standard Linux NAT, with or without nf_nat_sip, will send the reply back
> > > to port 49173, not 5060:
> > > 
> > > phone_ip:49173 -> proxy_ip:5060  REGISTER
> > > proxy_ip:5060 -> phone_ip:49173  100 Trying
> > > 
> > > But the phone is not listening on 49173, so it will never see the reply.
> > > 
> > > This patch modifies nf_*_sip to work around this quirk by extracting
> > > the SIP response port from the Via: header, iff the source IP in the
> > > packet header matches the source IP in the SIP request.
> > > 
> > > Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> > > ---
> > 
> > Thanks for doing this work Keven !
> > 
> > Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> 
> What happened to this? OpenWRT is still carrying it, and it broke in
> 3.7. Here's a completely untested update...

I requested Kevin to resend a new version based on the current kernel
tree while spinning on old pending patches since I have no access to
that hardware, but no luck.

So I'll review this and, since OpenWRT is carrying, I guess we can get
this into net-next merge window.

Thanks for the reminder.
