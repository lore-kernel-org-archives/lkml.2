Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab1BRNRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 08:17:05 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46018 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab1BRNRD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 08:17:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cKDy30PMHp4jxSAm7qfKIa42y275IAuzQyRTIbrP3d67/s8E8FoNSNPSGwyf3hAXuG
         FNj+q92WdoE+3u4lDyhuO0lJ4X+o5Nerv2m7GjkUX5/UkuD6d3sFgP3t1mPE1uMEnDAr
         tkKKSPlSnvobEg5DUvekGJGh289O1IYZ+bMPo=
MIME-Version: 1.0
In-Reply-To: <1298023023.2595.170.camel@edumazet-laptop>
References: <20110218050321.10415.qmail@science.horizon.com>
 <1298010735.2642.9.camel@edumazet-laptop> <1298023023.2595.170.camel@edumazet-laptop>
From: Changli Gao <xiaosuo@gmail.com>
Date: Fri, 18 Feb 2011 21:16:42 +0800
Message-ID: <AANLkTi=GRPWNWZuORx1zoJJURE-drqEoMdTuKB9LZ8Ux@mail.gmail.com>
Subject: Re: [PATCH] net: Add default_advmss() methods to blackhole dst_ops
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: George Spelvin <linux@horizon.com>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 5:57 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
> I suspect following patch is needed
>
> CC Roland Dreier <roland@purestorage.com> because he fixed the
> default_mtu problem in commit ec831ea72ee5d7d47
> (net: Add default_mtu() methods to blackhole dst_ops)
>
> Thanks !
>
> [PATCH] net: Add default_advmss() methods to blackhole dst_ops
>
> Commit 0dbaee3b37e118a (net: Abstract default ADVMSS behind an
> accessor.) introduced a possible crash in tcp_connect_init(), when
> dst->default_advmss() is called from dst_metric_advmss()
>
> Reported-by: George Spelvin <linux@horizon.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Roland Dreier <roland@purestorage.com>
> ---
>  net/ipv4/route.c |    7 +++++++
>  net/ipv6/route.c |    6 ++++++
>  2 files changed, 13 insertions(+)
>
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 788a3e7..5edb605 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -2712,6 +2712,12 @@ static unsigned int ipv4_blackhole_default_mtu(const struct dst_entry *dst)
>        return 0;
>  }
>
> +static unsigned int ipv4_blackhole_default_advmss(const struct dst_entry *dst)
> +{
> +       return 256;
> +}
> +
> +

I am wondering why magic number 256 is used here. Is there a special
reason? Thanks.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
