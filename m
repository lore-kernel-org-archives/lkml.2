Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761684Ab2KAOc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:32:57 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:19254 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761656Ab2KAOcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:32:51 -0400
Date: Thu, 1 Nov 2012 14:32:49 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/9] rcu:  use this_cpu_ptr per-cpu helper instead of
 per_cpu_ptr(p, raw_smp_processor_id())
In-Reply-To: <50923C2F.6060200@gmail.com>
Message-ID: <0000013abc638281-aaf452ca-0b94-4d56-8b8d-6b2b0c683668-000000@email.amazonses.com>
References: <50910A17.1090600@gmail.com> <0000013ab7eefc03-20a4ba94-f83f-4624-9dac-dfe3924277b4-000000@email.amazonses.com> <20121031200842.GC3027@linux.vnet.ibm.com> <50923C2F.6060200@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2012, Shan Wei wrote:

> Paul E. McKenney said, at 2012/11/1 4:08:
> >
> > One thing to keep in mind -- the only purpose of this is to diffuse
> > memory contention.  So there is no need to disable preemption.
>
> same question to me.
> Christoph, maybe __this_cpu_read is a better choice which don't disable preemption.

Correct. Use __this_cpu_read to reduce overhead on processor that require
emulation.

