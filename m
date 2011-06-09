Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab1FIKVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 06:21:53 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54725 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab1FIKVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 06:21:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FKQ73pL+tgeMGe8K4geoR3tHvLsCM8Qwf+H3d65JPfy9Y1KLG3Apu35aGFJIjp5iCs
         ukO/s0WD23Vprwsf+fNVFCY5FvIRIpYAdxUGZWApgvVaM+dj9BMRr2yQsyqgYzNp81ZM
         Kybl4XlvCWI5mbOUx28LgtjnA3lUoWsrRA7iQ=
MIME-Version: 1.0
In-Reply-To: <1307606573-24704-11-git-send-email-mgorman@suse.de>
References: <1307606573-24704-1-git-send-email-mgorman@suse.de> <1307606573-24704-11-git-send-email-mgorman@suse.de>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Thu, 9 Jun 2011 12:21:31 +0200
Message-ID: <BANLkTimUE9yb-DegdUk0BbbOGWoUhEBrqw@mail.gmail.com>
Subject: Re: [PATCH 10/14] netvm: Set PF_MEMALLOC as appropriate during SKB processing
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/9 Mel Gorman <mgorman@suse.de>:
[...]
> +/*
> + * Limit which protocols can use the PFMEMALLOC reserves to those that are
> + * expected to be used for communication with swap.
> + */
> +static bool skb_pfmemalloc_protocol(struct sk_buff *skb)
> +{
> +       switch (skb->protocol) {
> +       case __constant_htons(ETH_P_ARP):
> +       case __constant_htons(ETH_P_IP):
> +       case __constant_htons(ETH_P_IPV6):
> +       case __constant_htons(ETH_P_8021Q):
> +               return true;
> +       default:
> +               return false;
> +       }
> +}

This is not needed and wrong. Whatever list there will be, it's going
to always miss some obscure setup (or not that obscure, like
ATAoverEthernet).

Best Regards,
Micha³ Miros³aw
