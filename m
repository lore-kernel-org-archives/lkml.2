Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab2JOWGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 18:06:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:32828 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079Ab2JOWGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 18:06:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,590,1344236400"; 
   d="scan'208";a="235385853"
Date: Mon, 15 Oct 2012 15:06:39 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Qing Z <njumical@gmail.com>, mingo@kernel.org, ben@decadent.org.uk,
        markivx@codeaurora.org, linux-kernel@vger.kernel.org,
        cxie4@marvell.com, binw@marvell.com, wwang27@marvell.com,
        xjian@marvell.com, zhangwm@marvell.com, Qing Zhu <qzhu@marvell.com>
Subject: Re: [PATCH] panic: fix incomplete panic log in panic()
Message-ID: <20121015220639.GT2095@tassilo.jf.intel.com>
References: <BD54883EA7DE8B41A61B7E723561C711139F75D348@sc-vexch3.marvell.com>
 <CAE-am1NFB+opbid_f7RA_9EXUKjPCJssdOcZBrEQmQHG4EP9Gg@mail.gmail.com>
 <20121015150204.6f837a39.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121015150204.6f837a39.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, we should be careful with things like up() on a semaphore which
> hasn't been down()ed.  Because under some Kconfig combinations, such an
> operation might trigger debugging traces and we could get into a big
> mess.  (An up() on non-down()ed semaphore is actually an OK operation,
> so this was a bad example.  But you see the problem).

iirc the debugging code normally checks oops_in_progress, so this shouldn't 
happen.

Agree on the rest of your email -- keep oops simple ... (KOSS)

-Andi
