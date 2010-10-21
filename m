Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab0JUAqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:46:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:5767 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab0JUAqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:46:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,214,1286175600"; 
   d="scan'208";a="669330867"
Subject: Re: [PATCH 4/5] x86, NMI: Allow NMI reason io port (0x61) to be
 processed on any CPU
From: Huang Ying <ying.huang@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>
In-Reply-To: <20101020100316.GX5969@erda.amd.com>
References: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
	 <1287195738-3136-5-git-send-email-dzickus@redhat.com>
	 <20101019150701.GR5969@erda.amd.com> <20101019162507.GU5969@erda.amd.com>
	 <20101019183720.GN4140@redhat.com> <1287534192.3026.9.camel@yhuang-dev>
	 <20101020100316.GX5969@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 08:46:35 +0800
Message-ID: <1287621995.19320.14.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 18:03 +0800, Robert Richter wrote:
> > > > > What about using raw_spin_trylock() instead? We don't have to wait
> > > > > here since we are already processing it by another cpu.
> > > > 
> > > > This would avoid a global lock and also deadlocking in case of a
> > > > potential #gp in the nmi handler.
> > > 
> > > I would feel more comfortable with it too.  I can't find a reason where
> > > trylock would do harm.
> > 
> > One possible issue can be as follow:
> > 
> > - PCI SERR NMI raised on CPU 0
> > - IOCHK NMI raised on CPU 1
> > 
> > If we use try lock, we may get unknown NMI on one CPU. Do you guys think
> > so?
> 
> This could be a valid point. On the other side the former
> implementation to let only handle cpu #0 i/o interrupts didn't trigger
> unknown nmis, so try_lock wouldn't change much compared to this.

Because we want to support BSP hot-remove, these NMIs may be redirected
to other CPUs. I think it may be possible after we hot-remove the BSP
PCI SERR NMI is routed to CPU 1, while IOCHK NMI is routed to CPU 2. The
raw_spin_lock() here is for that.

Best Regards,
Huang Ying

