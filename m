Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756Ab1JDUut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:50:49 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54174 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933671Ab1JDUus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:50:48 -0400
MIME-Version: 1.0
In-Reply-To: <20111004174548.GA16209@elliptictech.com>
References: <20110929105940.10660.76130.stgit@e102109-lin.cambridge.arm.com>
 <20110929110239.10660.95998.stgit@e102109-lin.cambridge.arm.com> <20111004174548.GA16209@elliptictech.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 4 Oct 2011 21:50:26 +0100
X-Google-Sender-Auth: wvmIB7iHPAaPaAOHjaLE8cwTayc
Message-ID: <CAHkRjk58zQF4ZxvH4Ex-sUpe9Wmhvt0xo5Juffq=DrpySE556Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] kmemleak: Report previously found leaks even after an error
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 October 2011 18:45, Nick Bowler <nbowler@elliptictech.com> wrote:
> On 2011-09-29 12:02 +0100, Catalin Marinas wrote:
>> If an error fatal to kmemleak (like memory allocation failure) happens,
>> kmemleak disables itself but it also removes the access to any
>> previously found memory leaks. This patch allows read-only access to the
>> kmemleak debugfs interface but disables any other action.
>>
>> Repored-by: Nick Bowler <nbowler@elliptictech.com>
>
> Reported-by: ...

I was wondering why you were not automatically cc'ed.

>> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>
> Cool, I'll try this out.  Kmemleak rarely stays alive for more than a
> few days on my desktop before shutting itself down due to an allocation
> failure, so this should be really handy.

You can have a look at /proc/slabinfo and meminfo and see if there are
any really big leaks. In general the kmemleak objects number is higher
than the sum of all the other slab objects (but I haven't done any
statistics). Hopefully kmemleak doesn't leak memory :) (I should add
some simple checks though).

-- 
Catalin
