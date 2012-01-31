Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab2AaMRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:17:22 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38321 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab2AaMRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:17:20 -0500
Date: Tue, 31 Jan 2012 12:18:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@parallels.com>,
        linux-kernel@vger.kernel.org, hpa@linux.intel.com
Subject: Re: [PATCH] NVMe: Fix compilation on architecturs without
 readq/writeq
Message-ID: <20120131121820.58a1db97@pyramind.ukuu.org.uk>
In-Reply-To: <20120131120922.GD32010@elte.hu>
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
	<20120131120922.GD32010@elte.hu>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 13:09:22 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > >   u64 val;
> > >   val = readl(addr);
> > >   val |= readl(addr+4) << 32;
> > > 
> > > is well-defined and must read the low word first - both at the C level
> > > *and* at the CPU level. Anything else would be a bug in the
> > > architecture "readl()" implementation or the hardware.
> > 
> > That doesn't make the access atomic to hardware however as a true 64bit
> > readq/writeq would be ?
> > 
> > It seems to me the two are not quite the same semantically
> 
> Correct, and that's what the:
> 
> 	#include <asm/io-inatomic.h>
> 
> line in the driver would express.

Why would "inatomic" indicate that - I'm confused. It would imply to me
they were extra specially atomic ?  

(atomos if from the Greek so in- as a prefix isn't the same in- as in
many other words, welcome to English hell - who needs perl)

non-atomic.h might be better, or 'un-atomic' or 'multi-read' or
something ?

Alan
