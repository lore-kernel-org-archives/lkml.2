Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab0IUPcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 11:32:24 -0400
Received: from stinky.trash.net ([213.144.137.162]:39322 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab0IUPcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 11:32:23 -0400
Message-ID: <4C98D002.3000309@trash.net>
Date: Tue, 21 Sep 2010 17:32:18 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Changli Gao <xiaosuo@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        akpm@linux-foundation.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] netfilter: save the hash of the tuple in the original
 direction for latter use
References: <1282344540-5306-1-git-send-email-xiaosuo@gmail.com> <4C91B6BE.8020300@trash.net> <AANLkTikZeFrS9pj6jxmOxqY6dsaAf1U+FAXe5jNwQ-nV@mail.gmail.com> <4C979515.4060908@trash.net> <AANLkTi=NXj9PjYA06+UFYms8q5K3Z4DsPMcpVHpj7Gmq@mail.gmail.com>
In-Reply-To: <AANLkTi=NXj9PjYA06+UFYms8q5K3Z4DsPMcpVHpj7Gmq@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.09.2010 02:02, schrieb Changli Gao:
> On Tue, Sep 21, 2010 at 1:08 AM, Patrick McHardy <kaber@trash.net> wrote:
>>
>> Sure we can, dropping unconfirmed conntracks is a rare exception,
>> not a common case. Even under DoS we usually drop *unassured*
>> conntracks, which have already enterered the hash. If we're unable
>> to do that, we won't even allocate a new conntrack.
>>
> 
> Even so, saving the hash of the reply tuple isn't a good idea.
> 
> If NAT is turned on, the current code is:
> 
> mangle the reply tuple -> compute the hash of the reply tuple ->
> insert into the conntrack hash table.
> 
> the new code is
> 
> compute the hash of the reply tuple -> mangle the reply tuple ->
> recompute the hash of the reply tuple -> insert into the conntrack
> hash table.
> 
> As you see, the hash computing is done twice, and we use more CPU
> cycles than before.

You're right of course, we actually don't compute the reply hash
before inserting the conntrack into the hash table (except in a
few NAT cases, but we can look at those later).
