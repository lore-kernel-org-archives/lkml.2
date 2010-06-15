Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab0FOJ0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 05:26:44 -0400
Received: from ozlabs.org ([203.10.76.45]:60880 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443Ab0FOJ0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 05:26:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for June 11
Date: Tue, 15 Jun 2010 18:56:37 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20100611141738.cf8a6bbf.sfr@canb.auug.org.au> <20100611163124.bbc01d34.akpm@linux-foundation.org>
In-Reply-To: <20100611163124.bbc01d34.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006151856.38882.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jun 2010 09:01:24 am Andrew Morton wrote:
> On Fri, 11 Jun 2010 14:17:38 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> > (patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).
> 
> Rusty broke your kernel!
> 
> oops: http://userweb.kernel.org/~akpm/IMG_20100611_155611.jpg
> 
> config: http://userweb.kernel.org/~akpm/stuff/config-akpm2-small.txt
> 
> (gdb) l *0xffffffff8105f9fb
> 0xffffffff8105f9fb is in get_ksymbol (kernel/module.c:2784).
> 2779                    if (mod->symtab[i].st_shndx == SHN_UNDEF)
> 2780                            continue;
> 2781    
> 2782                    /* We ignore unnamed symbols: they're uninformative
> 2783                     * and inserted at a whim. */
> 2784                    if (mod->symtab[i].st_value <= addr
> 2785                        && mod->symtab[i].st_value > mod->symtab[best].st_value
> 2786                        && *(mod->strtab + mod->symtab[i].st_name) != '\0'
> 2787                        && !is_arm_mapping_symbol(mod->strtab + mod->symtab[i].st_name))
> 2788                            best = i;

Hmm, I can't reproduce this :(  I'm only 32 bit here, have to dig out my
64-bit machine tomorrow.

One wonders why we're in get_ksymbol at all.  Has something already gone
horribly wrong?

Rusty.
