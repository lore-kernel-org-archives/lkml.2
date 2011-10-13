Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab1JMSH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:07:29 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:33060 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753833Ab1JMSH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:07:28 -0400
Date: Thu, 13 Oct 2011 19:07:14 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <david.daney@cavium.com>
Cc: manesoni@cisco.com, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, ananth@in.ibm.com, kamensky@cisco.com
Subject: Re: [PATCH] MIPS Kprobes: Support branch instructions probing
Message-ID: <20111013180714.GA7422@linux-mips.org>
References: <20111013090749.GB16761@cisco.com>
 <4E971FD3.2020308@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E971FD3.2020308@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 10:28:51AM -0700, David Daney wrote:

> Where is the handling for:
> 
> 	case cop1_op:
> 
> #ifdef CONFIG_CPU_CAVIUM_OCTEON
> 	case lwc2_op: /* This is bbit0 on Octeon */
> 	case ldc2_op: /* This is bbit032 on Octeon */
> 	case swc2_op: /* This is bbit1 on Octeon */
> 	case sdc2_op: /* This is bbit132 on Octeon */
> #endif
> 
> These are all defined in insn_has_delayslot() but not here.

Which is a wonderful demonstration for why duplicating such a large
function from branch.c was a baaad thing to do.

Maneesh, can you refactor the code to share everything that was copied
from __compute_return_epc() can be shared with kprobes?  Idealy make
everything a two part series, first one patch to refactor branch.c and
the 2nd patch to deal with kprobes.

Thanks,

  Ralf
