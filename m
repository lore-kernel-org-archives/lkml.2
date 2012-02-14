Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761316Ab2BNWId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 17:08:33 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:32721 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761264Ab2BNWIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 17:08:30 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: gf.Xo_oVM1kdYNG2BDZ.VHc_QHHBzrM6YDU2HYI1kKPQ.4H
 KC4310jM6yYTdwGl58gFiz_MATkDpxdOCrIP2ux7.psxgUgNRuVTIvub.z74
 NZBzx6oU7_g0eEM4n.cI1VMuGfyC6BVn44FzulVhGifr74WSi81JpFcPPJqi
 XfjzSeE9j6QAkmeO_tucinIdCtCqCscTJA293mIwJIiGyRDn_gP83NnE04.G
 asCQzcUv3yv7OSudnSlzWnmG19tzyZ89VWUeIKqHbSj8NL2t3N0KyYGfiCiS
 _RInZaQSF9eAJf8tMaUR5oN24YDN.KPa.0slPxlAPzxZNs614JPb6QlNl294
 vI3_nlnCFaM94XtcD8SPBcQhUlYkP4OHsPryecY3N_ygvqCf84CZ_SSE4EBz
 16ApV9EbVG3NSSqxk0p6Dmq1ITK_hmKMKPi64
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 14 Feb 2012 16:08:26 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Xi Wang <xi.wang@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: Uninline kcalloc
In-Reply-To: <59F64CB9-832E-4F7C-8A6C-E2CD18563795@gmail.com>
Message-ID: <alpine.DEB.2.00.1202141605240.32407@router.home>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com> <4F33CEAE.60400@gmail.com> <alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net> <20120209150652.5b1d19dc.akpm@linux-foundation.org>
 <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com> <alpine.DEB.2.00.1202130958470.23562@router.home> <20120213194446.GD26353@mwanda> <alpine.DEB.2.00.1202131424020.25908@router.home> <20120214072017.GF26353@mwanda> <alpine.DEB.2.00.1202140858080.20013@router.home>
 <8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com> <alpine.DEB.2.00.1202141032410.22250@router.home> <ADCFB33D-7284-4D3F-8280-545AF82EC744@gmail.com> <alpine.DEB.2.00.1202141329360.24883@router.home> <20120214124518.f42bc03e.akpm@linux-foundation.org>
 <CAOJsxLEdSr983jQ00_YuSWr3=pfmQHbebX87347K6v1HoCiyLw@mail.gmail.com> <alpine.DEB.2.00.1202141503470.29019@router.home> <59F64CB9-832E-4F7C-8A6C-E2CD18563795@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012, Xi Wang wrote:

> On Feb 14, 2012, at 4:09 PM, Christoph Lameter wrote:
> > IMHO Having a function to deal with the overflow of a multiplication and
> > then do an allocation based on the result is a conflation of two different
> > things that need to be separate. kcalloc only exists because there is
> > an ancient user space function that somehow got a second parameter instead
> > of just using the same as malloc().
>
> I don't understand why these kcalloc patches have anything to do
> with kmalloc(SAFE_ARRAY_SIZE(...), ...) you proposed.

Not sure why you are so hung up on SAFE_ARRAY_SIZE. It was an idea to
discuss. Certainly having an inline function seems to be better.

> It also doesn't make much sense to force the caller to check the
> result of SAFE_ARRAY_SIZE() or calculate_array_size() before passing
> it to kmalloc().  This is too verbose.

kcalloc is still there. Certainly useful for legacy purposes. But I'd feel
better if I had fine grained control over the size of my allocation rather
than rely on the slab allocators to check up on my multiplication.

With these patches both is possible. And if you want the check of an
allocation that is not zeroed then you can do so because you have a
function that will perform the size check for you without calling into the
slab allocator.

