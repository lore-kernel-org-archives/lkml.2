Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab1F2ND4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 09:03:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55906 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab1F2NDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 09:03:53 -0400
Date: Wed, 29 Jun 2011 15:03:49 +0200
From: Tejun Heo <tj@kernel.org>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: "Seidel, Conny" <Conny.Seidel@amd.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 32bit NUMA and fakeNUMA broken for AMD CPUs
Message-ID: <20110629130349.GM3386@htj.dyndns.org>
References: <20110621174131.054f0422.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110626102235.GC12200@mtj.dyndns.org>
 <20110626223807.47cef5c6.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110628174613.GP478@escobedo.osrc.amd.com>
 <20110629094451.GJ3386@htj.dyndns.org>
 <20110629123409.GL3386@htj.dyndns.org>
 <20110629125507.GQ478@escobedo.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629125507.GQ478@escobedo.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 02:55:08PM +0200, Hans Rosenfeld wrote:
> On Wed, Jun 29, 2011 at 08:34:09AM -0400, Tejun Heo wrote:
> > So, mminit_verify_page_links() detects it while the last 512MiB
> > highmem chunk of node 0 is being initialized and freaks out.
> > 
> > We definitely need a safe guard to check NUMA node alignment and
> > disable NUMA if it requires finer granuality than supported by the
> > memory model.  If you use DISCONTIGMEM, which has 64MiB granuality,
> > instead, it works, right?
> 
> I had DISCONTIGMEM enabled in the kernel config, it does not work.

Hmmm?  The following is the relevant part from your .config.

  CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
  CONFIG_ARCH_DISCONTIGMEM_DEFAULT=y
  CONFIG_ARCH_SPARSEMEM_ENABLE=y
  CONFIG_ARCH_SELECT_MEMORY_MODEL=y
  CONFIG_ILLEGAL_POINTER_VALUE=0
  CONFIG_SELECT_MEMORY_MODEL=y
  # CONFIG_DISCONTIGMEM_MANUAL is not set
  CONFIG_SPARSEMEM_MANUAL=y
  CONFIG_SPARSEMEM=y

And it selects SPARSEMEM via SPARSEMEM_MANUAL.  You need to choose
DISCONTIGMEM_MANUAL in "Processor type and features" -> "Memory
Model".

Thanks.

-- 
tejun
