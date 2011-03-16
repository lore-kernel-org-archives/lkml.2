Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab1CPGX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 02:23:57 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58532 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1CPGXv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 02:23:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BaQt1Szp+ZmQE8/jrgEVr+4UEEChxngKOoWA9n+sfq6c2pDrMORD3r+b2N9Xi4ErZk
         m+OYTK4PJObvqgYKoDNx4VV7r+NTb/p77ocbtgCSUA6vcWEVkzsval9ENjnHvic1priX
         4Nu7X4t+NbaaLmUT6r1ZT3G9i6YKgY7kfahbA=
MIME-Version: 1.0
In-Reply-To: <1300244238.3128.420.camel@calx>
References: <20110316022804.27676.qmail@science.horizon.com>
	<1300244238.3128.420.camel@calx>
Date: Wed, 16 Mar 2011 08:23:50 +0200
X-Google-Sender-Auth: zd-5ak3CeT60bhKudYZWvvV26pw
Message-ID: <AANLkTimZRnaf6C-vOkkM-uhVVzn8NO8_V9Xb16rN7BKK@mail.gmail.com>
Subject: Re: [PATCH 0/8] mm/slub: Add SLUB_RANDOMIZE support
From: Pekka Enberg <penberg@kernel.org>
To: Matt Mackall <mpm@selenic.com>
Cc: George Spelvin <linux@horizon.com>, penberg@cs.helsinki.fi,
        herbert@gondor.hengli.com.au, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Sun, 2011-03-13 at 20:20 -0400, George Spelvin wrote:
>> As a followup to the "[PATCH] Make /proc/slabinfo 0400" thread, this
>> is a patch series to randomize the order of object allocations within
>> a page.  It can be extended to SLAB and SLOB if desired.  Mostly it's
>> for benchmarking and discussion.

On Wed, Mar 16, 2011 at 4:57 AM, Matt Mackall <mpm@selenic.com> wrote:
> I've spent a while thinking about this over the past few weeks, and I
> really don't think it's productive to try to randomize the allocators.
> It provides negligible defense and just makes life harder for kernel
> hackers.

If it's an optional feature and the impact on the code is low (as it
seems to be), what's the downside? Combined with disabling SLUB's slab
merging, randomization should definitely make it more difficult to
have full control over a full slab. I don't know how much defense it
will provide but I think randomization is definitely an option worth
exploring.

> (And you definitely can't randomize SLOB like this.)

No, you can't but heap exploits like the one we discuss are slightly
harder with SLOB anyway, no?

                        Pekka
