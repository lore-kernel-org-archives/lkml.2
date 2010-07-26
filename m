Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab0GZFEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 01:04:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:52729 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab0GZFEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 01:04:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,260,1278313200"; 
   d="scan'208";a="589627674"
Subject: Re: [PATCH] Don't apply for write lock on tasklist_lock if parent
 doesn't ptrace other processes
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, andi.kleen@intel.com,
        stable@kernel.org
In-Reply-To: <20100723173453.GA29831@redhat.com>
References: <1279176663.2096.1264.camel@ymzhang.sh.intel.com>
	 <20100721144944.5351c741.akpm@linux-foundation.org>
	 <20100721222529.EFBAA400B6@magilla.sf.frob.com>
	 <20100722090524.GA6647@redhat.com>
	 <1279874705.2096.1274.camel@ymzhang.sh.intel.com>
	 <20100723173453.GA29831@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 26 Jul 2010 13:05:31 +0800
Message-Id: <1280120732.2085.3.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-23 at 19:34 +0200, Oleg Nesterov wrote:
> On 07/23, Zhang, Yanmin wrote:
> >
> > On Thu, 2010-07-22 at 11:05 +0200, Oleg Nesterov wrote:
> > > I am not surpized perf blaims tasklist, but I am really surpized this patch
> > > adds 10% improvement...
> > I changed aim7 workfile to focus on fork/exec and other a couple of sub-cases.
> > And this behavior is clear on 8-socket machines. 
> 
> Thanks...
> 
> > After applying my patch (although it's incorrect as there is a race with TRACEME),
> > perf shows write_lock_irq in forget_original_parent consumes less than 40% cpu time on
> > 8-socket machine.
> 
> Any chance you can test the patch I sent? It should have the same effect,
> otherwise there is something interesting.
1) with my patch, we got about 13% improvement;
2) With your patch, we got about 11% improvement;

Performance is very sensitive to spinlock contention on large machines.
 
> 
> > Is it possible to optimize it to use finer locks instead of the global tasklist_lock?
> 
> Heh. We must optimize it. But it is not clear when ;)
Thanks. It's better to remove the big lock.


