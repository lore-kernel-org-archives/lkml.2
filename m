Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab0KVHw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 02:52:28 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60265 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab0KVHw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 02:52:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Q7X7idbHY0IELn9rn9QwkrSBCj5GAw+RbXBOrVNnY/6m1yymY4t84iL7zp3v/Qyc9b
         t/GtCSM//THX8AiBh9dG0C2Wjo5cNHN1svC0ejhQUvAGBTbod4v0j4jnyOhreJhznk0K
         5B1VNNB4Hh7v355KIFixXksQa4R0xPxqNgcLM=
Subject: Re: [PATCH v3] netfilter: nf_conntrack_sip: Handle Cisco 7941/7945
 IP phones
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <f0955e6c2110044fa058d0f3ecf945ca@localhost>
References: <f0955e6c2110044fa058d0f3ecf945ca@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 08:52:14 +0100
Message-ID: <1290412334.2756.141.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 21 novembre 2010 à 18:40 -0800, Kevin Cernekee a écrit :
> [v3:
>   Only activate the new forced_dport logic if the IP matches, but the
>   port does not. ]
> 
> Most SIP devices use a source port of 5060/udp on SIP requests, so the
> response automatically comes back to port 5060:
> 
> phone_ip:5060 -> proxy_ip:5060   REGISTER
> proxy_ip:5060 -> phone_ip:5060   100 Trying
> 
> The newer Cisco IP phones, however, use a randomly chosen high source
> port for the SIP request but expect the response on port 5060:
> 
> phone_ip:49173 -> proxy_ip:5060  REGISTER
> proxy_ip:5060 -> phone_ip:5060   100 Trying
> 
> Standard Linux NAT, with or without nf_nat_sip, will send the reply back
> to port 49173, not 5060:
> 
> phone_ip:49173 -> proxy_ip:5060  REGISTER
> proxy_ip:5060 -> phone_ip:49173  100 Trying
> 
> But the phone is not listening on 49173, so it will never see the reply.
> 
> This patch modifies nf_*_sip to work around this quirk by extracting
> the SIP response port from the Via: header, iff the source IP in the
> packet header matches the source IP in the SIP request.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> ---

Thanks for doing this work Keven !

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



