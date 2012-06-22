Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761112Ab2FVDeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 23:34:03 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:33756 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761125Ab2FVDeB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 23:34:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120621184536.6dd97746.akpm@linux-foundation.org>
References: <alpine.DEB.2.00.1206201758500.3068@chino.kir.corp.google.com>
 <20120621164606.4ae1a71d.akpm@linux-foundation.org> <CA+55aFzPXMD3N3Oy-om6utDCQYmrBDnDgdqpVC5cgKe-v6uZ3w@mail.gmail.com>
 <20120621184536.6dd97746.akpm@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Jun 2012 20:33:38 -0700
X-Google-Sender-Auth: 28fTovb06lPiJQK5_GGJVmq5oYY
Message-ID: <CA+55aFwBc=OxwU=qNYQs0rg4dPGBQObqg-EGnDDS-TWWpy0G2A@mail.gmail.com>
Subject: Re: [patch 3.5-rc3] mm, mempolicy: fix mbind() to do synchronous migration
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 6:45 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>> I wonder if I should make sparse warn about any casts to/from enums.
>> They tend to always be wrong.
>
> I think it would be worth trying, see how much fallout there is.  Also
> casts from "enum a" to "enum b".  We've had a few of those,
> unintentionally.

Ugh. We have this all over. Well, at least in multiple places.

Like <linux/personality.h>, which does things like

        PER_LINUX_32BIT =       0x0000 | ADDR_LIMIT_32BIT,

where PER_LINUX_32BIT is one enum, and ADDR_LIMIT_32BIT is a different one.

And things like

        WORK_STRUCT_PENDING     = 1 << WORK_STRUCT_PENDING_BIT,

in <linux/workqueue.h> is similar.

Sure, my quick warning generator gives lots of extraneous warnings,
and it complains about the above kind of "mixing enum with int"
behavior, but the above is a very real example of casting an enum to
an integer. And we *want* it to happen in the above cases.

I'll see what it looks like if I only warn about casting *to* an enum.

             Linus
