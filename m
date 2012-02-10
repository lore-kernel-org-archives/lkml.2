Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347Ab2BJNuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:50:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53772 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937Ab2BJNuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:50:03 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzePmV8st-PaQeO_eS05CUWQePDoQsXdd=HaiLffz+wxw@mail.gmail.com>
References: <20120209154819.32070.93358.stgit@warthog.procyon.org.uk>
	<1328804920.6099.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CA+55aFxHdFa4otDWJg4f+8sKEP3MBZqKBQCnH0Q8LXYtpdt1EA@mail.gmail.com>
	<CA+55aFyw1n=Bz3vi73RD5R13HyWLaVyPZc_z5rR7nGPzvs-BOw@mail.gmail.com>
	<7095.1328809567@redhat.com>
	<CA+55aFw5z85wuU8xJ_YFp0QB653yAGPOqeGXhJLbdj9ogpHqOA@mail.gmail.com>
	<8689.1328810841@redhat.com>
	<CA+55aFwxTe6+zng6OnK_oHBxwLsX+Z7wD45d=XLTGSL+6aoh9g@mail.gmail.com>
	<21276.1328813456@redhat.com>
	<CA+55aFzePmV8st-PaQeO_eS05CUWQePDoQsXdd=HaiLffz+wxw@mail.gmail.com>
Date: Fri, 10 Feb 2012 15:50:02 +0200
Message-ID: <CACVxJT9Z5On2hzZ68qVuj1XM79UzM_ECN81e34p0Y0+V9CLU_w@mail.gmail.com>
Subject: Re: [PATCH] Reduce the number of expensive division instructions done
 by _parse_integer()
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 9, 2012 at 10:14 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

Ugh, I'm late to the party.

> Because quite frankly, I think we only support bases 8/10/16 in the
> kernel, and if you really have some case where this all is expensive,
> it might be better to simply have three different functions for the
> three bases. That would turn the multiplies into constants too, and
> also simplify the character tests.

base 2 is used to sort of autolimit input to 0/1 characters.

> That said, I can't really see how this could ever be all that hot a
> function. Did you ever see it in a profile, or was this all just from
> looking at the code?

That's why there was no such check from the beginning -- not
performance critical.
We could maintain small table from which digit overflow can happen,
but since this is already committed...

There is CONFIG_TEST_KSTRTOX, does it still passes?
