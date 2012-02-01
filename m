Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab2BATJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:09:29 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59862 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab2BATJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:09:27 -0500
MIME-Version: 1.0
In-Reply-To: <4F298865.5000409@redhat.com>
References: <CA+55aFxmdskUXX1iBaPx7rUGD95UqNJxhe1BLeVtZjqHjBpsPA@mail.gmail.com>
 <alpine.LRH.2.00.1202011808240.22725@twin.jikos.cz> <Pine.LNX.4.64.1202011818570.25409@wotan.suse.de>
 <20120201.130905.1131458895704793597.davem@davemloft.net> <4F298865.5000409@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Feb 2012 11:09:06 -0800
X-Google-Sender-Auth: 9r6rmjIuZxFtYBUkJvDdgmd0d1Y
Message-ID: <CA+55aFzzaWM=EWsK1hRho27b5ePEYNkzEnqce-DmCQ3kL1w9ZA@mail.gmail.com>
Subject: Re: Memory corruption due to word sharing
To: Jeff Law <law@redhat.com>
Cc: David Miller <davem@davemloft.net>, matz@suse.de, jkosina@suse.cz,
        walters@verbum.org, jack@suse.cz, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, dsterba@suse.cz, ptesarik@suse.cz,
        rguenther@suse.de, gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 10:45 AM, Jeff Law <law@redhat.com> wrote:
>
> Torvald Riegel & I were told that was kernel policy when we brought up the
> upcoming bitfield semantic changes with some of the linux kernel folks last
> year.

Btw, one reason this is true is that the bitfield ordering/packing is
so unspecified that using bitfields sometimes is just way more pain
than you get. Some people have tried to use bitfields for various IO
data structures (think laying out bits in memory to match some
particular layout of some disk controller result structure). It's
always a total disaster, because you have another whole level of
architecture-specific bit ordering (in *addition* to all the normal
byte order issues).

That's not a compiler issue, that's just the nature of the beast.
It's just another reason why the kernel often ends up then doing bit
masking by hand.

But *all* that said, we do have a metric buttload of bitfields in the
kernel. It's not some really unusual feature. It does get used a lot,
despite all the reasons why some particular code might not use
bitfields.

We have a lot of code, there's still a lot of situations left where
bitfields are just really convenient.

                    Linus
