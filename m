Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab2EQA1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 20:27:55 -0400
Received: from blu0-omc4-s8.blu0.hotmail.com ([65.55.111.147]:38874 "EHLO
	blu0-omc4-s8.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335Ab2EQA1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 20:27:53 -0400
X-Originating-IP: [64.229.85.15]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU0-SMTP3215D3E80BA82F3C6A654197190@phx.gbl>
From: John David Anglin <dave.anglin@bell.net>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <1337179563.2985.80.camel@dabdike.int.hansenpartnership.com>
Subject: Re: Build regressions/improvements in v3.4-rc7
References: <1337157034-22773-1-git-send-email-geert@linux-m68k.org> <CAMuHMdUtL4_mv-e-EQAZmNcb9dAT=PXB59i7Vuj2vf8NnaBFzQ@mail.gmail.com> <1337179563.2985.80.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (Apple Message framework v936)
Date: Wed, 16 May 2012 20:27:35 -0400
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <jmorris@namei.org>
X-Mailer: Apple Mail (2.936)
X-OriginalArrivalTime: 17 May 2012 00:27:51.0969 (UTC) FILETIME=[E5257910:01CD33C3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-May-12, at 10:46 AM, James Bottomley wrote:

> Wow, lib/mpi/ is a complete horror: it's full of hand crafted asm  
> code.
> The error in this case appears to be that umul_ppm() is implemented as
> an xmpyu instruction.  That's a floating point instruction.  We
> deliberately compile the kernel with floating point disabled because  
> we
> don't want to save and restore the floating point register file on  
> each
> context switch, hence the operand constraints are unsatisfiable.

I haven't tried this but I think the parisc implementation of umul_ppmm
can be deleted.  There is a generic version in the file.

Dave
--
John David Anglin	dave.anglin@bell.net



