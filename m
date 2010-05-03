Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab0ECLaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 07:30:09 -0400
Received: from smtp-out.google.com ([74.125.121.35]:37499 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab0ECLaC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 07:30:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=CKOfCVFk6AjBQexqh+UAnB31DQhUlcXwYw0ztyJaJZ5SagBdpPyDgv8RQ7cdsJE7B
	SpK2DjGOA2U8/rJCSap1A==
MIME-Version: 1.0
In-Reply-To: <4BDC543F.7060500@trash.net>
References: <20100501032014.406353538@vergenet.net>
	 <20100501032120.298829234@vergenet.net> <4BDC543F.7060500@trash.net>
Date: Mon, 3 May 2010 13:29:46 +0200
Message-ID: <AANLkTikIzHuzxo4z1_8_fEGLBC2-0Uz0X8SOc8n2msuX@mail.gmail.com>
Subject: Re: [patch v2.2 1/4] [PATCH v2.1 1/4] netfilter: xt_ipvs (netfilter 
	matcher for IPVS)
From: Hannes Eder <heder@google.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       netfilter@vger.kernel.org, Wensong Zhang <wensong@linux-vs.org>,
       Julius Volz <julius.volz@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for picking this series of patches up again and thanks for
the feedback.

I'll send an updated version in the next days.

Cheers, -Hannes

On Sat, May 1, 2010 at 18:18, Patrick McHardy <kaber@trash.net> wrote:
> Simon Horman wrote:
>
>> @@ -0,0 +1,25 @@
>> +#ifndef _XT_IPVS_H
>> +#define _XT_IPVS_H 1
>
> You don't need to define a value.
>
>> +config NETFILTER_XT_MATCH_IPVS
>> +     tristate '"ipvs" match support'
>> +     depends on IP_VS
>> +     depends on NETFILTER_ADVANCED
>> +     help
>> +       This option allows you to match against IPVS properties of a packet.
>> +
>> +       If unsure, say N.
>
> You're using conntrack symbols, so this seems to need a dependency
> on NF_CONNTRACK.
>
>> +static bool ipvs_mt_check(const struct xt_mtchk_param *par)
>
> We've changed the signature to "int" in nf-next to be able to
> return errno codes. Please rebase your patches onto nf-next-2.6.git.
>
> Please also CC netfilter-devel at least for those parts that affect
> non-IPVS netfilter.
>
>> +{
>> +     if (par->family != NFPROTO_IPV4
>> +#ifdef CONFIG_IP_VS_IPV6
>> +         && par->family != NFPROTO_IPV6
>> +#endif
>> +             ) {
>> +             pr_info("protocol family %u not supported\n", par->family);
>> +             return false;
>> +     }
>> +
>> +     return true;
>> +}
>
>
