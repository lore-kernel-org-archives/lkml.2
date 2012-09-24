Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab2IXMVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:21:01 -0400
Received: from mail.x86-64.org ([217.9.48.20]:32780 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab2IXMVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:21:00 -0400
Date: Mon, 24 Sep 2012 14:20:53 +0200
From: Borislav Petkov <bp@amd64.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Borislav Petkov <bp@amd64.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Conny Seidel <conny.seidel@amd.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: divide error: bdi_dirty_limit+0x5a/0x9e
Message-ID: <20120924122053.GD22303@aftab.osrc.amd.com>
References: <20120924102324.GA22303@aftab.osrc.amd.com>
 <50603829.9050904@linux.vnet.ibm.com>
 <20120924110554.GC22303@aftab.osrc.amd.com>
 <50604047.7000908@linux.vnet.ibm.com>
 <20120924113447.GA25182@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924113447.GA25182@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 07:34:47PM +0800, Fengguang Wu wrote:
> Will you test such a line? At least the generic do_div() only uses the
> lower 32bits for division.
> 
>         WARN_ON(!(den & 0xffffffff));

But, but, the asm output says:

  28:   48 89 c8                mov    %rcx,%rax
  2b:*  48 f7 f7                div    %rdi     <-- trapping instruction
  2e:   31 d2                   xor    %edx,%edx

and this version of DIV does an unsigned division of RDX:RAX by the
contents of a *64-bit register* ... in our case %rdi.

Srivatsa's oops  shows the same:

  28:   48 89 f0                mov    %rsi,%rax
  2b:*  48 f7 f7                div    %rdi     <-- trapping instruction
  2e:   41 8b 94 24 74 02 00    mov    0x274(%r12),%edx

Right?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
