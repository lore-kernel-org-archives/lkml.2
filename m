Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143Ab2KEPXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:23:24 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:25423 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933052Ab2KEPXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:23:07 -0500
Date: Mon, 5 Nov 2012 15:23:06 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Shan Wei <shanwei88@gmail.com>, dipankar@in.ibm.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 6/9] rcu: use __this_cpu_read helper instead of
 per_cpu_ptr(p, raw_smp_processor_id())
In-Reply-To: <20121103091909.GI3027@linux.vnet.ibm.com>
Message-ID: <0000013ad12afc1c-ceb72c4a-b0f2-4e79-8b09-9d7b716ce06b-000000@email.amazonses.com>
References: <5093EE6B.3070906@gmail.com> <20121102181026.GY3027@linux.vnet.ibm.com> <0000013ac2c6e1f0-c10ec42d-70bb-4e24-99d6-8e70653eca83-000000@email.amazonses.com> <20121103091909.GI3027@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2012, Paul E. McKenney wrote:

> OK, I do understand why it happens to work.  My question is instead why
> it is considered a good idea.  After all, it is the ->rda field that is
> marked __percpu, not the ->mynode field.  So in the interest of
> mechanical checking and general readability, it seems to me that it
> would be way better to apply __this_cpu_read() to rsp->rda rather than
> to rsp->rda->mynode.

mynode is part of the structure reached via rda.

Use on rsp->rda does not work since the offset of mynode must be added to
rda before a fetch related to the current cpus per cpu address can be
done.

this_cpu_ptr relocates and address. this_cpu_read() relocates the address
and performs the fetch. If you want to operate on rda then you can only
use this_cpu_ptr. this_cpu_read() saves you more instructions since it can
do the relocation and the fetch in one instruction.

