Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab2GQOgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:36:41 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:20582 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750832Ab2GQOgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:36:39 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: kSX21R4VM1mXeu0fDfxmROQNPFbMhVfxMiyj93u3zE2Vyig
 HxQSWwbmxu7O.LzlCv3iAOwGqNnPHjnnp1zUxrkSDcq3OUW_EK_Kfc0Ijxn9
 WOcJAbiRclXlfjdMR7tR9ZP6MsKvM0T7Pg88jfwKJomJrWzIohLdvmSxr2u2
 OPMWxNmTvcx7n3eUvqVamDF2vRoHOwLpdsZsWQ6gRmedqd1IBVf5mxNJOogV
 McCrrnCbgaVu2.ej.O6AF1shFc4WM2RhmuikD8.W8p70w3eT9d8jqnEHInvJ
 RyYnHG7Elh7CN9VY9FIzsiPUu.vrUs6kYI0Jj3Yydnnj7ZhG4c0eY4nfXsSR
 8X34UNkkWJaz3aBtdciW8qkcl5Rke86ZtvpTAWNpY7iee0VXPIm0NeCP45R5
 O
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 17 Jul 2012 09:36:35 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Shuah Khan <shuah.khan@hp.com>, Pekka Enberg <penberg@kernel.org>,
        glommer@parallels.com, js1304@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH TRIVIAL] mm: Fix build warning in kmem_cache_create()
In-Reply-To: <alpine.DEB.2.00.1207161642420.18232@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1207170929290.13599@router.home>
References: <1342221125.17464.8.camel@lorien2> <alpine.DEB.2.00.1207140216040.20297@chino.kir.corp.google.com> <CAOJsxLE3dDd01WaAp5UAHRb0AiXn_s43M=Gg4TgXzRji_HffEQ@mail.gmail.com> <1342407840.3190.5.camel@lorien2> <alpine.DEB.2.00.1207160257420.11472@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1207160915470.28952@router.home> <alpine.DEB.2.00.1207161253240.29012@chino.kir.corp.google.com> <alpine.DEB.2.00.1207161506390.32319@router.home> <alpine.DEB.2.00.1207161642420.18232@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, David Rientjes wrote:

> > The kernel cannot check everything and will blow up in unexpected ways if
> > someone codes something stupid. There are numerous debugging options that
> > need to be switched on to get better debugging information to investigate
> > deper. Adding special code to replicate these checks is bad.
> >
>
> Disagree, CONFIG_SLAB does not blow up for a NULL name string and just
> corrupts userspace.

Ohh.. So far we only had science fiction. Now kernel fiction.... If you
could corrupt userspace using sysfs with a NULL string then you'd first
need to fix sysfs support.

And if you really want to be totally safe then I guess you need to audit
the kernel and make sure that every core kernel function that takes a
string argument does check for it to be NULL just in case.
