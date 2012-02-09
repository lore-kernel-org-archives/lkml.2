Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352Ab2BITPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 14:15:17 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62009 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274Ab2BITPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 14:15:15 -0500
MIME-Version: 1.0
In-Reply-To: <21276.1328813456@redhat.com>
References: <20120209154819.32070.93358.stgit@warthog.procyon.org.uk>
 <1328804920.6099.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CA+55aFxHdFa4otDWJg4f+8sKEP3MBZqKBQCnH0Q8LXYtpdt1EA@mail.gmail.com>
 <CA+55aFyw1n=Bz3vi73RD5R13HyWLaVyPZc_z5rR7nGPzvs-BOw@mail.gmail.com>
 <7095.1328809567@redhat.com> <CA+55aFw5z85wuU8xJ_YFp0QB653yAGPOqeGXhJLbdj9ogpHqOA@mail.gmail.com>
 <8689.1328810841@redhat.com> <CA+55aFwxTe6+zng6OnK_oHBxwLsX+Z7wD45d=XLTGSL+6aoh9g@mail.gmail.com>
 <21276.1328813456@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Feb 2012 11:14:55 -0800
X-Google-Sender-Auth: BLV4qN3cs_MH3FesWptuAgtXklM
Message-ID: <CA+55aFzePmV8st-PaQeO_eS05CUWQePDoQsXdd=HaiLffz+wxw@mail.gmail.com>
Subject: Re: [PATCH] Reduce the number of expensive division instructions done
 by _parse_integer()
To: David Howells <dhowells@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, adobriyan@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, what was the load that you noticed this on?

Because quite frankly, I think we only support bases 8/10/16 in the
kernel, and if you really have some case where this all is expensive,
it might be better to simply have three different functions for the
three bases. That would turn the multiplies into constants too, and
also simplify the character tests.

That said, I can't really see how this could ever be all that hot a
function. Did you ever see it in a profile, or was this all just from
looking at the code?

                         Linus
