Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2IXM3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:29:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:51460 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877Ab2IXM3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:29:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,474,1344236400"; 
   d="scan'208";a="225732892"
Date: Mon, 24 Sep 2012 20:29:00 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Conny Seidel <conny.seidel@amd.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: divide error: bdi_dirty_limit+0x5a/0x9e
Message-ID: <20120924122900.GA28627@localhost>
References: <20120924102324.GA22303@aftab.osrc.amd.com>
 <50603829.9050904@linux.vnet.ibm.com>
 <20120924110554.GC22303@aftab.osrc.amd.com>
 <50604047.7000908@linux.vnet.ibm.com>
 <20120924113447.GA25182@localhost>
 <20120924122053.GD22303@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924122053.GD22303@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 02:20:53PM +0200, Borislav Petkov wrote:
> On Mon, Sep 24, 2012 at 07:34:47PM +0800, Fengguang Wu wrote:
> > Will you test such a line? At least the generic do_div() only uses the
> > lower 32bits for division.
> > 
> >         WARN_ON(!(den & 0xffffffff));
> 
> But, but, the asm output says:
> 
>   28:   48 89 c8                mov    %rcx,%rax
>   2b:*  48 f7 f7                div    %rdi     <-- trapping instruction
>   2e:   31 d2                   xor    %edx,%edx
> 
> and this version of DIV does an unsigned division of RDX:RAX by the
> contents of a *64-bit register* ... in our case %rdi.
> 
> Srivatsa's oops  shows the same:
> 
>   28:   48 89 f0                mov    %rsi,%rax
>   2b:*  48 f7 f7                div    %rdi     <-- trapping instruction
>   2e:   41 8b 94 24 74 02 00    mov    0x274(%r12),%edx
> 
> Right?

Right, that's why I said "at least". As for x86, I'm as clueless as you..

Thanks,
Fengguang
