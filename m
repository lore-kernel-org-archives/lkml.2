Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab0E1H2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:28:36 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:54039 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab0E1H2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:28:33 -0400
Message-ID: <4BFF709D.5040005@bfs.de>
Date: Fri, 28 May 2010 09:28:29 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Richard Hartmann <richih.mailinglist@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-ppp@vger.kernel.org, erik_list@caneris.com
Subject: Re: [Patch] fix packet loss and massive ping spikes with PPP 	multi-link
References: <2d460de71003260850x7f90d04cy79ac853464108182@mail.gmail.com>	<AANLkTik_QdZN_nFoOVD3-1JTGN5oxRySCdV5_eDqvQve@mail.gmail.com>	<4BFBA3F2.2000301@bfs.de>	<AANLkTilnueP5HIfX03soMCYE93jubL000rpiOCN1xB2-@mail.gmail.com>	<4BFC0942.2030103@bfs.de> <AANLkTikeld4fbr9r1Sq0jhfkWxf0ZlwOsufUIRvb1rFH@mail.gmail.com>
In-Reply-To: <AANLkTikeld4fbr9r1Sq0jhfkWxf0ZlwOsufUIRvb1rFH@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Richard Hartmann schrieb:
> ==It seems LKML & netdev were dropped from the To list, re-adding==
> 
> Hi Walter,
> 
> 
>>  if (ppp->rrsched % ppp->n_channels == i)
>>
>> since both do not change in that while() loop you can calculate in advance
>> perhaps ppp->rrsched %= ppp->n_channels before the while ?
>> (that would reduce my bad feels about variables that only increments also :)
> 
> rrsched and i do change when appropriate. As they are used as a cheap
> way to get round robin, rrsched is not even initialized. One can argue
> that this should be done, but as it literally does not matter where the
> value starts counting....
> 

yep,
the problem is that you will trigger a warning "variable uninitialised".
And as programmer you are trained to spot such kind of code.
in short you violated "the rule of least surprise", simply set it to 99
and add a comment that the value does not matter because it is actualy a
random seed.
Basicly the same reason for the ppp->rrsched %= ppp->n_channels outside
the loop. 1. people/compiler are happy because they see the variable
is used. 2. no need to recalculate the if in a loop (never trust optimisers).

/*
perhaps rr_chanel is a better name ? round robin channel
that would requiere the changes but explain what it actualy is
*/



> 
>> btw: you are doing  after loop() if(pch->chan == NULL) continue;
>> that means the else in the if below  if (pch->chan) should never be reached.
>> Or is it likely that some channel will be dropped (?) ?
> 
> Channels could be dropped and we need to guard against that.
> 

please add a comment about that. i can garantee you someone will spot it
and remove either the pch->chan == NULL or the else.



just my 2 cents,
wh


> 
>> btw: this is intentional ? looks strange
>>
>>        if(ppp_ml_noexplode) {
>> +       }
>> +       else {
> 
> Leftover from various printks for debugging reasons.
> 
> 
> Thanks for your feedback,
> Richard
> 
