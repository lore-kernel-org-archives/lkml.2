Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab0KZR1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:27:06 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:45306 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751507Ab0KZR1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:27:05 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: QsBlEDsVM1npInlUiQu0GVnjpgcmIzWi100rHv6xAnmbBnk
 Wm0gf9lNYLyKwlKXZ.Y.dCY1etQMMNdAmC3.2oNqHLow3Ar2y977Ofu6UJRs
 SQh96iOI6uRGbMIrYrMvUg4b7ZwGa4Fs8FLghj9Euzck4c4txGid9FYO7Vvm
 R2XacaTNVhDpfXan1jnM3kLfSSxJq8Hff1buIVqk43qPBUUdhqu8Rwjjfm_K
 .scJ03EG9skdD3P17Is2JfluroQ30Lbs65rMy2K4-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 26 Nov 2010 11:27:00 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
Subject: Re: [PATCH] printk: use this_cpu_{read|write} api on
 printk_pending
In-Reply-To: <1290792051.2855.265.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1011261125270.13524@router.home>
References: <20101126120235.406766476@de.ibm.com>  <tip-61ab25447ad6334a74e32f60efb135a3467223f8@git.kernel.org>  <1290788536.2855.237.camel@edumazet-laptop>  <alpine.DEB.2.00.1011261038360.13524@router.home>  <1290790791.2855.259.camel@edumazet-laptop> 
 <alpine.DEB.2.00.1011261109500.13524@router.home> <1290792051.2855.265.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-727231372-1290792422=:13524"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-727231372-1290792422=:13524
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 26 Nov 2010, Eric Dumazet wrote:

> Le vendredi 26 novembre 2010 =C3=A0 11:11 -0600, Christoph Lameter a =C3=
=A9crit :
>
> > I thought sanity tests do not apply for performance testing scenarios?
> >
>
> CONFIG_DEBUG_PREEMPT

You really enable that option for performance testing?

> > smp_processor_id() is usually a simple per cpu data access and very fas=
t.
> >
>
> Sure, but when its already in a register, its better to use the
> register ;)

Well that increases register pressure in the caller. There may be no need
to handle the current processor number in the caller.


---1463811839-727231372-1290792422=:13524--
