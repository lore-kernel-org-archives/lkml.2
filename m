Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab1EZR5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:57:52 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48035 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758171Ab1EZR5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:57:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sAn+vOStLTDbUHiDL7Vd47up8kpRCaoYGbV86Ql4n87WvEMsSpLolsvF4cyBtaSXTK
         BGp9dzYLQ7LK/sxzzNb+EyD50D9xx3y2lmL+kZ4yP7mNt/tZJComP43ZnC3oiviI9jiZ
         m+78yBaTnjW6351ZvZbi6mGTwt5G1N+krW6Hg=
Subject: Re: [PATCH v3 resend] netfilter: nf_conntrack_sip: Handle Cisco
 7941/7945 IP phones
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Kevin Cernekee <cernekee@gmail.com>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <4DDE84F2.7080706@netfilter.org>
References: <bc781b295b38241533a2d90c1aea15b3@localhost>
	 <4DDE84F2.7080706@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 19:57:44 +0200
Message-ID: <1306432664.2543.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 26 mai 2011 à 18:50 +0200, Pablo Neira Ayuso a écrit :
> Hi Eric,
> 
> On 20/05/11 06:36, Kevin Cernekee wrote:
> > Most SIP devices use a source port of 5060/udp on SIP requests, so the
> > response automatically comes back to port 5060:
> > 
> > phone_ip:5060 -> proxy_ip:5060   REGISTER
> > proxy_ip:5060 -> phone_ip:5060   100 Trying
> > 
> > The newer Cisco IP phones, however, use a randomly chosen high source
> > port for the SIP request but expect the response on port 5060:
> > 
> > phone_ip:49173 -> proxy_ip:5060  REGISTER
> > proxy_ip:5060 -> phone_ip:5060   100 Trying
> > 
> > Standard Linux NAT, with or without nf_nat_sip, will send the reply back
> > to port 49173, not 5060:
> > 
> > phone_ip:49173 -> proxy_ip:5060  REGISTER
> > proxy_ip:5060 -> phone_ip:49173  100 Trying
> > 
> > But the phone is not listening on 49173, so it will never see the reply.
> > 
> > This patch modifies nf_*_sip to work around this quirk by extracting
> > the SIP response port from the Via: header, iff the source IP in the
> > packet header matches the source IP in the SIP request.
> > 
> > Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> > Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> > Cc: Patrick McHardy <kaber@trash.net>
> 
> @Eric: could you please confirm that you ack'ed this patch? I don't find
> the email with your explicit ack.

Yes I did it ;)

http://www.spinics.net/lists/netfilter/msg49632.html

Thanks !


