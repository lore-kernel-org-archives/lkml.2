Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0EJPxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 11:53:53 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:35117 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab0EJPxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 11:53:51 -0400
Date: Mon, 10 May 2010 17:53:38 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>, Jim Cromie <jim.cromie@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 3/3] Try to convert non-trivial clocksources to
 clocksource_register_hz
Message-ID: <20100510175338.05ef5db8@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1272677785-23881-3-git-send-email-johnstul@us.ibm.com>
References: <1272677785-23881-1-git-send-email-johnstul@us.ibm.com>
	<1272677785-23881-2-git-send-email-johnstul@us.ibm.com>
	<1272677785-23881-3-git-send-email-johnstul@us.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Apr 2010 18:36:25 -0700
John Stultz <johnstul@us.ibm.com> wrote:

> NOT FOR INCLUSION!
> NOT FOR INCLUSION!
> 
> I've already gone through and converted the rest of the clocksources 
> to use clocksource_register_hz, and I'll be hopefully pushing those 
> to arch maintainers for 2.6.36-2.6.37.
> 
> However, in going through all the clocksources, I hit a few
> non-trivial conversions and wanted to bring them up on the list
> early so they can be handled soon.
> 
> The following patch tries to convert the non-trival clocksources
> to use clocksource_register_hz/khz. It is likely broken. I will
> need arch maintainer help to figure out the best way to resovle 
> these clocksources.
> 
> This patch requires the previous "Add clocksource_register_hz/khz 
> interface" patch to build. 
> 
> So any help maintainers can provide in finding solutions to
> break the mult/shift assumptions in the arch code would be
> greatly appreciated!
> 
> thanks
> -john
> 
> NOT FOR INCLUSION!
> NOT FOR INCLUSION!

The s390 conversion to clocksource_register_khz looks good - at least
the kilo hertz value is correct. Bit 2^12 of the TOD value are
microseconds, which makes one millisecond (1000<<12). 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

