Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab0KWJka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 04:40:30 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57843 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab0KWJk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 04:40:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=mheXdGOg6YxC1LGabp8xdvtsSc3GjLU0ITOrk9F3mi40XP+utGaDG/h/ZfTtQG8C5m
         vOy98R5hRxhhld5whQAhjHYJXovRBX1n7P+Hjni40999p/STxYiHyoQ9S1U32H0f6B8D
         GUDXPHtAZH7J2GoSlQUTUsj4tBVsD9Y6QiFgM=
Date: Tue, 23 Nov 2010 12:40:16 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] generic-ipi: add lock context annotations
Message-ID: <20101123094016.GC8882@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Jens Axboe <jaxboe@fusionio.com>, Namhyung Kim <namhyung@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1290411232-11439-1-git-send-email-namhyung@gmail.com>
 <1290430003.2072.101.camel@laptop>
 <1290482390.1857.26.camel@leonhard>
 <4CEB8034.80400@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEB8034.80400@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 09:49:56AM +0100, Jens Axboe wrote:
> I guess what Peter means is that the fact that the function grabs the
> lock is apparent in the code, if sparse was a bit "smarter", it would
> see and note this itself.

The sparse warning messages should have been included in the commit
message.  Here they are:

kernel/smp.c:513:6: warning: context imbalance in 'ipi_call_lock' - wrong count at exit
kernel/smp.c:518:6: warning: context imbalance in 'ipi_call_unlock' - unexpected unlock
kernel/smp.c:523:6: warning: context imbalance in 'ipi_call_lock_irq' - wrong count at exit
kernel/smp.c:528:6: warning: context imbalance in 'ipi_call_unlock_irq' - unexpected unlock

What happens is that sparse *does* see that the locks are unlocked and
that's what it complains about.

Sparse works before the code is linked so this change doesn't affect
anything outside kernel/smp.c.  If we added these annotations to
include/linux/smp.h then they would be used for checking
kernel/smpboot.c

regards,
dan carpenter

