Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab0KOKcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 05:32:12 -0500
Received: from stinky.trash.net ([213.144.137.162]:61776 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab0KOKcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:32:10 -0500
Message-ID: <4CE10C2A.1050801@trash.net>
Date: Mon, 15 Nov 2010 11:32:10 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Hua Zhong <hzhong@gmail.com>
CC: "'Eric Paris'" <eparis@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org
Subject: Re: [RFC PATCH] network: return errors if we know tcp_connect failed
References: <20101111210341.31350.86916.stgit@paris.rdu.redhat.com> <00c201cb81eb$84e18160$8ea48420$@com> <4CDCEE65.3060105@trash.net> <017301cb82bf$54540cf0$fcfc26d0$@com>
In-Reply-To: <017301cb82bf$54540cf0$fcfc26d0$@com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.11.2010 00:14, Hua Zhong wrote:
>> On 11.11.2010 22:58, Hua Zhong wrote:
>>>> Yes, I realize this is little different than if the
>>>> SYN was dropped in the first network device, but it is different
>>>> because we know what happened!  We know that connect() call failed
>>>> and that there isn't anything coming back.
>>>
>>> I would argue that -j DROP should behave exactly as the packet is
>> dropped in the network, while -j REJECT should signal the failure to
>> the application as soon as possible (which it doesn't seem to do).
>>
>> It sends an ICMP error or TCP reset. Interpretation is up to TCP.
> 
> Huh? It's the OUTPUT chain we are talking about. There is no ICMP error or
> TCP reset.

Of course there is.

ICMP (default):

iptables -A OUTPUT -p tcp -j REJECT

TCP reset:

iptables -A OUTPUT -p tcp -j REJECT --reject-with tcp-reset

The second one will cause a hard error for the connection.
