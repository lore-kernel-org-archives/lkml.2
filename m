Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab0ITRIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 13:08:40 -0400
Received: from stinky.trash.net ([213.144.137.162]:49412 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab0ITRIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 13:08:39 -0400
Message-ID: <4C979515.4060908@trash.net>
Date: Mon, 20 Sep 2010 19:08:37 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Changli Gao <xiaosuo@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        akpm@linux-foundation.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] netfilter: save the hash of the tuple in the original
 direction for latter use
References: <1282344540-5306-1-git-send-email-xiaosuo@gmail.com> <4C91B6BE.8020300@trash.net> <AANLkTikZeFrS9pj6jxmOxqY6dsaAf1U+FAXe5jNwQ-nV@mail.gmail.com>
In-Reply-To: <AANLkTikZeFrS9pj6jxmOxqY6dsaAf1U+FAXe5jNwQ-nV@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.09.2010 17:04, Changli Gao wrote:
> On Thu, Sep 16, 2010 at 2:18 PM, Patrick McHardy <kaber@trash.net> wrote:
>> On 21.08.2010 00:49, Changli Gao wrote:
>>> Since we don't change the tuple in the original direction, we can save it
>>> in ct->tuplehash[IP_CT_DIR_REPLY].hnode.pprev for __nf_conntrack_confirm()
>>> use.
>>
>> I like this idea. We could actually do the same for the reply tuple
>> and invalidate the saved hash in case the reply tuple is changed
>> (nf_conntrack_alter_reply()), which only happens when NAT is used.
>>
> 
> We can't do that, as the unconfirmed ct owned maybe dropped, and
> pre-computing will wast CPU cycles in this case.

Sure we can, dropping unconfirmed conntracks is a rare exception,
not a common case. Even under DoS we usually drop *unassured*
conntracks, which have already enterered the hash. If we're unable
to do that, we won't even allocate a new conntrack.
