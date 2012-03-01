Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965479Ab2CARFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:05:24 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:53634 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758739Ab2CARFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:05:21 -0500
Message-ID: <4F4FAC7E.2090604@collabora.co.uk>
Date: Thu, 01 Mar 2012 18:06:06 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Rodrigo Moya <rodrigo.moya@collabora.co.uk>,
        David Laight <David.Laight@aculab.com>,
        David Miller <davem@davemloft.net>, javier@collabora.co.uk,
        lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6E86@saturn3.aculab.com> <1330606237.27405.5.camel@megeve> <1330606775.2465.56.camel@edumazet-laptop> <4F4F7FFB.6010608@collabora.co.uk> <CABBYNZKN+7z4Sr9DBniokez6Jru02LxPgWdGNcVeYECse+AzEQ@mail.gmail.com>
In-Reply-To: <CABBYNZKN+7z4Sr9DBniokez6Jru02LxPgWdGNcVeYECse+AzEQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2012 05:02 PM, Luiz Augusto von Dentz wrote:
> Hi Javier,
> 
> On Thu, Mar 1, 2012 at 3:56 PM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
>>>
>>> Anyway, if you think multicast sockets is the way to go, then you could
>>> setup a virtual network just to be able to use AF_INET multicast.
>>>
>>> Thats probably doable without kernel patching.
>>>
>>
>> We could use AF_INET multicast on a local machine but we need some
>> ordering and control flow requirements that are not guaranteed on UDP
>> multicast over IP. That's why we thought to add a new address family
>> AF_MCAST.
> 
> I don't want to sound like a broken record, but Im afraid I have to,
> what about Ancillary Messages, how you are going to support passing
> fd? Actually the whole virtual network sounds like a bad idea, are we
> going to give ips to each and every application connected to the bus,
> actually it is necessary to have one virtual network for each bus.
> 
> Contrary to someones believes I don't think AF_INET is that fast (e.g.
> http://scottmoonen.com/2008/04/05/a-performance-comparison-of-af_unix-with-loopback-on-linux/)
> 
> 

You are right. Ancillary messages are PF_UNIX specific and also some
D-bus applications use fd passing for out-of-band communication. So,
using multicast on AF_INET will break these applications.

Regards,
Javier
