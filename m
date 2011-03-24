Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084Ab1CXT3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:29:11 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43675 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933988Ab1CXT3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:29:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Vr0/V2fLZwLt5YhgaA3pr2GUD8/bECjF9o9iwVNZ8ueI1q+Z8LbnUwkDHIaxAP1+lY
         ewYoQ5jdTSd3Iu4Jki4iglSaWKC7JRLhXhsbKzp8FLQ7jy6H76Z22C4lqS/MMz/o8ebq
         p7bHEdYKeO1e1Hrco9vqOAdQ3GzO9++PxEQVY=
MIME-Version: 1.0
In-Reply-To: <20110324192712.GA7156@elte.hu>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>
	<20110324142146.GA11682@elte.hu>
	<alpine.DEB.2.00.1103240940570.32226@router.home>
	<AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>
	<20110324172653.GA28507@elte.hu>
	<alpine.DEB.2.00.1103242011540.4990@tiger>
	<20110324192712.GA7156@elte.hu>
Date: Thu, 24 Mar 2011 21:29:06 +0200
X-Google-Sender-Auth: RRq8hmNhUT6HLjmG7ls37AsknvU
Message-ID: <AANLkTi=YRYpBmni4CBmiOXML=w4CVH+AveAwLu=tt_rB@mail.gmail.com>
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <cl@linux.com>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 9:27 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Pekka Enberg <penberg@kernel.org> wrote:
>
>> >From dd1534455196d2a8f6c9c912db614e59986c9f0e Mon Sep 17 00:00:00 2001
>> From: Pekka Enberg <penberg@kernel.org>
>> Date: Thu, 24 Mar 2011 19:59:35 +0200
>> Subject: [PATCH] x86: Early boot alternative instructions
>
> hm, patch is whitespace damaged.
>
> Also, the fix looks rather intrusive.
>
> Could we please disable the lockless slub code first and then do everything
> with proper testing and re-enable the lockless code *after* we know that the
> alternatives fixup change is robust, etc? That way there's no rush needed.
>
> There's a lot of code that could break from tweaking the alternatives code.

Just ignore this patch. As explained by Christoph, if alternative_io()
was the issue, we'd see the crash in kmem_cache_alloc().
