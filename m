Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab1ISSio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:38:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45168 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab1ISSin convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:38:43 -0400
Subject: Re: [PATCH 4/9] Include irq and softirq fields in cpuacct
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, xemul@parallels.com, paul@paulmenage.org,
        lizf@cn.fujitsu.com, daniel.lezcano@free.fr, mingo@elte.hu,
        jbottomley@parallels.com
Date: Mon, 19 Sep 2011 20:38:25 +0200
In-Reply-To: <1316030695-19826-5-git-send-email-glommer@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	 <1316030695-19826-5-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316457505.6091.14.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-14 at 17:04 -0300, Glauber Costa wrote:
> +       CPUACCT_STAT_IRQ,       /* ... irq ticks */
> +       CPUACCT_STAT_SOFTIRQ,   /* ... softirq ticks */

Would it make sense to make the cpustat thing an array as well? That way
the if forest will compute an array index and the cgroup and cpustat
parts can then use the 'same' code.

That avoids having to pass a cputime64_t* and int around for pretty much
the same thing.
