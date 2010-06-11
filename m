Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab0FKXbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 19:31:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518Ab0FKXbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 19:31:36 -0400
Date: Fri, 11 Jun 2010 16:31:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: Tree for June 11
Message-Id: <20100611163124.bbc01d34.akpm@linux-foundation.org>
In-Reply-To: <20100611141738.cf8a6bbf.sfr@canb.auug.org.au>
References: <20100611141738.cf8a6bbf.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 14:17:38 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).

Rusty broke your kernel!

oops: http://userweb.kernel.org/~akpm/IMG_20100611_155611.jpg

config: http://userweb.kernel.org/~akpm/stuff/config-akpm2-small.txt

(gdb) l *0xffffffff8105f9fb
0xffffffff8105f9fb is in get_ksymbol (kernel/module.c:2784).
2779                    if (mod->symtab[i].st_shndx == SHN_UNDEF)
2780                            continue;
2781    
2782                    /* We ignore unnamed symbols: they're uninformative
2783                     * and inserted at a whim. */
2784                    if (mod->symtab[i].st_value <= addr
2785                        && mod->symtab[i].st_value > mod->symtab[best].st_value
2786                        && *(mod->strtab + mod->symtab[i].st_name) != '\0'
2787                        && !is_arm_mapping_symbol(mod->strtab + mod->symtab[i].st_name))
2788                            best = i;

Current mainline is OK.

<someone broke netconsole too, I think...>
