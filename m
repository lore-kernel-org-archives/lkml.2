Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab0GVPKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 11:10:40 -0400
Received: from mtagate5.de.ibm.com ([195.212.17.165]:39497 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab0GVPKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 11:10:32 -0400
Date: Thu, 22 Jul 2010 17:10:28 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Sachin Sant <sachinp@in.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH wq#for-next] workqueue: fix how cpu number is stored in
 work->data
Message-ID: <20100722171028.2aa0b8f2@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <4C4838B8.1080400@kernel.org>
References: <4C46CEA3.7040503@in.ibm.com>
	<4C4718D5.1080902@kernel.org>
	<20100722112557.14b65077@mschwide.boeblingen.de.ibm.com>
	<4C4838B8.1080400@kernel.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jul 2010 14:25:28 +0200
Tejun Heo <tj@kernel.org> wrote:

> Once a work starts execution, its data contains the cpu number it was
> on instead of pointing to cwq.  This is added by commit 7a22ad75
> (workqueue: carry cpu number in work data once execution starts) to
> reliably determine the work was last on even if the workqueue itself
> was destroyed inbetween.
> 
> Whether data points to a cwq or contains a cpu number was
> distinguished by comparing the value against PAGE_OFFSET.  The
> assumption was that a cpu number should be below PAGE_OFFSET while a
> pointer to cwq should be above it.  However, on architectures which
> use separate address spaces for user and kernel spaces, this doesn't
> hold as PAGE_OFFSET is zero.
> 
> Fix it by using an explicit flag, WORK_STRUCT_CWQ, to mark what the
> data field contains.  If the flag is set, it's pointing to a cwq;
> otherwise, it contains a cpu number.
> 
> Reported on s390 and microblaze during linux-next testing.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Sachin Sant <sachinp@in.ibm.com>
> Reported-by: Michal Simek <michal.simek@petalogix.com>
> Reported-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
> Yeah, that was a stupid assumption by me.  Can you guys please test
> whether this fixes the problem?

Compiles and boots for s390. Thanks.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

