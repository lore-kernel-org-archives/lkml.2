Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab2E1BZl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 21:25:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:38044 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab2E1BZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 21:25:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104873301"
Date: Mon, 28 May 2012 09:22:09 +0800
From: Feng Tang <feng.tang@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]x86, reboot: Fix a warning message triggered by
 stop_other_cpus()
Message-ID: <20120528092209.60677c3b@feng-i7>
In-Reply-To: <20120522133356.GW32472@redhat.com>
References: <20120522105233.725be041@feng-i7>
	<20120522133356.GW32472@redhat.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

On Tue, 22 May 2012 09:33:56 -0400
Don Zickus <dzickus@redhat.com> wrote:

> On Tue, May 22, 2012 at 10:52:33AM +0800, Feng Tang wrote:
> > 
> > The root cause seems to be the default_send_IPI_mask_allbutself_phys()
> > takes quiet some time (I measured it could be several ms) to complete
> > sending NMIs to all the other 23 CPUs, and for HZ=250/1000 system, the
> 
> I sent Ingo a patch (which he took in), that reverts this path to interrupts
> again (and NMIs as a fallback if it fails).  The problem will still exist
> I assume though I don't know if it changes the timing characteristics.

Thanks for your review and letting me know the revert which I just saw in
the latest Linus' tree. And I think this new mechanism will greatly reduce
the possibility, but it still exist as the old nmi_stop_other_cpus's
implementation still exist. So

Ingo,

Could you review this patch? thanks,

-Feng

