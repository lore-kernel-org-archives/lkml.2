Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935466Ab0HFIGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 04:06:53 -0400
Received: from dspnet.fr ([188.165.44.67]:28741 "EHLO dspnet.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933696Ab0HFIGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 04:06:47 -0400
Date: Fri, 6 Aug 2010 10:06:42 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Howells <dhowells@redhat.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: Initcall ordering problem (TTY vs modprobe vs MD5) and
 cryptomgr problem
Message-ID: <20100806080642.GA4642@dspnet.fr>
References: <23662.1281056463@redhat.com>
 <20100806011706.GA21657@gondor.apana.org.au>
 <20100806014057.GA22395@gondor.apana.org.au>
 <AANLkTi=+-Y2GOZYAZHeaX+op3XB9AY5S85rfJD3jSDvz@mail.gmail.com>
 <20100806023539.GA22774@gondor.apana.org.au>
 <AANLkTimVOkAi1_G9B290fHRR3PbV4H9003VarAv_zbGn@mail.gmail.com>
 <AANLkTinVO0prEfkuOUFWA12q8HwrXS6do_hjw1EqygZu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinVO0prEfkuOUFWA12q8HwrXS6do_hjw1EqygZu@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 12:50:04AM -0400, Kyle Moffett wrote:
> You should also realize that crypto drivers are very much *NOT* in the
> same situation as most other drivers.  Without this test, adding a new
> crypto hardware driver to the kernel is a completely unsafe operation,
> because it could completely break users setups.  You have previously
> said you're fine accepting new drivers even after the initial merge
> window because they can't break anything, but in crypto that's not
> true.

Maybe Linus would be happier if the self-tests were limited (by
default) to the hardware accelerators?  Having a software backup and
the risk of data loss indeed makes things different.

Of course in practice without the tests your boot would probably just
have failed.  Badly-decrypted root partitions tend to be noticed as
such long before trying to write to them.  Then you would have bitched
on the list and the driver would have been fixed or removed faster
than having to wait for you (or other people with the hardware issue)
to notice the spew in dmesg.

  OG.

