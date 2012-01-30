Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab2A3Ryl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:54:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55974 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab2A3Ryk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:54:40 -0500
Date: Mon, 30 Jan 2012 09:54:34 -0800
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Dmitry Antipov <dmitry.antipov@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH 1/3] percpu: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
Message-ID: <20120130175434.GG3355@google.com>
References: <1327912654-8738-1-git-send-email-dmitry.antipov@linaro.org>
 <20120130171558.GB3355@google.com>
 <alpine.DEB.2.00.1201301121330.28693@router.home>
 <20120130174256.GF3355@google.com>
 <alpine.DEB.2.00.1201301145570.28693@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1201301145570.28693@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On Mon, Jan 30, 2012 at 11:52:23AM -0600, Christoph Lameter wrote:
> We have two possibilities now:
> 
> 1. We say that the value returned from the per cpu allocator is an opaque
> value.
> 
> 	This means that we have to remove the NULL check from the free
> 	function. And audit the kernel code for all occurrences where
> 	a per cpu pointer value of NULL is assumed to mean that no per
> 	cpu allocation has occurred.

No, NULL is never gonna be a valid return from any allocator including
percpu.  Percpu allocator doesn't and will never do so.

> 2. We say that there are special values for the per cpu pointers (NULL,
> 	ZERO_SIZE_PTR)
> 
> 	Then we would have to guarantee that the per cpu allocator never
> 	returns those values.
> 
> 	Plus then the ZERO_SIZE_PTR patch will be fine.
> 
> 	The danger exist of these values being passed as
> 	parameters to functions that do not support them (per_cpu_ptr
> 	etc). Those would need VM_BUG_ONs or some other checks to detect
> 	potential problems.

I'm saying we don't have this for ZERO_SIZE_PTR in any meaningful way
at this point.  If somebody wants to implement it properly, please
feel free to, but simply applying ZERO_SIZE_PTR without other changes
doesn't make any sense.

Thanks.

-- 
tejun
