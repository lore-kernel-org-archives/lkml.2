Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab1EZQ61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:58:27 -0400
Received: from mail.us.es ([193.147.175.20]:44840 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab1EZQ60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:58:26 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 May 2011 12:58:25 EDT
Message-ID: <4DDE84F2.7080706@netfilter.org>
Date: Thu, 26 May 2011 18:50:58 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20110506 Icedove/3.0.11
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Kevin Cernekee <cernekee@gmail.com>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 resend] netfilter: nf_conntrack_sip: Handle Cisco 7941/7945
 IP phones
References: <bc781b295b38241533a2d90c1aea15b3@localhost>
In-Reply-To: <bc781b295b38241533a2d90c1aea15b3@localhost>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On 20/05/11 06:36, Kevin Cernekee wrote:
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
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Patrick McHardy <kaber@trash.net>

@Eric: could you please confirm that you ack'ed this patch? I don't find
the email with your explicit ack.
