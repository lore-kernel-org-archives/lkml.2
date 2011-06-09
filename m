Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab1FIM2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 08:28:46 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45904 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757445Ab1FIM2p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:28:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=njwnbQzkN2/xFlXZ5/0D1BVPAu2+nDUwKSNZcYepmIPZjrg/63pkF2XtlFdLMEqslk
         +5Fs6sXS1Jh9+dxeL8qrtxoCVLKG8VlQJMHCRBXxMd/dQnDseYUc2soEFl4LYrxXuFYd
         b3lVlDECODI7r2jQ7ahJ0019e97Hce9+vVB0U=
MIME-Version: 1.0
In-Reply-To: <20110609113505.GR5247@suse.de>
References: <1307606573-24704-1-git-send-email-mgorman@suse.de>
 <1307606573-24704-11-git-send-email-mgorman@suse.de> <BANLkTimUE9yb-DegdUk0BbbOGWoUhEBrqw@mail.gmail.com>
 <20110609113505.GR5247@suse.de>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Thu, 9 Jun 2011 14:28:24 +0200
Message-ID: <BANLkTi=8jx8B8fR_+Z76UoTe_jhG9G-Tyw@mail.gmail.com>
Subject: Re: [PATCH 10/14] netvm: Set PF_MEMALLOC as appropriate during SKB processing
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/9 Mel Gorman <mgorman@suse.de>:
> On Thu, Jun 09, 2011 at 12:21:31PM +0200, Micha? Miros?aw wrote:
>> 2011/6/9 Mel Gorman <mgorman@suse.de>:
>> [...]
>> > +/*
>> > + * Limit which protocols can use the PFMEMALLOC reserves to those that are
>> > + * expected to be used for communication with swap.
>> > + */
>> > +static bool skb_pfmemalloc_protocol(struct sk_buff *skb)
>> > +{
>> > +       switch (skb->protocol) {
>> > +       case __constant_htons(ETH_P_ARP):
>> > +       case __constant_htons(ETH_P_IP):
>> > +       case __constant_htons(ETH_P_IPV6):
>> > +       case __constant_htons(ETH_P_8021Q):
>> > +               return true;
>> > +       default:
>> > +               return false;
>> > +       }
>> > +}
>>
>> This is not needed and wrong. Whatever list there will be, it's going
>> to always miss some obscure setup (or not that obscure, like
>> ATAoverEthernet).
>>
>
> NBD is updated in the series to set the socket information
> appropriately but the same cannot be said of AoE. The necessary
> changes have been made IPv4 and IPv6 to handle pfmemalloc sockets
> but the same cannot be necessarily said for the other protocols. Yes,
> the check could be removed but leaving it there makes a clear statement
> on what scenario can be reasonably expected to work.

Ok. Then the comment before skb_pfmemalloc_protocol() is misleading.
It should say that this is a list of protocols which implement the
required special handling of PFMEMALLOC skbs.

Best Regards,
Michał Mirosław
