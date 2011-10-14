Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab1JNRbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:31:15 -0400
Received: from ams-iport-2.cisco.com ([144.254.224.141]:32936 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab1JNRbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:31:14 -0400
X-IronPort-AV: E=Sophos;i="4.69,347,1315180800"; 
   d="scan'208";a="57827076"
Date: Fri, 14 Oct 2011 23:01:11 +0530
From: Maneesh Soni <manesoni@cisco.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <david.daney@cavium.com>, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, ananth@in.ibm.com, kamensky@cisco.com
Subject: Re: [PATCH] MIPS Kprobes: Support branch instructions probing
Message-ID: <20111014173111.GB8521@cisco.com>
Reply-To: manesoni@cisco.com
References: <20111013090749.GB16761@cisco.com>
 <4E971FD3.2020308@cavium.com>
 <20111013180714.GA7422@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111013180714.GA7422@linux-mips.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 07:07:14PM +0100, Ralf Baechle wrote:
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
> 
> Which is a wonderful demonstration for why duplicating such a large
> function from branch.c was a baaad thing to do.
> 
> Maneesh, can you refactor the code to share everything that was copied
> from __compute_return_epc() can be shared with kprobes?  Idealy make
> everything a two part series, first one patch to refactor branch.c and
> the 2nd patch to deal with kprobes.
> 

Sure.. the branch likely instructions are not make it look good but
still do it in the next version.

Thanks for the comments.

Regards,
Maneesh
