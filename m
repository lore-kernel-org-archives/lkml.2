Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab2EIIEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:04:11 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51547 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901Ab2EIIEF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:04:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205082158570.10766@chino.kir.corp.google.com>
References: <1336431315-29736-1-git-send-email-andi@firstfloor.org>
 <CAHGf_=p7JbWW8jgzWGHX+xwU8JWzpSMZS0kn-rmP=eg_Uqrgow@mail.gmail.com> <alpine.DEB.2.00.1205082158570.10766@chino.kir.corp.google.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 9 May 2012 04:03:43 -0400
Message-ID: <CAHGf_=pcLtNO9QyOUdiC4qOUNqEA4YQ-bvjrcDH4NzWEeffczw@mail.gmail.com>
Subject: Re: [PATCH] slab/mempolicy: always use local policy from interrupt
 context v3
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, penberg@kernel.org, cl@linux.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > +       if (!in_interrupt() || !policy || policy->flags & MPOL_F_LOCAL)
>> >                return numa_node_id();
>>
>> I think your patch is correct. but I don't like interrupt context
>> dereference current task.
>> It would be nice if we only see current->mempolicy when !in_interrupt.
>>
>> But this doesn't mean NAK anyway.
>>
>>  Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> Sigh, this was acked by Christoph and KOSAKI when the logic is reversed
> and does the exact opposite of what's intended?

Ahhh, Good catch!
