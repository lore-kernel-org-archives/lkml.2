Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab2EPOqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:46:12 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57705 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752567Ab2EPOqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:46:07 -0400
Message-ID: <1337179563.2985.80.camel@dabdike.int.hansenpartnership.com>
Subject: Re: Build regressions/improvements in v3.4-rc7
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <jmorris@namei.org>
Date: Wed, 16 May 2012 15:46:03 +0100
In-Reply-To: <CAMuHMdUtL4_mv-e-EQAZmNcb9dAT=PXB59i7Vuj2vf8NnaBFzQ@mail.gmail.com>
References: <1337157034-22773-1-git-send-email-geert@linux-m68k.org>
	 <CAMuHMdUtL4_mv-e-EQAZmNcb9dAT=PXB59i7Vuj2vf8NnaBFzQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 10:47 +0200, Geert Uytterhoeven wrote:
> On Wed, May 16, 2012 at 10:30 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>   + lib/mpi/generic_mpih-mul1.c: error: inconsistent operand
> constraints in an 'asm':  => 50:70
>   + lib/mpi/generic_mpih-mul2.c: error: inconsistent operand
> constraints in an 'asm':  => 49:70
>   + lib/mpi/generic_mpih-mul3.c: error: inconsistent operand
> constraints in an 'asm':  => 49:70
>   + lib/mpi/mpih-div.c: error: inconsistent operand constraints in an
> 'asm':  => 135:122, 135:371, 97:122, 106:121, 106:370, 97:371
> 
> parisc-allmodconfig

Wow, lib/mpi/ is a complete horror: it's full of hand crafted asm code.
The error in this case appears to be that umul_ppm() is implemented as
an xmpyu instruction.  That's a floating point instruction.  We
deliberately compile the kernel with floating point disabled because we
don't want to save and restore the floating point register file on each
context switch, hence the operand constraints are unsatisfiable.

It appears to be completely untested on non-x86 and to have been
imported via the security tree ... what are we supposed to do with this?
I thought the general principle was that asm code was really supposed to
be confined to the arch directories?

James


