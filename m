Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab1FPS2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:28:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:56352 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391Ab1FPS2s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:28:48 -0400
Subject: Re: [PATCH 1/3] stop_machine: kill __stop_machine()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Tejun Heo <tj@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1308248260.2682.413.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1308071218-5912-1-git-send-email-tj@kernel.org>
	 <1308071218-5912-2-git-send-email-tj@kernel.org>
	 <1308226372.13240.42.camel@twins>
	 <1308245872.2682.369.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1308246910.13240.238.camel@twins>
	 <1308248260.2682.413.camel@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Jun 2011 20:28:17 +0200
Message-ID: <1308248897.13240.272.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 11:17 -0700, Suresh Siddha wrote:

> > > Peter, So it looks like we are allowing a new cpu to come online in
> > > parallel, while we poke the text? Isn't it a problem? What am I missing?
> > 
> > the caller already did get_online_cpus(), 
> > 
> > do_optimize_kprobes()
> >   get_online_cpus()
> >   arch_optimize_kprobes()
> >     text_poke_smp_batch()
> >   put_online_cpus()
> 
> So the circular dependency reported is not possible in practice right?

why not? get_online_cpus() takes a mutex, that connects smp_alt and
text_mutex and can cause a deadlock.
