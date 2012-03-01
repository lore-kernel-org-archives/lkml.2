Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab2CAL4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 06:56:34 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:53242 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2CAL4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 06:56:32 -0500
Message-ID: <4F4F641E.7000501@collabora.co.uk>
Date: Thu, 01 Mar 2012 12:57:18 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: rodrigo.moya@collabora.co.uk, javier@collabora.co.uk,
        eric.dumazet@gmail.com, lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
References: <4F4B8C66.5060206@collabora.co.uk> <20120227.140535.1623396420455657443.davem@davemloft.net> <1330426059.2139.21.camel@megeve> <20120228.140558.1132853996225815681.davem@davemloft.net>
In-Reply-To: <20120228.140558.1132853996225815681.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2012 08:05 PM, David Miller wrote:
> From: Rodrigo Moya <rodrigo.moya@collabora.co.uk>
> Date: Tue, 28 Feb 2012 11:47:39 +0100
> 
>> Because of all of this, UDP/IP multicast wasn't even considered as an
>> option. We might be wrong in some/all of those, so could you please
>> comment on them to check if that's so?
> 
> You guys seem to want something that isn't AF_UNIX, ordering guarentees
> and whatnot, it really has no place in these protocols.
> 
> You've designed a userlevel subsystem with requirements that no existing
> socket layer can give, and you just figured you'd work that out later.
> 
> I think you rather should have reconsidered these premises and designed
> something that could handle reality which is AF_UNIX can't do multicast
> and nobody guarentees those strange ordering requirements you seem to
> have.

Yes, you are right it doesn't follow AF_UNIX semantics so Unix sockets
is not the best place to add our multicast implementation.

So, now we are trying a different approach. To create a new address
family AF_MCAST. That way we can have more control over the semantics of
the socket interface for that family.

We expect to have some patches in a few days and we will resend.

Does this makes more sense to you?

Best regards,
Javier
