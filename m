Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab0LOHNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 02:13:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057Ab0LOHM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 02:12:58 -0500
MIME-Version: 1.0
In-Reply-To: <20101215055450.GC3398@amd>
References: <20101209070938.GA3949@amd> <19324.1291990997@jrobl>
 <20101213014553.GA6522@amd> <9580.1292225351@jrobl> <AANLkTimeWSEUU6EYa4yWY11OyAVQqNu5eoBZc5ddqHQL@mail.gmail.com>
 <20101215043840.GA7692@cr0.nay.redhat.com> <20101215055450.GC3398@amd>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Dec 2010 23:12:08 -0800
Message-ID: <AANLkTinZuGdZ4BMipbeLQH4e6UQ6qVNDCYeOxMpg7+og@mail.gmail.com>
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
To: Nick Piggin <npiggin@kernel.dk>
Cc: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Nick Piggin <npiggin@gmail.com>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 9:54 PM, Nick Piggin <npiggin@kernel.dk> wrote:
>
> That's what I would like to know, but I suspect that for very short
> strings we are dealing with, the custom loop will be fine for
> everybody.

Yeah, I can pretty much guarantee it for the common case of short
strings. Most path components are short enough that a "clever"
memcmp() is simply likely going to be slower than doing things
byte-per-byte.

That's especially true if we then in the future end up making it do a
long-by-long compare instead of the byte-by-byte one.

                        Linus
