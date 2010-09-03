Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab0ICGog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 02:44:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab0ICGof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 02:44:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4C804F3A.8020001@snapgear.com>
References: <4C804F3A.8020001@snapgear.com> <19747.1283422807@redhat.com> <20100902102203.19806.39028.stgit@warthog.procyon.org.uk>
To: Greg Ungerer <gerg@snapgear.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Fix M68K irqflags
Date: Fri, 03 Sep 2010 07:44:19 +0100
Message-ID: <7077.1283496259@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Ungerer <gerg@snapgear.com> wrote:

> >  -	DEFINE(THREAD_SIZE, THREAD_SIZE);
> > -
> 
> This breaks final link due to missing THREAD_SIZE definition in head.S:
> 
>   LD      vmlinux
> arch/m68knommu/platform/coldfire/head.o: In function `_clear_bss':
> (.head.text+0xa4): undefined reference to `THREAD_SIZE'
> 
> 
> Without that asm-offsets.c change it works on my ColdFire boards.
> I am happy with it:

With that, I get a duplicate reference to THREAD_SIZE.  head.S should include
asm/thread_info.h rather than THREAD_SIZE being redefined in asm-offsets.

  CC      init/do_mounts_rd.o
In file included from /warthog/nfs/linux-2.6-fscache/arch/m68k/include/asm/asm-offsets.h:1,
                 from arch/m68knommu/platform/coldfire/entry.S:36:
include/generated/asm-offsets.h:46:1: warning: "THREAD_SIZE" redefined
In file included from /warthog/nfs/linux-2.6-fscache/arch/m68k/include/asm/thread_info.h:2,
                 from arch/m68knommu/platform/coldfire/entry.S:32:
/warthog/nfs/linux-2.6-fscache/arch/m68k/include/asm/thread_info_no.h:27:1: warning: this is the location of the previous definition

Unfortunately, I don't have a binutils that can handle the funny Coldfire
instructions.  Can you point me at a Coldfire toolchain?

David
