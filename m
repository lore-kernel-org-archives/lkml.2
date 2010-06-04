Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab0FDFhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 01:37:05 -0400
Received: from ozlabs.org ([203.10.76.45]:51156 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab0FDFhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 01:37:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the final tree (rr tree related)
Date: Fri, 4 Jun 2010 15:06:59 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100604144933.86b3f2a8.sfr@canb.auug.org.au>
In-Reply-To: <20100604144933.86b3f2a8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006041506.59887.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010 02:19:33 pm Stephen Rothwell wrote:
> Hi Rusty,
> 
> After merging the final tree, today's linux-next build (powerpc
> ppc44x_defconfig) failed like this:
> 
> kernel/module.c: In function 'post_relocation':
> kernel/module.c:2526: error: 'struct module' has no member named 'percpu_size'
> 
> Caused by commit fc77407bc287ed250f9355fda435df5f78b45885 ("module:
> simplify per-cpu handling a little").
> 
> This build has CONFIG_SMP not set

Actually, I think that cleanup is broken.  If someone were to have relocations
inside their per-cpu area, the relocation code would smash something random.

So, a doubly bad idea.  I've dropped the commit.

Thanks!
Rusty.
