Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab1I2Qaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 12:30:52 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50198 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029Ab1I2Qav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 12:30:51 -0400
Subject: Re: [PATCH 2/2] mm: restrict access to /proc/meminfo
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>,
        kernel-hardening@lists.openwall.com, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Kees Cook <kees@ubuntu.com>, Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110929161848.GA16348@albatros>
References: <20110927175453.GA3393@albatros>
	 <20110927175642.GA3432@albatros> <20110927193810.GA5416@albatros>
	 <alpine.DEB.2.00.1109271459180.13797@router.home>
	 <alpine.DEB.2.00.1109271328151.24402@chino.kir.corp.google.com>
	 <20110929161848.GA16348@albatros>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Sep 2011 09:30:36 -0700
Message-ID: <1317313836.16137.620.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 20:18 +0400, Vasiliy Kulikov wrote:
> I'm not convinced with rounding the information to MBs.  The attacker
> still may fill slabs with new objects to trigger new slab pages
> allocations.  He will be able to see when this MB-granularity barrier is
> overrun thus seeing how many kbs there were before:
> 
>     old = new - filled_obj_size_sum
> 
> As `new' is just increased, it means it is known with KB granularity,
> not MB.  By counting used slab objects he learns filled_obj_size_sum.
> 
> So, rounding gives us nothing, but obscurity. 

I'll agree that it doesn't fundamentally fix anything.  But, it does
make an attack more difficult in the real world.  There's a reason that
real-world attackers are going after slabinfo: it's a fundamentally
*BETTER* than meminfo as a tool with which to aim an attack.  A
MB-rounded meminfo is also fundamentally *BETTER* than a
PAGE_SIZE-rounded meminfo.  I find it hard to call this "nothing".

Anyway...  I'm working on a patch.  Will post soon.

-- Dave

