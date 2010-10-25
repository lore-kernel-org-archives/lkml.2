Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab0JYJTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 05:19:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33144 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0JYJTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:19:22 -0400
Date: Mon, 25 Oct 2010 11:19:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Borislav Petkov <petkovbb@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [NAK] Re: [PATCH -v2 9/9] ACPI, APEI, Generic Hardware Error
 Source POLL/IRQ/NMI notification type support
Message-ID: <20101025091913.GA17622@basil.fritz.box>
References: <1287992610-14996-1-git-send-email-ying.huang@intel.com>
 <1287992610-14996-10-git-send-email-ying.huang@intel.com>
 <20101025084553.GA27119@elte.hu>
 <1287997112.2862.322.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287997112.2862.322.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Sigh, please integrate all this into EDAC (drivers/edac/) properly, instead of 
> > turning it into YET ANOTHER hardware vendor special hw-errors thing. We can do 
> > better than this. EDAC is almost there: it has support for Nehalem, AMD, a couple
> > of older chips.
> 
> I think APEI (ACPI Platform Error Interface) is another driver. Why
> integrate two drivers?

Yes they're solving quite different problems from EDAC with different
interfaces and for different devices in the ACPI space.

The earlier nack seems to be based on a lot of confusion on what the code 
does.

Besides it nacks code in areas Ingo doesn't even maintain.
(if he's allowed to nack random other code he doesn't like do I get this 
right too? :-)

> > einj.c: it's about the 3rd separate 'error injection' concept that got introduced 
> > ...
> 
> EINJ is a true platform feature, not just software feature. We need to
> support it to debug various hardware error features.

Also having multiple error injecting interfaces is a good thing.

Error injection is hard and one size definitely doesn't fit all. You need
quite different ones depending on what you want to test, in which
context etc.

For hwpoison we currently have three different injectors at least and I expect
that to even grow more in the future as different features get added.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
