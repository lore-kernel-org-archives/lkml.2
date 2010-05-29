Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0E2NdZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 09:33:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57499 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0E2NdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 09:33:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=AC5Ie6M+KT2okoYjuVdmNCgNdbt42y0FAocz96+T3hLM/YGWbhQQpd91atrSkx+dJx
         GWCaSrr688GllgTu8m7kcMrZf05osfg5MCo/pdbCqw2nGaGp5qjvH58m46OHZ046DmFj
         PQMd1EK4gxjenoIz+h8PwWC3EwwotCc5m9mRQ=
MIME-Version: 1.0
In-Reply-To: <20100529124735.GB25092@liondog.tnic>
References: <1275095966-18382-1-git-send-email-xiaosuo@gmail.com> 
	<20100529124735.GB25092@liondog.tnic>
From: Changli Gao <xiaosuo@gmail.com>
Date: Sat, 29 May 2010 21:33:02 +0800
Message-ID: <AANLkTinwjNpAg6y3n1ZzAtPIv-sJE_P7WjbzzrRRCBVD@mail.gmail.com>
Subject: Re: [PATCH 2/2] fs: optimize mpage_bio_submit()
To: Borislav Petkov <bp@alien8.de>, Changli Gao <xiaosuo@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 8:47 PM, Borislav Petkov <bp@alien8.de> wrote:
>
> ok, can you sincerely tell me that your change makes the code more
> readable? And have you checked to see what the compiler actually
> "optimizes"?
>
> original code:
>
>        movq    $mpage_end_io_read, %rdx        #, tmp65
>        movq    $mpage_end_io_write, %rax       #, tmp64
>        cmpl    $1, %edi        #, rw
>        cmovne  %rdx, %rax      # tmp65,, tmp64
>        movq    %rax, 80(%rsi)  # tmp64, <variable>.bi_end_io
>        .loc 1 91 0
>        call    submit_bio      #
>
> your change:
>
>        movq    $mpage_end_io_read, %rdx        #, tmp63
>        movq    $mpage_end_io_write, %rax       #, iftmp.561
>        cmpl    $1, %edi        #, rw
>        cmovne  %rdx, %rax      # tmp63,, iftmp.561
>        movq    %rax, 80(%rsi)  # iftmp.561, <variable>.bi_end_io
>        .loc 1 90 0
>        call    submit_bio      #
>
> so that change does nothing except obfuscating the source a bit more so
> that you get more headaches whenever you look at it.
>

Oh, I didn't check the asm code. Compiler is smarter than I thought.
Thanks for your explaining.


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
