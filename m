Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab1DFPZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 11:25:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53390 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab1DFPZX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 11:25:23 -0400
Subject: Re: [PATCH] sched: recover sched_yield task running time increase
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: Alex Shi <alex.shi@intel.com>, linux-kernel@vger.kernel.org, mingo@elte.hu,
        tim.c.chen@intel.com, shaohua.li@intel.com
In-Reply-To: <4D9C7BE1.6010502@redhat.com>
References: <1302042823-23022-1-git-send-email-alex.shi@intel.com>
	 <1302077064.2225.1357.camel@twins>  <4D9C7BE1.6010502@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 06 Apr 2011 17:25:07 +0200
Message-ID: <1302103507.2225.1391.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 10:42 -0400, Rik van Riel wrote:

> It appears they might not have figured out how to fix
> their stuff :)

As far as I can tell they're totally not interested in fixing their
crap, it comes up every time we touch sched_yield() but nobody ever
steps up and fixes things.

> Would you have any hints on what the Java folks should
> replace their calls to sched_yield with?
> 
> Proper use of futexes from inside the JVM perhaps?

Yeah, Darren was working on making adaptive spinning futexes, but still
even without that, syscalls on x86 are so cheap there's really hardly
any point in actually spinning in userspace.

> Or should we export yield_to to userspace and have
> them use that? :)   *runs*

Hehe, no, yield_to() is an absolute abomination (much like yield itself
but worse), they have proper locks and should thus use proper
primitives.
