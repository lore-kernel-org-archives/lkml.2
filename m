Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab2I0FoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:44:23 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:58475 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755000Ab2I0FoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:44:21 -0400
Date: Wed, 26 Sep 2012 22:44:18 -0700
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, tim.c.chen@linux.intel.com
Subject: Re: [patch] crypto, tcrypt: remove local_bh_disable/enable()
 around local_irq_disable/enable()
Message-ID: <20120927054417.GC22311@gondor.apana.org.au>
References: <1347903446.26695.269.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347903446.26695.269.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 10:37:26AM -0700, Suresh Siddha wrote:
> Ran into this while looking at some new crypto code using FPU
> hitting a WARN_ON_ONCE(!irq_fpu_usable()) in the kernel_fpu_begin()
> on a x86 kernel that uses the new eagerfpu model. In short, current eagerfpu
> changes return 0 for interrupted_kernel_fpu_idle() and the in_interrupt()
> thinks it is in the interrupt context because of the local_bh_disable().
> Thus resulting in the WARN_ON().
> 
> Remove the local_bh_disable/enable() calls around the existing
> local_irq_disable/enable() calls. local_irq_disable/enable() already
> disables the BH.
> 
>  [ If there are any other legitimate users calling kernel_fpu_begin() from
>    the process context but with BH disabled, then we can look into fixing the
>    irq_fpu_usable() in future. ]
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
