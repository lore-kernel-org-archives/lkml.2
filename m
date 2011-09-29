Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab1I2Qon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 12:44:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58504 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab1I2Qom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 12:44:42 -0400
Date: Thu, 29 Sep 2011 20:43:41 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-hardening@lists.openwall.com
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Kees Cook <kees@ubuntu.com>, Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [kernel-hardening] Re: [PATCH 2/2] mm: restrict access to
 /proc/meminfo
Message-ID: <20110929164341.GA16888@albatros>
References: <20110927175453.GA3393@albatros>
 <20110927175642.GA3432@albatros>
 <20110927193810.GA5416@albatros>
 <alpine.DEB.2.00.1109271459180.13797@router.home>
 <alpine.DEB.2.00.1109271328151.24402@chino.kir.corp.google.com>
 <20110929161848.GA16348@albatros>
 <1317313836.16137.620.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317313836.16137.620.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 09:30 -0700, Dave Hansen wrote:
> On Thu, 2011-09-29 at 20:18 +0400, Vasiliy Kulikov wrote:
> > I'm not convinced with rounding the information to MBs.  The attacker
> > still may fill slabs with new objects to trigger new slab pages
> > allocations.  He will be able to see when this MB-granularity barrier is
> > overrun thus seeing how many kbs there were before:
> > 
> >     old = new - filled_obj_size_sum
> > 
> > As `new' is just increased, it means it is known with KB granularity,
> > not MB.  By counting used slab objects he learns filled_obj_size_sum.
> > 
> > So, rounding gives us nothing, but obscurity. 
> 
> I'll agree that it doesn't fundamentally fix anything.  But, it does
> make an attack more difficult in the real world.

No, it doesn't.  An attacker is able to simply add/remove objects from
slab and get the precise numbers.  The only thing it takes some time,
but the delay is negligible.  It neither eliminates the whole attack
vector in specific cases nor makes the attacks probabilistic.


>  There's a reason that
> real-world attackers are going after slabinfo: it's a fundamentally
> *BETTER* than meminfo as a tool with which to aim an attack.

Agreed, it gives much more information.


>  A
> MB-rounded meminfo is also fundamentally *BETTER* than a
> PAGE_SIZE-rounded meminfo.  I find it hard to call this "nothing".

Could you elaborate?  As I've tried to describe above, an attacker still
may recover the numbers.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
