Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab2AaMJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:09:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58712 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167Ab2AaMJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:09:44 -0500
Date: Tue, 31 Jan 2012 13:09:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@parallels.com>,
        linux-kernel@vger.kernel.org, hpa@linux.intel.com
Subject: Re: [PATCH] NVMe: Fix compilation on architecturs without
 readq/writeq
Message-ID: <20120131120922.GD32010@elte.hu>
References: <1327021265-22184-1-git-send-email-matthew.r.wilcox@intel.com>
 <CA+55aFwmDbDm5+12Nc0wnu7J8dsOKW0tCd_tVf-3pwQOq9MF3w@mail.gmail.com>
 <20120121082857.GC32134@elte.hu>
 <CAMO-S2hq0jGeUdAzMizDOhYJvPSQ=8+HVTUVqzsBOJotxOWrUg@mail.gmail.com>
 <20120121165830.GA9216@elte.hu>
 <CAMO-S2iegkRWGcnDt0SZqJT3Y3JHQZcHfMY=THKMN7n4Ae0Fyw@mail.gmail.com>
 <CA+55aFz=KcR5ji3TBHyfAYxFg8PCjXbdLOWf7aXULYHW4pp2kg@mail.gmail.com>
 <CAMO-S2iRT+uRzzsQRmhhCs4WRefsfFirteeKXtgX3h+kuWi+eQ@mail.gmail.com>
 <CA+55aFyxbieV2-WpFNrEtwQ6gXbW7y_X9oW5N6FcEcxmQKA38g@mail.gmail.com>
 <20120131115855.5861bad7@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120131115855.5861bad7@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> >   u64 val;
> >   val = readl(addr);
> >   val |= readl(addr+4) << 32;
> > 
> > is well-defined and must read the low word first - both at the C level
> > *and* at the CPU level. Anything else would be a bug in the
> > architecture "readl()" implementation or the hardware.
> 
> That doesn't make the access atomic to hardware however as a true 64bit
> readq/writeq would be ?
> 
> It seems to me the two are not quite the same semantically

Correct, and that's what the:

	#include <asm/io-inatomic.h>

line in the driver would express.

Thanks,

	Ingo
