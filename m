Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab1DBTUQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 15:20:16 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:36714 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab1DBTUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 15:20:14 -0400
Date: Sat, 02 Apr 2011 15:19:59 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Borislav Petkov <bp@alien8.de>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, x86@kernel.org,
        Hans Rosenfeld <hans.rosenfeld@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, borislav.petkov@amd.com
Subject: Re: [PATCH 07/18] x86 idle: clarify AMD erratum 400 workaround
In-reply-to: <20110402082316.GA21804@liondog.tnic>
Message-id: <alpine.LFD.2.02.1104021442460.18682@x980>
References: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
 <68477f71a39cd0ba9acd40e94e49969cbe1bec79.1301724243.git.len.brown@intel.com>
 <20110402082316.GA21804@liondog.tnic>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -static cpumask_var_t c1e_mask;
> > +static cpumask_var_t amd_e400_mask;
> 
> Actually, the correct name should be IMHO
> 
> 	amd_e400_c1e_mask

okay.

> > -			c1e_detected = true;
> > +			amd_e400_detected = true;
> 
> Hmm, c1e_detected is still the correct name since those two bits in
> the INT_PENDING MSR mean simply that the system can either generate an
> IO read or an SMI to enter C1E irrespective of E400. So I'd leave it
> c1e_detected.

We don't run the code that sets this flag unless
cpu_has_amd_erratum(amd_erratum_400)

so how about this?:

- c1e_detected
+ amd_e400_c1e_detected

> > -void __init init_c1e_mask(void)
> > +void __init init_amd_e400_mask(void)
> 
> Same here, init_amd_e400_c1e_mask.

done.

thanks,
Len Brown, Intel Open Source Technology Center

