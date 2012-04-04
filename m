Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab2DDR0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 13:26:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36878 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932278Ab2DDR0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 13:26:06 -0400
X-Sasl-enc: 9aNVlkiTgxs7CRJDcOO9u4EOsGnfl97DfwgFD/jMy9hf 1333560365
Message-ID: <1333560335.10230.73.camel@lenny>
Subject: Re: [PATCH] nextfd(2)
From: Colin Walters <walters@verbum.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Wed, 04 Apr 2012 13:25:35 -0400
In-Reply-To: <1333559412.10230.67.camel@lenny>
References: <20120401125741.GA7484@p183.telecom.by>
	 <CAHGf_=pgpRrQA3-YVtS=h-Bjq2LyTFmYtKGxxWgwP0XWexnh2g@mail.gmail.com>
	 <4F7A3CC2.1040200@zytor.com> <4F7C777E.10608@gmail.com>
	 <1333559412.10230.67.camel@lenny>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-04 at 13:10 -0400, Colin Walters wrote:

> The thing is, even if it were added today, since we need to run on old
> kernels, we'd have to carry the code to use the /proc trick
> approximately forever.  And in the end all nextfd() would accomplish
> would be a *third* case in the already messy ifdefs/fallbacks
> in the various implementations of process spawning.

The only really counterargument I see to this is if nextfd() were
*significantly* more efficient.  I happily switched to using eventfd()
instead of pipe(), while still carrying the burden of fallback code,
because dropping from two open descriptors to one solved actual
problems with maxing out 1024 fds.

As far as efficiency goes, I could imagine that as Linus said, what
you really want is nextfd(O_NOT_CLOEXEC), because in a well-behaved
program that marks its internal descriptors as O_CLOEXEC, the effort the
forked process spends closing them is just wasted over having it
all happen more efficiently in the kernel as part of the exec().

But if claiming efficiency, one needs to post benchmarks...





