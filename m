Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab1DFIEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 04:04:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:48665 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab1DFIEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 04:04:37 -0400
Subject: Re: [PATCH] sched: recover sched_yield task running time increase
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Alex Shi <alex.shi@intel.com>
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        tim.c.chen@intel.com, shaohua.li@intel.com
In-Reply-To: <1302042823-23022-1-git-send-email-alex.shi@intel.com>
References: <1302042823-23022-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 06 Apr 2011 10:04:24 +0200
Message-ID: <1302077064.2225.1357.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 06:33 +0800, Alex Shi wrote:
> commit ac53db596cc08ecb8040c removed the sched_yield task running
> time increase, so the yielded task get more opportunity to be launch
> again. That may not the caller want to be. And this also causes
> volano benchmark drop 50~80 percent performance on core2/NHM/WSM
> machines. This patch recover the sched_yield task vruntime up.

You do know that any app that relies on sched_yield behaviour is more
than broken? Using sched_yield() for anything other than SCHED_FIFO
tasks is well outside spec.

Furthermore, apparently you used sysctl_sched_compat_yield, which was
bound to disappear some time, since with the default settings the yield
semantics didn't actually change.

So no, I'm not much inclined to accept this. The Java people have had
every opportunity to go fix their crap, them not doing so will
eventually (preferably now) stop being my problem.

