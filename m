Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967432Ab2EPLGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:06:22 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52502 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966952Ab2EPLGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:06:19 -0400
MIME-Version: 1.0
Reply-To: konrad@darnok.org
In-Reply-To: <4FB3048C.20008@kernel.org>
References: <4FAB21E7.7020703@kernel.org>
	<20120510140215.GC26152@phenom.dumpdata.com>
	<4FABD503.4030808@vflare.org>
	<4FABDA9F.1000105@linux.vnet.ibm.com>
	<20120510151941.GA18302@kroah.com>
	<4FABECF5.8040602@vflare.org>
	<20120510164418.GC13964@kroah.com>
	<4FABF9D4.8080303@vflare.org>
	<20120510173322.GA30481@phenom.dumpdata.com>
	<4FAC4E3B.3030909@kernel.org>
	<20120511192831.GC3785@phenom.dumpdata.com>
	<4FB06B91.1080008@kernel.org>
	<CAPbh3ruv9xCV_XpR4ZsZpSGQ8=mibg=a39zvADYETb-tg0kBsA@mail.gmail.com>
	<4FB3048C.20008@kernel.org>
Date: Wed, 16 May 2012 07:06:18 -0400
X-Google-Sender-Auth: nnsBm4F9mX8OeP0-9j_tTwy3Fr0
Message-ID: <CAPbh3ruFRLzGn88G1=BajKS1VAw7hQDPNMH9yUO5JB0UDVF5Mg@mail.gmail.com>
Subject: Re: [PATCH 3/4] zsmalloc use zs_handle instead of void *
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> It's not good abstraction.
>>
>> If we want good abstraction, then I don't think 'unsigned long' is
>> either? I mean it will do for the conversion from 'void *'. Perhaps I
>> am being a bit optimistic here - and I am trying to jam in this
>> 'struct zs_handle' in all cases but in reality it needs a more
>> iterative process. So first do 'void *' -> 'unsigned long', and then
>> later on if we can come up with something more nicely that abstracts
>> - then use that?

..snip..
>>> No. What I want is to remove coupling zsallocator's handle with zram/zcache.
>>> They shouldn't know internal of handle and assume it's a pointer.
>>
>> I concur. And hence I was thinking that the 'struct zs_handle *'
>> pointer would work.
>
>
> Do you really hate "unsigned long" as handle?
..snip,,
>> Well, everything changes over time  so putting a stick in the ground
>> and saying 'this must
>> be this way' is not really the best way.
>
>
> Hmm, agree on your above statement but I can't imagine better idea.
>

OK. Lets go with unsigned long. I can prep a patch next week when I am
back from vacation unless somebody beats me to it.
