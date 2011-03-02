Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab1CBWYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:24:16 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:32842 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987Ab1CBWYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:24:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HQm38lbxSc7OC5wBOKNqMOOXXAlp2c5qkEAWtMnWCUSV0a1teEhDbkceZBC+PCcd2R
         3P0YvYcBh/PqdWuedweGCRfYyWVA7vTTjbw6WqJCLRHSoZ7gY2kmMQCFaZ7lFt/JcuoL
         eoOB2EHogZI3Hs2hYKeZHx5nn3gt9u2tcNBaM=
Date: Wed, 2 Mar 2011 16:24:03 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Stefan Bader <stefan.bader@canonical.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.32.30
Message-ID: <20110302222403.GA7159@BohrerMBP.rgmadvisors.com>
References: <20110302145828.GA4999@kroah.com>
 <4D6E7548.807@canonical.com>
 <20110302204202.GB19022@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302204202.GB19022@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 03:42:02PM -0500, Greg KH wrote:
> On Wed, Mar 02, 2011 at 05:50:16PM +0100, Stefan Bader wrote:
> > > FUJITA Tomonori (1):
> > >       swiotlb: fix wrong panic
> > >
> > 
> > This one breaks compilation of 64bit for me as swiotlb_tbl_unmap_single() does
> > not exist. It does not look like it is a simple single patch that would get it
> > back to 2.6.32.
> 
> I don't understand.  Is this patch somehow broken?  Is there an
> additional patch I need to apply to fix the build issue?  I need more
> information here.

Same problem here, not sure what the fix is.  With this patch applied
on 64-bit I get:


$ make lib/swiotlb.o
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/docproc
  HOSTCC  scripts/basic/hash
  CC      kernel/bounds.s
  GEN     include/linux/bounds.h
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/asm/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  HOSTCC  scripts/genksyms/genksyms.o
  HOSTCC  scripts/genksyms/lex.o
  HOSTCC  scripts/genksyms/parse.o
  HOSTLD  scripts/genksyms/genksyms
  CC      scripts/mod/empty.o
  HOSTCC  scripts/mod/mk_elfconfig
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/modpost.o
  HOSTCC  scripts/mod/sumversion.o
  HOSTLD  scripts/mod/modpost
  HOSTCC  scripts/kallsyms
  HOSTCC  scripts/pnmtologo
  HOSTCC  scripts/conmakehash
  HOSTCC  scripts/bin2c
  CC      lib/swiotlb.o
lib/swiotlb.c: In function 'swiotlb_map_page':
lib/swiotlb.c:635: error: implicit declaration of function 'swiotlb_tbl_unmap_single'
make[1]: *** [lib/swiotlb.o] Error 1
make: *** [lib/swiotlb.o] Error 2

--
Shawn
