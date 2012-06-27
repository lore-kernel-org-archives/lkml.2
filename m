Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab2F0MhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 08:37:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:52252 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2F0MhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 08:37:07 -0400
Message-ID: <1340800594.10063.53.camel@twins>
Subject: Re: [PATCH v4 12/13] fair.c: Use generic rbtree impl in fair
 scheduler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Turner <pjt@google.com>, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>, Rob Landley <rob@landley.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Wed, 27 Jun 2012 14:36:34 +0200
In-Reply-To: <4FEA30B2.9010902@att.net>
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
	 <1340424048-7759-13-git-send-email-daniel.santos@pobox.com>
	 <1340712949.21991.57.camel@twins> <4FEA30B2.9010902@att.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-26 at 16:59 -0500, Daniel Santos wrote:
> Also, to address why we're not using entity_before (or a less()
> function) directly, there's two main reasons (one that doesn't even
> affect CFS).  The first reason is that an "is equal" evaluation would
> also be required for insertions in trees with unique keys,

Right, I saw that feature in your code, are there any such trees in the
kernel? It would be good to have a kernel code conversion for each
variant your code supports.

>  as well as
> all lookups.  This doesn't doesn't affect CFS because it isn't doing
> lookups (it only cares about leftmost) and duplicate keys are allowed.
> 
Right.. there's that.

Too bad, partial order is slightly cheaper at times. A well, nothing for
it.

