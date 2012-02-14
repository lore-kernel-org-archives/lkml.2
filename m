Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab2BNVii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:38:38 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:42518 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932104Ab2BNVie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:38:34 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: uQG5FDQVM1k7XgBPV1nqwZ.kT6CS2jVqDZ9ZQ_gbARHTej_
 NxUnqlSfyuiORfijaNkmujwZktGg9wGtwatZlN7vA2fIoxn1Ad3nNWkkLZCT
 MR1PVyYQhKpNU5yzRu1DGAi7mjI4N7QiWkzThEolTBXNIHkfwfEZ2YKuyXtP
 nUPm2cvFGVSXDFiXyeKMO64W9to8RUoWQrCFk0Uuj6hdoo1PFAOwViz6MZnP
 LIGJ9FtFOvKuffSp5gsCKZHlGSH0nZwQ4BzYXQDhWUCwDlJnzFafQhqJukJW
 RHcSq22hIQ3yuz2EYDYtiviz.Z6iMOKn7MYqAHEoi3KT52.qqqvWRxut92lr
 M281OcNQGG_bXvUFYAHBtOxV8tqXfTZbm0QB1T2L52L.3wqa1zDjvJngzChr
 Q
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 14 Feb 2012 15:38:30 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Xi Wang <xi.wang@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: Uninline kcalloc
In-Reply-To: <CAOJsxLEVy9AyoU56n6F066gX28b_EJ1Ue=Qz+FWMgJL43OWPag@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1202141537211.29019@router.home>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com> <4F33CEAE.60400@gmail.com> <alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net> <20120209150652.5b1d19dc.akpm@linux-foundation.org>
 <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com> <alpine.DEB.2.00.1202130958470.23562@router.home> <20120213194446.GD26353@mwanda> <alpine.DEB.2.00.1202131424020.25908@router.home> <20120214072017.GF26353@mwanda> <alpine.DEB.2.00.1202140858080.20013@router.home>
 <8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com> <alpine.DEB.2.00.1202141032410.22250@router.home> <ADCFB33D-7284-4D3F-8280-545AF82EC744@gmail.com> <alpine.DEB.2.00.1202141329360.24883@router.home> <20120214124518.f42bc03e.akpm@linux-foundation.org>
 <CAOJsxLEdSr983jQ00_YuSWr3=pfmQHbebX87347K6v1HoCiyLw@mail.gmail.com> <alpine.DEB.2.00.1202141503470.29019@router.home> <CAOJsxLEVy9AyoU56n6F066gX28b_EJ1Ue=Qz+FWMgJL43OWPag@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012, Pekka Enberg wrote:

> On Tue, 14 Feb 2012, Pekka Enberg wrote:
> >> Me neither. I don't think Christoph's SAFE_ARRAY_SIZE() suggestion
> >> makes much sense, really. It's more verbose, less obvious API, and
> >> doesn't really deal with the overflow case cleanly.
>
> On Tue, Feb 14, 2012 at 11:09 PM, Christoph Lameter <cl@linux.com> wrote:
> > IMHO Having a function to deal with the overflow of a multiplication and
> > then do an allocation based on the result is a conflation of two different
> > things that need to be separate. kcalloc only exists because there is
> > an ancient user space function that somehow got a second parameter instead
> > of just using the same as malloc().
>
> It's an ancient userspace function that everybody knows how to use.
> There really isn't big enough gains from SAFE_ARRAY_SIZE() to justify
> a new API. And it's not as if the macro is an elegant way to solve the
> problem at hand either.

Ok then keep the calloc style API but at least allow the refactoring with
an additional function. That way one is able to check if there is an
overflow in size calculation and can differentiate that condition from an
out of memory situation due to a large contiguous allocation attempt.

