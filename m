Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab0GWNHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 09:07:53 -0400
Received: from www.tglx.de ([62.245.132.106]:49841 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab0GWNHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 09:07:51 -0400
Date: Fri, 23 Jul 2010 15:07:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: akpm@linux-foundation.org
cc: John Stultz <johnstul@us.ibm.com>, maglyx@gmail.com, clemens@ladisch.de,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/3] hpet: factor timer allocate from open
In-Reply-To: <201007202223.o6KMNDZl021345@imap1.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1007231500180.2616@localhost.localdomain>
References: <201007202223.o6KMNDZl021345@imap1.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010, akpm@linux-foundation.org wrote:

> From: Magnus Lynch <maglyx@gmail.com>
> 
> The current implementation of the /dev/hpet driver couples opening the
> device with allocating one of the (scarce) timers (aka comparators).  This
> is a limitation in that the main counter may be valuable to applications
> seeking a high-resolution timer who have no use for the interrupt
> generating functionality of the comparators.

And how exactly does this patch provide such functionality ? There is
no interface which allows you to access the counter itself. All what
this patch does is removing the allocation from open() and sprinkle
the allocation all over the place for _ZERO_ benefit.

I really have a hard time to understand why anything would open
/dev/hpet just to do nothing with it.

Thanks,

	tglx
