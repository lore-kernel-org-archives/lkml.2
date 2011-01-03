Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab1ACJCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 04:02:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:39267 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab1ACJC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 04:02:26 -0500
Subject: Re: Kernel oops - help interpreting partial trace info
From: Peter Zijlstra <peterz@infradead.org>
To: Samson Yeung <samson@editshare.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTim6Ac51K+31M9miS1apq7=B2a+pPXZuUy+V0UkB@mail.gmail.com>
References: <AANLkTim6Ac51K+31M9miS1apq7=B2a+pPXZuUy+V0UkB@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 Jan 2011 10:02:49 +0100
Message-ID: <1294045369.2016.35.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-30 at 08:35 -0800, Samson Yeung wrote:
> Code: 00 44 8b 15 23 76 68 00 45 85 d2 74 32 48 8b 50 08 8b 5a 18 48
> 8b 90 90 06 00 00 48 8b 4a 50 48 85 c9 74 1b 48 63 db 48 8b 51 20 <48>
> 03 14 dd 00 fb 74 81 4c 01 32 48 8b 49 58 48 85 c9 75 e8 48
> All code
> ========
>    0:   00 44 8b 15             add    %al,0x15(%rbx,%rcx,4)
>    4:   23 76 68                and    0x68(%rsi),%esi
>    7:   00 45 85                add    %al,-0x7b(%rbp)
>    a:   d2                      (bad)
> ...
> 
> Should (bad) ever be output by decodecode? 

Don't think so, my guess is the decoder started at a non ins boundary
and got confused. "85 d2" is "test %edx, %edx" and is something that
occurs quite frequently in the code. The following 74 is "je", which
makes sense after a "test".

"8b 15 xx xx xx xx" is "movl xx,%edx"

That however does leave us with a 45 unexplained, that's usually part of
a mem argument, its x(%ebp) like stuff.

Dunno really..
