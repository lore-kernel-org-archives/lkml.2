Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab0C2RDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:03:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51412 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab0C2RDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:03:13 -0400
Date: Mon, 29 Mar 2010 19:02:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       Stephane Eranian <eranian@google.com>
Subject: Re: [RFC,PATCH 2/2] perf, x86: Utilize the LBRs for machine/oops
 debugging
Message-ID: <20100329170259.GA15083@elte.hu>
References: <20100329122021.765109681@chello.nl>
 <20100329122138.848413757@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329122138.848413757@chello.nl>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> The LBRs are relatively cheap to keep enabled and provide some history to 
> OOPSen, also some CPUs are reported to keep them over soft-reset, which 
> allows us to use them to debug things like tripple faults.
> 
> Therefore introduce a boot option: lbr_debug=on, which always enable the 
> LBRs and will print the LBRs on CPU init and die().

Yummie!

Have you got some sample lbr_debug=1 output as well by any chance, with a 
crash provoked somewhere? How good is the output in practice? (i.e. how many 
artificial entries do we have at the end of the buffer, filled with crash 
related addresses?)

Also, i think we should use something more descriptive than lbr_debug=y. 
Perhaps crash_trace=1 or so?

Plus, it would be nice to have a sysctl entry for this as well - so that 
production systems can enable this if they want to enrich the output of some 
difficult-to-analyze kernel crash, without yet another reboot.

	Ingo
