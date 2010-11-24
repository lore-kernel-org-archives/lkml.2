Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab0KXFYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 00:24:49 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47296 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab0KXFYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 00:24:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=f6tWdT1Lc+2L9QSP6+eePqp5K2BqcZtkI5o+VpkT1olByZ+79onQRf4Wz5SgZSPs0q
         j+XzIXPHYvNbFlBZDfdImVifmDEWyYfeAa981+kM/3Nl5+/HvokCLbOp0IlaEcAax984
         YxLL5ZrcNmB+vkXHYpfAQK20AJvfs3X+or+QA=
Subject: Re: [PATCH] generic-ipi: add lock context annotations
From: Namhyung Kim <namhyung@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101123094016.GC8882@bicker>
References: <1290411232-11439-1-git-send-email-namhyung@gmail.com>
	 <1290430003.2072.101.camel@laptop> <1290482390.1857.26.camel@leonhard>
	 <4CEB8034.80400@fusionio.com>  <20101123094016.GC8882@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 14:24:40 +0900
Message-ID: <1290576280.1690.13.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-11-23 (화), 12:40 +0300, Dan Carpenter: 
> On Tue, Nov 23, 2010 at 09:49:56AM +0100, Jens Axboe wrote:
> > I guess what Peter means is that the fact that the function grabs the
> > lock is apparent in the code, if sparse was a bit "smarter", it would
> > see and note this itself.
> 
> The sparse warning messages should have been included in the commit
> message.  Here they are:
> 
> kernel/smp.c:513:6: warning: context imbalance in 'ipi_call_lock' - wrong count at exit
> kernel/smp.c:518:6: warning: context imbalance in 'ipi_call_unlock' - unexpected unlock
> kernel/smp.c:523:6: warning: context imbalance in 'ipi_call_lock_irq' - wrong count at exit
> kernel/smp.c:528:6: warning: context imbalance in 'ipi_call_unlock_irq' - unexpected unlock
> 
> What happens is that sparse *does* see that the locks are unlocked and
> that's what it complains about.
> 
> Sparse works before the code is linked so this change doesn't affect
> anything outside kernel/smp.c.  If we added these annotations to
> include/linux/smp.h then they would be used for checking
> kernel/smpboot.c
> 
> regards,
> dan carpenter
> 

I tried to annotate declations in include/linux/smp.h but it didn't work
well. Maybe that's what we need to fix the sparse?

Anyway, Jens, do you want new patch which includes above warnings?

Thanks.

-- 
Regards,
Namhyung Kim



