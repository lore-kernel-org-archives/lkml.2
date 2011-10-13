Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab1JMTZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 15:25:55 -0400
Received: from mtv-iport-3.cisco.com ([173.36.130.14]:33160 "EHLO
	mtv-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1JMTZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 15:25:54 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Oct 2011 15:25:54 EDT
X-IronPort-AV: E=Sophos;i="4.69,342,1315180800"; 
   d="scan'208";a="7734723"
Date: Thu, 13 Oct 2011 12:16:27 -0700 (PDT)
From: Victor Kamensky <kamensky@cisco.com>
To: Ralf Baechle <ralf@linux-mips.org>
cc: David Daney <david.daney@cavium.com>, manesoni@cisco.com,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        ananth@in.ibm.com
Subject: Re: [PATCH] MIPS Kprobes: Support branch instructions probing
In-Reply-To: <20111013180714.GA7422@linux-mips.org>
Message-ID: <Pine.GSO.4.58.1110131205410.7452@infra-view9.cisco.com>
References: <20111013090749.GB16761@cisco.com> <4E971FD3.2020308@cavium.com>
 <20111013180714.GA7422@linux-mips.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 Oct 2011, Ralf Baechle wrote:

> On Thu, Oct 13, 2011 at 10:28:51AM -0700, David Daney wrote:
>
> > Where is the handling for:
> >
> > 	case cop1_op:
> >
> > #ifdef CONFIG_CPU_CAVIUM_OCTEON
> > 	case lwc2_op: /* This is bbit0 on Octeon */
> > 	case ldc2_op: /* This is bbit032 on Octeon */
> > 	case swc2_op: /* This is bbit1 on Octeon */
> > 	case sdc2_op: /* This is bbit132 on Octeon */
> > #endif
> >
> > These are all defined in insn_has_delayslot() but not here.

David, nice catch!

> Which is a wonderful demonstration for why duplicating such a large
> function from branch.c was a baaad thing to do.
>
> Maneesh, can you refactor the code to share everything that was copied
> from __compute_return_epc() can be shared with kprobes?  Idealy make
> everything a two part series, first one patch to refactor branch.c

Yes, it does make a lot of sense. Don't you think we need to do
EXPORT_SYMBOL for __compute_return_epc as well? So it could be used by
klms.

Actually we have yet another copy of it in mips uprobes code, which
normally is built as klm, if we refactor and export __compute_return_epc
all three places could use the same function.

Thanks,
Victor

> and
> the 2nd patch to deal with kprobes.
>
> Thanks,
>
>   Ralf
>
