Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab0IPWIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:08:25 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63779 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab0IPWIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:08:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=SllF/VgaC4/wewjCmKTjZnozqwcHLA8x1FNyHFFP5uVXw+OwSDzj/73AjvZ/Iz5gfM
         ELiyugShqXdtepesSsp3IJ9xcG0T8L4vAzV+20mkPWJoIiCGmwlu1ysZzcmyTTHV95Og
         pbQ5wN4QJlxqgJQCjCj0iiq84Wcot/u0t6S/o=
MIME-Version: 1.0
In-Reply-To: <AANLkTinPEWHmPsjyfJ-nez9yCdHKgCU3oVhNo0gdMpj6@mail.gmail.com>
References: <1284490101-2362-1-git-send-email-penberg@kernel.org>
	<1284490101-2362-2-git-send-email-penberg@kernel.org>
	<alpine.DEB.2.00.1009141243290.1470@chino.kir.corp.google.com>
	<AANLkTinj2P_QbdgdLS3BweSMDzhQH5g4p2B3SqS=CNYc@mail.gmail.com>
	<alpine.DEB.2.00.1009141320090.7123@chino.kir.corp.google.com>
	<4C8FE263.5070101@kernel.org>
	<alpine.DEB.2.00.1009141646350.26982@chino.kir.corp.google.com>
	<1097CAA8-8234-4FE2-BAA1-9C7D9FA01CEC@mit.edu>
	<alpine.DEB.2.00.1009151322370.29425@chino.kir.corp.google.com>
	<20100915222509.GE3730@thunk.org>
	<alpine.DEB.2.00.1009151537080.15256@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1009161209240.22849@router.home>
	<AANLkTinPEWHmPsjyfJ-nez9yCdHKgCU3oVhNo0gdMpj6@mail.gmail.com>
Date: Thu, 16 Sep 2010 15:08:23 -0700
X-Google-Sender-Auth: K_3LhDeq8X9EhdzCKKXDBkj8keg
Message-ID: <AANLkTi=qnYwpb3fMyVy2iDzt3Uv1ub3Se+f0NJGAa-Ga@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
From: Tony Luck <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        "Ted Ts'o" <tytso@mit.edu>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 10:49 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> That would allow slabtop etc to show the number of actual allocations
> at the granularity that we want (ie you'd see who is the real user),
> but still then use the same slab pages and avoid the slab
> fragmentation.

It might be hard to interpret the data. Suppose "foo" and "bar"
are slab caches that have separate accounting, but a merged
allocator. Now we do 20 allocations from foo, and free 19 of them.
Then we do 19 allocations from bar.  The accounts would show
that foo has 1 object in use and 19 free. While bar would show
19 objects in use.

But the 19 "free" foo objects aren't free at all, they've been
handed out to bar.

-Tony
