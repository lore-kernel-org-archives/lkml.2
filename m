Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab2JLV7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 17:59:05 -0400
Received: from mail.x86-64.org ([217.9.48.20]:59581 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab2JLV7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 17:59:03 -0400
Date: Fri, 12 Oct 2012 23:58:59 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [RFC PATCH 3/3] Convert mce_disabled
Message-ID: <20121012215859.GA18739@aftab.osrc.amd.com>
References: <1349878801-15956-1-git-send-email-bp@amd64.org>
 <1349878801-15956-4-git-send-email-bp@amd64.org>
 <5077F600.9090605@linux.vnet.ibm.com>
 <20121012115628.GA14991@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F19D4ABDA@ORSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D4ABDA@ORSMSX108.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 05:46:16PM +0000, Luck, Tony wrote:
> > Or, you can modify the mca_config I have there and use bools and pass a
> > pointer to each actual bool member in each DEVICE_BIT_ATTR invocation
> > (and rename it to DEVICE_BOOL_ATTR). Yeah, that could work, unless I'm
> > missing something else, of course.
> 
> This looks like the best solution to me. Sure we use a little more memory for
> a "bool" for each option instead of just a single bit. But there are only a
> handful of them, not thousands. So I think we can cope with a few extra
> bytes of memory consumption.  I was still not completely convinced by the
> 
>        if (val)
>                *bvec |= le64_to_cpu(BIT_64(bit));
> 
> solution - it assumes that big endian machines also assign their bit numbers
> in a big->little way - but that isn't required by the C standard. bitfields are
> assigned at the whim of the compiler writer (the only restrictions seem to
> be on alignments of fields w.r.t. to the underlying data types).

Ok, it seems that would've been a can of worms if we'd opened it.

Fortunately, if we do bools and we pass a pointer to the respective bool
member of mca_config, we won't need to do that anymore. Instead simply:

	*bool_ptr = !!val;

It can't get any simpler than that. I'll give it a try soon to see
whether it pans out as I'm imagining it.

Thanks.


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
