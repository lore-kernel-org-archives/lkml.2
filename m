Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab0CVFNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 01:13:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:38215 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab0CVFNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 01:13:37 -0400
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from
 e820.c to fw_memmap.c
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <4BA6EA62.1030603@kernel.org>
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
	 <1269155601-18247-7-git-send-email-yinghai@kernel.org>
	 <1269225435.8599.70.camel@pasglop>  <4BA6EA62.1030603@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Mar 2010 16:12:03 +1100
Message-ID: <1269234723.8599.76.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-21 at 20:56 -0700, Yinghai Lu wrote:
> On 03/21/2010 07:37 PM, Benjamin Herrenschmidt wrote:
> > On Sun, 2010-03-21 at 00:13 -0700, Yinghai Lu wrote:
> >> move it to kernel/fw_memmap.c from arch/x86/kernel/e820.c
> >>
> >> -v2: add fw_memmap wrapper to some func...
> >>      move some functions back to e820.c
> > 
> > NAK
> at this point, kernel/early_res.c and kernel/fw_memmap.c is protected with HAVE_EARLY_RES
> 
> obj-$(CONFIG_HAVE_EARLY_RES) += early_res.o fw_memmap.o
> 
> so it will not increase size that doesn't support early_res/bootmem yet.

I'm still not at all happy with it. It's not only about increasing the
size of the kernel. It's about moving some x86 specific stuff and more
or less arbitrarily deciding that everybody has to convert to that model
now, despite the fact that more suited alternatives have existed for
years, rather than thinking about doing the logical thing, which is to
convert x86 over to lmb, eventually adding the missing functionalities
in lmb if need be.

Also, there's something just plain gross about the choice of names.

fw_memmap is something I wouldn't wish my enemies to have to type on a
keyboard, it looks ugly, and it lends to way too long function names. In
addition to the fact that your "generic" facility is still all cluttered
with the e820 names and other very x86 centric definitions.

It -may- well be that adapting x86 to lmb isn't a practical approach,
but if that was the case, then please justify why with precise technical
reasons, which we can discuss then in details and make a decision based
on that.

Cheers,
Ben.


