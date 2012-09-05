Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab2IEI5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:57:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab2IEI5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:57:05 -0400
Date: Wed, 5 Sep 2012 10:56:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] powerpc: fix personality handling in
 ppc64_personality()
In-Reply-To: <1346813643.2257.24.camel@pasglop>
Message-ID: <alpine.LNX.2.00.1209051056060.11079@pobox.suse.cz>
References: <alpine.LNX.2.00.1208012201520.14910@pobox.suse.cz>  <m27gtitfv4.fsf@igel.home>  <alpine.LNX.2.00.1208020907490.14910@pobox.suse.cz> <1346813643.2257.24.camel@pasglop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2012, Benjamin Herrenschmidt wrote:

> > Directly comparing current->personality against PER_LINUX32 doesn't work
> > in cases when any of the personality flags stored in the top three bytes
> > are used.
> > 
> > Directly forcefully setting personality to PER_LINUX32 or PER_LINUX
> > discards any flags stored in the top three bytes
> > 
> > Use personality() macro to compare only PER_MASK bytes and make sure that
> > we are setting only the bits that should be set, instead of
> > overwriting the whole value.
> > 
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > ---
> > 
> > changed since v1: fix the bit ops to reflect the fact that PER_LINUX is 
> > actually 0
> 
> Had already merged v1 (oops.. didn't spot the issue with PER_LINUX being
> 0). Can you send an incremental fixup ?

Hi Benjamin,

actually commit 7256a5d2da56 seems to contain the correct PER_LINUX 
handling, so seems like you picked the right one :)

Thanks,

-- 
Jiri Kosina
SUSE Labs
