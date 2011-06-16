Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab1FPMKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:10:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:45844 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab1FPMKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:10:53 -0400
Subject: Re: [PATCHSET] stop_machine: implement
 stop_machine_from_offline_cpu()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tejun Heo <tj@kernel.org>
Cc: x86@kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, suresh.b.siddha@intel.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1308071218-5912-1-git-send-email-tj@kernel.org>
References: <1308071218-5912-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Jun 2011 14:10:19 +0200
Message-ID: <1308226219.13240.41.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 19:06 +0200, Tejun Heo wrote:
> This three patch series implements stop_machine_from_offline_cpu(),
> which is stop_machine() which can be used from a CPU which isn't yet
> online.
> 
> This is for mtrr which needs stop_machine while bringing up a CPU.  It
> currently implements its own stop_machine directly using
> stop_one_cpu().  Duplicating such core functionality is wasteful and
> fragile.  e.g. mtrr's implementation currently can deadlock against
> generic stop_machine().
> 
> This patchset is born from Suresh's attempt at implementing similar
> feature into [__]stop_machine()[1], which IMHO is a bit too subtle.
> Given the peculiarity of the feature, I think it's better to have
> dedicated function with an ugly name.  Also, this way, the
> implementation is very well isolated from the rest of stop_cpus
> machinery and much simpler. 

Maybe a silly question, but why does mtrr need all this? Surely mtrr can
serialize state by other means than stopping all cpus. A simple mutex
around the shared state blocking other cpus from updating the mtrr state
while we're copying the state to our newly born cpu should cure things.

I'm sure I'm missing something trivial here, but shouldn't we at least
explain the details and explore alternatives before merging ugly code?


