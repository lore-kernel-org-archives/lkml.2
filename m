Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab1CBPq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 10:46:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45763 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab1CBPq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 10:46:56 -0500
Date: Wed, 2 Mar 2011 16:46:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Don Zickus <dzickus@redhat.com>, "Huang, Ying" <ying.huang@intel.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 2/2 resend] x86, traps: Drop nmi_reason_lock until
 it is really needed
Message-ID: <20110302154645.GA11827@elte.hu>
References: <4D6E631B.6040701@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6E631B.6040701@openvz.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> At moment we have only BSP apic configured to listen
> for external NMIs. So there is no reason for additional
> spinlock since only BSP will receive them.
> 
> Though we still have UV chips which do enable external NMIs
> on all cpus, but since an approach to allow retrieving
> NMI reason on BSP only was working pretty fine before --
> I assume it still remains valid.

I'm not sure I get the point here: we might get NMIs on non-BSP on UV
systems ... so we want to remove the spinlock?

If UV systems can get NMIs on any CPU then the lock is needed.

It might have worked before - but UV systems are rare and relatively
new - plus the race window is small, so it might not have been triggered
in practice.

> Also it's worth to mention that an initial idea of all this
> NMI code-path changes was to make BSP hot-unpluggable but
> until all other parts of kernel is prepared for it (which
> might consume quite a time to implement) I believe we should
> not lock/unlock for nothing.

That would be another argument in favor of keeping the lock, right?

Thanks,

	Ingo
