Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759690Ab0GQBX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 21:23:59 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46642 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759618Ab0GQBX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 21:23:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VMegZR3yXMLiVl4/t9KyZ5drl2vhieJECqbcvCUCfLUwDCdNC9ETv2Cf+mxJ5OmE61
         pLZs5FoJBfC2tCyylduzEXEBh7MSTPZDvaDPvclU5pCjgROh2bHsiZw50/RZ7QFq83Yb
         lmBuoA5tCmo1JRT0m+M2uQFSCZLQnh7SLqhE8=
MIME-Version: 1.0
In-Reply-To: <4C4099D6.6020305@wildgooses.com>
References: <4C3D94E3.9080103@wildgooses.com>
	<4C3DD5EB.9070908@tmr.com>
	<20100714.111553.104052157.davem@davemloft.net>
	<AANLkTil3MVGwJUG12dikut9X1s9Ozc_3GwMjx_gErvxI@mail.gmail.com>
	<1279299709.2156.5814.camel@tng>
	<4C4099D6.6020305@wildgooses.com>
Date: Fri, 16 Jul 2010 18:23:56 -0700
Message-ID: <AANLkTimk1TfddBqS8t1iApUNpsic7dZ0zfi9wtkjG82-@mail.gmail.com>
Subject: Re: Raise initial congestion window size / speedup slow start?
From: "H.K. Jerry Chu" <hkjerry.chu@gmail.com>
To: Ed W <lists@wildgooses.com>
Cc: Patrick McManus <mcmanus@ducksong.com>, David Miller <davem@davemloft.net>,
        davidsen@tmr.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 10:41 AM, Ed W <lists@wildgooses.com> wrote:
>
>> and while I'm asking for info, can you expand on the conclusion
>> regarding poor cache hit rates for reusing learned cwnds? (ok, I admit I
>> only read the slides.. maybe the paper has more info?)
>>
>
> My guess is that this result is specific to google and their servers?
>
> I guess we can probably stereotype the world into two pools of devices:
>
> 1) Devices in a pool of fast networking, but connected to the rest of the
> world through a relatively slow router
> 2) Devices connected via a high speed network and largely the bottleneck
> device is many hops down the line and well away from us
>
> I'm thinking here 1) client users behind broadband routers, wireless, 3G,
> dialup, etc and 2) public servers that have obviously been deliberately
> placed in locations with high levels of interconnectivity.
>
> I think history information could be more useful for clients in category 1)
> because there is a much higher probability that their most restrictive
> device is one hop away and hence affects all connections and relatively
> occasionally the bottleneck is multiple hops away.  For devices in category
> 2) it's much harder because the restriction will usually be lots of hops
> away and effectively you are trying to figure out and cache the speed of
> every ADSL router out there...  For sure you can probably figure out how to
> cluster this stuff and say that pool there is 56K dialup, that pool there is
> "broadband", that pool is cell phone, etc, but probably it's hard to do
> better than that?
>
> So my guess is this is why google have had poor results investigating cwnd
> caching?

Actually we have investigated two type of caches, a short-history limited size
internal cache that is subject to some LRU replacement policy hence
much limiting
the cache hit rate, and a long-history external cache, which provides much more
accurate cwnd history per subnet but with high complexity and
deployment headache.

Also we have set out for a much more ambitious goal, to not just speed
up our own
services, but also provide a solution that could benefit the whole web
(see http://code.google.com/speed/index.html). The latter pretty much
precludes a complex
external cache scheme mentioned above.

Jerry

>
> However, I would suggest that whilst it's of little value for the server
> side, it still remains a very interesting idea for the client side and the
> cache hit ratio would seem to be dramatically higher here?
>
>
> I haven't studied the code, but given there is a userspace ability to change
> init cwnd through the IP utility, it would seem likely that relatively
> little coding would now be required to implement some kind of limited cwnd
> caching and experiment with whether this is a valuable addition?  I would
> have thought if you are only fiddling with devices behind a broadband router
> then there is little chance of you "crashing the internet" with these kind
> of experiments?
>
> Good luck
>
> Ed W
>
