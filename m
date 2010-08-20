Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab0HTPhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 11:37:11 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51309 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab0HTPhI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 11:37:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vGhtAXrVxP2yJLkXdyfJe2UTdJ2mpepcjAcVuTpTy7D2exGNdSVgvwwdzbmbsJSO+t
         N5FfjVRGuB7krL3JHm2arD05359vF0mfZXPg2PiYqeVtwYGViUeCdTqVvjQMLCNkzR5h
         xl4THPRFNlgO5KVvSQgr23FW1a/oXI8Z8XiwE=
MIME-Version: 1.0
In-Reply-To: <1282318163.2484.212.camel@edumazet-laptop>
References: <1282316003-2966-1-git-send-email-xiaosuo@gmail.com>
 <1282317016.2484.173.camel@edumazet-laptop> <AANLkTimj=6HBdZK0WiPBxhm9YPG_8zRXEZyP--E7Shj8@mail.gmail.com>
 <1282318163.2484.212.camel@edumazet-laptop>
From: Changli Gao <xiaosuo@gmail.com>
Date: Fri, 20 Aug 2010 23:36:44 +0800
Message-ID: <AANLkTinic7H0r7kAgsBiRAbn7MCeqxA0Gme7oOkmPUdJ@mail.gmail.com>
Subject: Re: [PATCH v3] netfilter: save the hash of the tuple in the original
 direction for latter use
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        akpm@linux-foundation.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 11:29 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le vendredi 20 août 2010 à 23:22 +0800, Changli Gao a écrit :
>
>> I should keep the old way, but fix a race.
>>
>>         if (unlikely(!nf_conntrack_hash_rnd_initted)) {
>>                 get_random_bytes(&nf_conntrack_hash_rnd,
>>                                 sizeof(nf_conntrack_hash_rnd));
>>                 nf_conntrack_hash_rnd_initted = 1;
>>         }
>>
>> nf_conntrack_alloc() isn't called with in the nf_conntrack_lock. So
>> the above code maybe executed more than once on different CPUs. It is
>> easy to fix with the cmpxchg() trick.
>
> Sure, please fix the race first.
>
> But as I said, its not critical, if one or two conntracks are hashed on
> wrong basis. They will eventually disappear after timeout.
>

Yes, and it isn't critical. I think this fix should be in a separate patch.


-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
