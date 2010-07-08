Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab0GHBdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 21:33:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45144 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698Ab0GHBdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 21:33:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dQzJTwQ8qTE8EMPe89Yf+8URCOXrPi32qHW/34NU27LmpBlqV7B2wej/HSfrt3Yeob
         eoYnq/KP5vr3YN2z+KjS/1+e0RzCLe9MRVODYJcFEN5M+5272qK5R14IBrga22OobpHl
         iOacd1t0TPBGYrx5t07IlLd3VlF1fkY6Y0w3k=
MIME-Version: 1.0
In-Reply-To: <20100707122110.GF17967@verge.net.au>
References: <AANLkTinEKn_UBpjf3k2DZn1euMM6z2UM_yeDPvdEQkav@mail.gmail.com>
	<20100707122110.GF17967@verge.net.au>
Date: Thu, 8 Jul 2010 09:33:13 +0800
Message-ID: <AANLkTimBVoEYPt8uyATIw_TX290_xJqHKZQU1uWgWvNu@mail.gmail.com>
Subject: Re: IPVS: Incorrect helper use for SCTP [was: wensong@linux-vs.org, 
	horms@verge.net.au]
From: xiaoyu Du <tingsrain@gmail.com>
To: Simon Horman <horms@verge.net.au>
Cc: lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is used  for sctp app heplers.
since  there's no sctp helpers yet at present, it does nothing.
If I make sure this is a bug. I will resend the pathch.


2010/7/7 Simon Horman <horms@verge.net.au>:
> [CCed netdev]
>
> Thanks,
>
> that looks correct to me. Have you tested this change?
> If so could you provided a Signed-off-by line
> as per section 12 of Documentation/SubmittingPatches?
>
> On Wed, Jul 07, 2010 at 05:19:06PM +0800, xiaoyu Du wrote:
>> Hi，all
>>
>> After I compared the sctp with tcp and udp, I thinkt his a bug that
>> sctp_dnat_handler Incorrectly invoked ip_vs_app_pkt_out.
>> below is the patch.
>>
>> ---
>>  net/netfilter/ipvs/ip_vs_proto_sctp.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c
>> b/net/netfilter/ipvs/ip_vs_proto_sctp.c
>> index c9a3f7a..db55759 100644
>> --- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
>> +++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
>> @@ -173,7 +173,7 @@ sctp_dnat_handler(struct sk_buff *skb,
>>                        return 0;
>>
>>                /* Call application helper if needed */
>> -               if (!ip_vs_app_pkt_out(cp, skb))
>> +               if (!ip_vs_app_pkt_in(cp, skb))
>>                        return 0;
>>        }
>>
>> --
>> --
>> To unsubscribe from this list: send the line "unsubscribe lvs-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
