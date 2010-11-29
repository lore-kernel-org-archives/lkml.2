Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab0K2QDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:03:31 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:45200 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754181Ab0K2QDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:03:30 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: JlVbJsQVM1mJ8lWM2x1AdHqhZUEEb9.uKYGSsGSgDCugBvM
 OZzOGtxaa6Vng70noObHpn0BjjhN0h1ZpkMePRdRVjQbiq0u.w4dtSa5CAVK
 i1GSfTxhJ0z_wPOi.HyoId1GRGCBnvuqZKsPkTHiUq8.Wa2Xp0I8l2MO51Eq
 U4djUXBXauwTwg_bxX7Iiw6JNJY78jefTRebJ0JkwK9GNxzu877Rx0Fd_qgM
 qoq.OMjmFhyGhxgIO0Rc4avnZUpRCabwi5DTi.03_n67plY0RRdg-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 29 Nov 2010 10:03:26 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thisops uV2 04/10] x86: Support for
 this_cpu_add,sub,dec,inc_return
In-Reply-To: <AANLkTinQ9_WdZAfyTLKhvP47tRnYABjEtTOVByhn1QZo@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1011291002390.3923@router.home>
References: <20101126210937.383047168@linux.com> <20101126210951.303044608@linux.com> <AANLkTinQ9_WdZAfyTLKhvP47tRnYABjEtTOVByhn1QZo@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-220736241-1291046608=:3923"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-220736241-1291046608=:3923
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 27 Nov 2010, Pekka Enberg wrote:

> On Fri, Nov 26, 2010 at 11:09 PM, Christoph Lameter <cl@linux.com> wrote:
> > @@ -300,6 +339,14 @@ do { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 \
> > =A0#define irqsafe_cpu_xor_2(pcp, val) =A0 =A0percpu_to_op("xor", (pcp)=
, val)
> > =A0#define irqsafe_cpu_xor_4(pcp, val) =A0 =A0percpu_to_op("xor", (pcp)=
, val)
> >
> > +#ifndef CONFIG_M386
>
> Use CONFIG_X86_32 here?

This is a section specifically for non 386. 386 does not support certain
atomic operations.

---1463811839-220736241-1291046608=:3923--
