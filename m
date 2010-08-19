Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab0HSMsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 08:48:41 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:6280 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890Ab0HSMsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 08:48:39 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o7JCmUIl013928
Subject: Re: [RFC][PATCH] introduce ptr_diff()
From: Bernd Petrovitsch <bernd@sysprog.at>
To: Andi Kleen <andi@firstfloor.org>
Cc: Namhyung Kim <namhyung@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <87aaoiu6z6.fsf@basil.nowhere.org>
References: <1282217856-8625-1-git-send-email-namhyung@gmail.com>
	 <87aaoiu6z6.fsf@basil.nowhere.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 14:48:29 +0200
Message-ID: <1282222109.10440.50.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-wuwien-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Don, 2010-08-19 at 14:23 +0200, Andi Kleen wrote:
> Namhyung Kim <namhyung@gmail.com> writes:
> 
> > When I compiled allyesconfig'ed kernel with C=1, I got 1519 lines of
> > following message:
> >
> >  include/linux/mm.h:599:16: warning: potentially expensive pointer subtraction
> >
> > which is around 10% of total warnings. this was caused by page_to_pfn() macro
> > so I think it's worth to remove it by calculating pointer subtraction
> > manually.
> 
> IMHO it would be better to simply disable the warning in sparse instead
> of uglying the code just to work around sparse bogosity. It doesnt' seem
> to make much sense. A subtraction followed by a shift is not expensive.

The code above is IMHO actually (the line with "return" in)
----  snip  ----
static __always_inline void *lowmem_page_address(struct page *page)
{
	return __va(PFN_PHYS(page_to_pfn(page)));
}
----  snip  ----
If so, the warning seems valid as sizeof(struct page) is probably not
(always) a power of 2. On a native build on x86_64 it is 56 bytes
hereover.
Hmm ....

	Bernd
-- 
mobile: +43 664 4416156              http://www.sysprog.at/
    Linux Software Development, Consulting and Services

