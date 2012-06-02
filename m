Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852Ab2FBXPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 19:15:20 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64913 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab2FBXPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 19:15:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120603000252.0c5008b9@pyramind.ukuu.org.uk>
References: <4FC6189B.9080909@fusionio.com> <4FC66D3D.6080509@fusionio.com>
 <1338404902.2760.451.camel@edumazet-glaptop> <1338410107.2760.544.camel@edumazet-glaptop>
 <1338456918.2760.1318.camel@edumazet-glaptop> <1338574627.2760.1545.camel@edumazet-glaptop>
 <CA+55aFzrbmGjghmR3M=fWrGUdy6BDu+SVXz6rjM4QAuUjfxk_w@mail.gmail.com>
 <1338583498.2760.1648.camel@edumazet-glaptop> <20120601215620.305155c0@pyramind.ukuu.org.uk>
 <1338584389.2760.1653.camel@edumazet-glaptop> <1338621438.2760.1679.camel@edumazet-glaptop>
 <1338623708.2760.1691.camel@edumazet-glaptop> <1338624102.2760.1693.camel@edumazet-glaptop>
 <20120602125723.5b057570@pyramind.ukuu.org.uk> <1338640231.2760.1704.camel@edumazet-glaptop>
 <CA+55aFwXrX16ufu1yf_D8rXTPXfpN1D72STuNYOMqT57je+jRA@mail.gmail.com>
 <CA+55aFysA72FVTF6k=HnqYjCTqXQO+jcMLeR6MpM=eJm-H+EBQ@mail.gmail.com>
 <20120602211917.14275f12@pyramind.ukuu.org.uk> <CA+55aFzNQe6WCHKBrs_xNY0MxzF4C9jpfLFjSh8GBFTEzGnxxg@mail.gmail.com>
 <20120603000252.0c5008b9@pyramind.ukuu.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 2 Jun 2012 16:14:57 -0700
X-Google-Sender-Auth: -TitwkD26B31yKqyJ4s6FnHI4wM
Message-ID: <CA+55aFzDE8y_K=bcN+7xtLDnF_v-xRe20S+Ws-mhs4CVyUPYOA@mail.gmail.com>
Subject: Re: [PATCH] tty: add lockdep annotations
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 2, 2012 at 4:02 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> per ldisc waitqueue is indeed independent. The rest I'll try and check
> but may be Wednesday for a serious check. You could also I guess narrow
> the check by leaving it all passing tty in to the lock function but just
> using the global lock. Might keep the noise down for the 3.6 work too.

Not really possible. The bug fundamentally comes from how the per-tty
locking locks too late - after the lookup - rather than before.

And fixing that to lock in the right place is not possible with the
"pass in the tty" model. Because we don't know what the tty will be.

                 Linus
