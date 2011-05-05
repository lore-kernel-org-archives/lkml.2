Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1EEUJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 16:09:09 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:38502 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752563Ab1EEUJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 16:09:08 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: eq0T9XIVM1nAdQcR5tmxVHPkVc8goMDV0ItjYwjymO6jN.j
 fwX9LtNpzlhI9F6Yz1DD4m63gYwdKgsv3ULi1.O06s.uEJfXNvbDFZ.Gth09
 vjAqOMmPwN4QmubhirblEv6GLkrWXSd9R2iTzUIrqqcoz9OfDAW7FoUC_aWs
 DvEqi3tL7O2BMyD9bXVTE0dKuU6h7sVmI0k.SGSuDZkfKqUuW2l5fx13BWJH
 kMkBxRxZKCZWf4yhnV63bX08PGtYnX55ErOMM4RTv1VE.GVnFIa_J5p0vvZt
 QYrvAEJOeby2ZViiVyihuq0W9GMyF8tK66Bl9UMPmiVxlm3gFEolHsBq_mDU
 18xp2Gx0J4Ek.MoMCsBC.q3Oj
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 5 May 2011 15:09:04 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: werner <w.landgraf@ru.ru>
cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <web-518794926@zbackend1.aha.ru>
Message-ID: <alpine.DEB.2.00.1105051504250.8529@router.home>
References: <BANLkTimdL_tAONUWxZ4sQn1AiPDdbdYqpw@mail.gmail.com> <BANLkTinLn-59oisLrvwyCvyUuNyDKVHP0g@mail.gmail.com> <alpine.DEB.2.00.1105041341550.5495@router.home> <BANLkTikEgDGt+KrBsZcinKVom5E63Ma6gg@mail.gmail.com> <alpine.DEB.2.00.1105041421280.5495@router.home>
 <BANLkTi=efcVkGb+DReZ+i1p5j4QXJYjKjQ@mail.gmail.com> <alpine.DEB.2.00.1105041454190.5495@router.home> <BANLkTik7AHGr7+BG8nE16j-ayctD0LOH=w@mail.gmail.com> <BANLkTimvxOMuPJ0W0npo5i3gwFqdRw74Pw@mail.gmail.com> <alpine.LFD.2.02.1105042325500.3005@ionos>
 <20110505095421.GD30950@htj.dyndns.org> <web-518794926@zbackend1.aha.ru>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, werner wrote:

>    As the 1st step, for can be compiled generic kernels at all, the kernel
> should have (and has) the ability, to discover at run-time , what hardware the
> individual user has, and to use only the corresponding kernel subroutines.
> F.ex. if subroutines for ELAN or MOORESTON were compiled also, then the kernel
> ignore them simply, if on run-time it discovers that the user has a 486
> computer.

Yes indeed the kernel can detect that. And the code has fallback for
the case that the processor flags indicate that cmpxchg16b is not supported.

However, in this case the kernel configuration at build time was set in
such a way (!CMPXCHG64 support but CMPXCHG_LOCAL) that generic fallback
functions were used at compile time instead of the x86 assembly that can
do the fallback with run time detection. Thus the code to do the fallback
was not compiled in. Frankly, I was not aware that such a case existed
where one could disable cmpxchg64 in this way and was expecting that the
runtime detection would always be compiled in for the CMPXCHG_LOCAL case.
