Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab1BRNes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 08:34:48 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55939 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab1BRNeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 08:34:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=V9dGT852/MVlxw9Mk5ths4ifUFSa/d5PwYo39xHfkub6YaGzXP/3BNPZlO3ZDiFiKO
         ggYD0jVWzuHPIT2egNAtj01gkPbWOq1BegPOmzhfyD/QbnNcLvr6Xvb2t5DfM54sWHZB
         A2JB+8enXueQ7mjCr012jSel2dBbHtwDei12I=
Subject: Re: [PATCH] net: Add default_advmss() methods to blackhole dst_ops
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: George Spelvin <linux@horizon.com>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>
In-Reply-To: <AANLkTi=O1LZzSc8=qMX=R3rJpCVL8eWr1eo6NkiZXS0m@mail.gmail.com>
References: <20110218050321.10415.qmail@science.horizon.com>
	 <1298010735.2642.9.camel@edumazet-laptop>
	 <1298023023.2595.170.camel@edumazet-laptop>
	 <AANLkTi=GRPWNWZuORx1zoJJURE-drqEoMdTuKB9LZ8Ux@mail.gmail.com>
	 <1298035443.6201.51.camel@edumazet-laptop>
	 <AANLkTi=O1LZzSc8=qMX=R3rJpCVL8eWr1eo6NkiZXS0m@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 14:33:25 +0100
Message-ID: <1298036005.6201.58.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 18 février 2011 à 21:29 +0800, Changli Gao a écrit :
> On Fri, Feb 18, 2011 at 9:24 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Le vendredi 18 février 2011 à 21:16 +0800, Changli Gao a écrit :
> >
> >> I am wondering why magic number 256 is used here. Is there a special
> >> reason? Thanks.
> >>
> >
> > It really doesnt matter. SYN message will be dropped anyway.
> >
> > 256 happens to be the default value
> > of /proc/sys/net/ipv4/route/min_adv_mss
> >
> 
> Thanks for your explaining. IMHO, ip_rt_min_advmss is better than a
> magic number, here.
> 

I had this exact idea but found we need struct net pointer to get this
value, not provided in parameters, so I falled back to the 256 value.



