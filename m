Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab0DTOuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 10:50:13 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:57589 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab0DTOuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:50:11 -0400
Date: Tue, 20 Apr 2010 07:50:09 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Christoph Hellwig <hch@lst.de>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: correctly wire up the newuname system call
Message-ID: <20100420145009.GA13376@hexapodia.org>
References: <20100420033102.GA13406@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100420033102.GA13406@lst.de>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 05:31:02AM +0200, Christoph Hellwig wrote:
> Before commit e28cbf22933d0c0ccaf3c4c27a1a263b41f73859 64-bit x86 had
> a private implementation of sys_uname which was just called sys_uname,
> which other architectures used for the old uname.  Due to some merge
> issues with the uname refactoring patches we ended up calling the
> old uname version for both the old and new system call slots, which
> lead to the domainname filed never be set which caused failures with
                         ^^^^^ field.

> libnss_nis.
> 
> Reported-by: Andy Isaacson <adi@hexapodia.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/arch/x86/ia32/ia32entry.S
> ===================================================================
> --- linux-2.6.orig/arch/x86/ia32/ia32entry.S	2010-04-19 20:21:11.919003961 -0700
> +++ linux-2.6/arch/x86/ia32/ia32entry.S	2010-04-19 20:21:19.902005565 -0700
> @@ -626,7 +626,7 @@ ia32_sys_call_table:
>  	.quad stub32_sigreturn
>  	.quad stub32_clone		/* 120 */
>  	.quad sys_setdomainname
> -	.quad sys_uname
> +	.quad sys_newuname

Yes, that's the same patch I arrived at and fixes the issue for me.

Tested-by: Andy Isaacson <adi@hexapodia.org>

Thanks,
-andy
