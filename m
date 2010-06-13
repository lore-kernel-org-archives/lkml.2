Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab0FMIvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 04:51:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40107 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab0FMIvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 04:51:15 -0400
Date: Sun, 13 Jun 2010 10:51:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Brian Gordon <legerde@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Aerospace and linux
Message-ID: <20100613085111.GB6428@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Brian Gordon <legerde@gmail.com>, Andi Kleen <andi@firstfloor.org>,
	linux-kernel@vger.kernel.org
References: <AANLkTimrZvKyh6zYnUg2xzDVBVr5NxqtJhxZ42AVhkVI@mail.gmail.com>
 <877hm64ui4.fsf@basil.nowhere.org>
 <AANLkTik3XiOjYM67RdPG-3RM3rY-0vondiMmJsETAHfX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTik3XiOjYM67RdPG-3RM3rY-0vondiMmJsETAHfX@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Gordon <legerde@gmail.com>
Date: Thu, Jun 10, 2010 at 12:38:10PM -0600

Hi,

> > It's also a serious consideration for standard servers.
> Yes. Good point.
> 
> > On server class systems with ECC memory hardware does that.
> 
> > Normally server class hardware handles this and the kernel then reports
> > memory errors (e.g. through mcelog or through EDAC)
> 
> Agreed.  EDAC is a good and sane solution and most companies do this.
> Some do not due to naivity or cost reduction.   EDAC doesn't cover
> processor registers and I have fairly good solutions on how to deal
> with that in tiny "home-grown" tasking systems.

No, not processor registers but all cache levels of modern class x86
processors have ECC checking capability so that the possibility for the
data to go up dirty in the core is minimized. Now, if a bit flip is
caused by SEU while the data is passing the execution units then you
loose I guess. For such cases, some sort of processor redundancy is
needed to compare and validate results, as you say below.

> On the more exotic end, I have also seen systems that have dual
> redundant processors / memories.  Then they add compare logic between
> the redundant processors that compare most pins each clock cycle.   If
> any pins are not identical at a clock cycle, then something has gone
> wrong (SEU, hardware failure, etc..)
> 
> > Lower end systems which are optimized for cost generally ignore the
> > problem though and any flipped bit in memory will result
> > in a crash (if you're lucky) or silent data corruption (if you're unlucky)
> 
> Right!  And this is the area that I am interested in.  Some people
> insist on lowering the cost of the hardware without considering these
> issues.  One thing I want to do is to be as diligent as possible (even
> in these low cost situations) and do the best job I can in spite of
> the low cost hardware.
> 
> So, some pages of RAM are going to be read-only and the data in those
> pages came from some source (file system?).   Can anyone describe a
> high level strategy to occasionaly provide some coverage of this data?
> 
> So far I have thought about page descriptors adding an MD5 hash
> whenever they are read-only and first being "loaded/mapped?" and then
> a background daemon could occasionaly verify.

... and if a SEU corrupts the MD5 hash itself, this should cause a page
reload, right?

-- 
Regards/Gruss,
    Boris.
