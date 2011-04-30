Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab1D3EBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 00:01:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927Ab1D3EBR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 00:01:17 -0400
MIME-Version: 1.0
In-Reply-To: <web-515898476@zbackend1.aha.ru>
References: <web-515866242@zbackend1.aha.ru> <BANLkTimfOCwZQP=Hv+NEhFcxMpC51-RhTw@mail.gmail.com>
 <BANLkTinv38NtVQHrayus6v89BocsK6+iQQ@mail.gmail.com> <20110430025545.GI9487@ZenIV.linux.org.uk>
 <20110430030243.GJ9487@ZenIV.linux.org.uk> <BANLkTi=9Zq8AdGMyfwyp1nwyjD+PCGQydA@mail.gmail.com>
 <web-515898476@zbackend1.aha.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 29 Apr 2011 21:00:24 -0700
Message-ID: <BANLkTi=ujRJYG80F=HKqgz2nPeE5Gro+JA@mail.gmail.com>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: werner <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 8:39 PM, werner <w.landgraf@ru.ru> wrote:
>
> At my reclamation thread about 2.6.39-rc3,4 crashs, I informed that there
> was a reset-resistent change of the system after crashs, so that on
> subsequent boots (after a 'primary' crash rather at the end of booting) it
> happened an early 'secondary' šcrash at the time of initializing ata0, with
> funny effects like that the grafic card (or anything else) was identified as
> an ata device, with subsequent 'read erros' on it and crash. This
> 'secondary' effect repeated and repeated and gone away only at booting with
> a normal kernel (2.6.38.4 or 2.6.26.2). But if afterwards booting again with
> 2.6.39-rc3 or -rc4 , then at the end of the boot it crashed, and at
> subsequent boots again continued this reset-resistent effect that it crasha
> again and again with ata0 problems, until I reboot with 2.6.38.4 or 2.6.26.2
> , or waiting 5 minutes (perhaps until the memory discharged).
>
> All these problems dont happen with 2.6.38.4 or 2.6.26.2

Do you think you could bisect when that odd after-reset behavior started?

It does sound like you have some PCI-level problem (some device that
has "sticky" state and doesn't get reset properly). Most likely a
hardware "feature" (there is various PCI hardware that allows things
like device identifiers to be written to), coupled with a firmware bug
that doesn't reset things.

But it would be intriguing to hear when it started happening, so that
we can figure out exactly _what_ isn't getting properly reset..

The logfs oops may just be a result of "autodetect any random
filesystem" in that confused state. So when the state isn't confused,
you'd not see the oops, because nothing ever tries to mount the
invalid logfs image.

                 Linus
