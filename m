Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab2IRUs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:48:26 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29955 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab2IRUsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:48:25 -0400
Date: Tue, 18 Sep 2012 16:37:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: 3.6rc6 slab corruption.
Message-ID: <20120918203713.GB19300@phenom.dumpdata.com>
References: <20120918143504.GA30585@redhat.com>
 <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com>
 <20120918192338.GA25845@phenom.dumpdata.com>
 <CA+55aFy6=1vW4CN0_g8BgSKKdxZNZj9Yd2WG=0BFKjish=Vw=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy6=1vW4CN0_g8BgSKKdxZNZj9Yd2WG=0BFKjish=Vw=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> It should be easyish to fix by just adding a lock around those things.
> >
> > Like this:
> 
> Not quite.

.. new patch in another email...
.. snip..
> > Yikes. The fix could be to allocate a buffer large enough for the maximum
> > that %u could take * array_size and not bother with the first pass.
> 
> That's the simple approach. An alternative approach would be to start
> with a reasonable guess as to the size, and use krealloc() if needed
> to expand.
> 
> What are the realistic array sizes? If we're talking about arrays of
> just 16 words or something, just do the maximum (what, 12 bytes per
> 32-bit word? 11 bytes for the number, and then space/NUL after that).

30 words. ~360 + 29 spaces + NULL = 390?
> 
> If we're talking about potentially much bigger arrays, maybe we need
> to use krealloc() to handle it without wasting tons of memory for the
> common case..
> 
>              Linus
