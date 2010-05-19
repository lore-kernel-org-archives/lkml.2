Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab0ESIbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 04:31:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:48542 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab0ESIbx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 04:31:53 -0400
Subject: Re: [tip:perf/core] perf/ftrace: Optimize perf/tracepoint
 interaction for single events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20100519082335.GG5704@nowhere>
References: <tip-4f41c013f553957765902fb01475972f0af3e8e7@git.kernel.org>
	 <20100519075804.GF5704@nowhere> <1274257123.5605.10260.camel@twins>
	 <20100519082335.GG5704@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 May 2010 10:31:25 +0200
Message-ID: <1274257885.5605.10289.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 10:23 +0200, Frederic Weisbecker wrote:

> Yeah, then if you launch perf sched for example, you'll have NR_CPU perf events
> attached to each lock trace events, since we create one event per cpu.

Right, but simple per task (non-inherited) would have only 1.

But yeah, plenty of room to improve here.
