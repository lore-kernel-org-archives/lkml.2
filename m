Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1GLSyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:54:00 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:43920 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751220Ab1GLSx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:53:59 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ZfM7e6QVM1m_kMzyeOiIB_0bNL.ckfTrDP92JURjQwV805E
 6UZFiNeknLvGzPhjOnKHCjM4ph1eeTEcyebLqaHqhuLXTNUH97GARmaKWxkM
 uV9Pb93jYOX3967Wyvsm7D9JhBGp1Q0zD3t6kk8m2SgjCxnXafsuLrHSQSui
 lAvejqSYnYL1d9dHB09JbLTDuym1bKoiRd2L7lr03lLoqR0EFF07XGgYGQyl
 QjWtVqAunbwrNwq8NFyvUSO8YazVSVPiPVIqL8jjUsxzQuuhxcnuVHbgCOAo
 sMFfWA8281Y7ljkJvRehUS2RL2EB9HbJKnUG.ShUVBpNbs7zvMZsdCCLOWvj
 8tYEhdzGUlBEEBfT1bbXelW1g
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 12 Jul 2011 13:53:55 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv7 06/17] slub: Add cmpxchg_double_slab()
In-Reply-To: <4E1C952D.6010902@zytor.com>
Message-ID: <alpine.DEB.2.00.1107121352330.6311@router.home>
References: <20110601172543.437240675@linux.com>  <20110601172615.286693377@linux.com>  <1310414100.2860.6.camel@edumazet-laptop>  <alpine.DEB.2.00.1107121057550.2931@router.home> <1310486781.2871.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <alpine.DEB.2.00.1107121146080.3937@router.home> <4E1C952D.6010902@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-921558174-1310496837=:6311"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-921558174-1310496837=:6311
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 12 Jul 2011, H. Peter Anvin wrote:

> On 07/12/2011 09:47 AM, Christoph Lameter wrote:
> > On Tue, 12 Jul 2011, Eric Dumazet wrote:
> >
> >> Le mardi 12 juillet 2011 =C3=A0 10:59 -0500, Christoph Lameter a =C3=
=A9crit :
> >>
> >>> We do not need to have _count included. This is just there because th=
e
> >>> field is in the way on 64 bit and we can only do 2x 64 bit cmpxchges.=
  On
> >>> 32 bi we can drop _count from "counters".
> >>
> >> OK, thanks for clarification.
> >
> > Still I'd like to get some ideas on how to make the whole thing much
> > cleaner. Isnt there some way to convert a struct to an unsigned long
> > without going through a union? And a way to convert a struct + 32 bit
> > atomic_t into a 64 bit unsigned long? Would simplify things significant=
ly.
>
> If you know it is in memory you can cast ("pun") the pointer.

Well I use a page struct on the stack now to put the information in memory
and then use the union to cast it.

> If it's not in memory that can be inefficient, though.

Yeah. Isnt there some C trick to cast a word size struct to unsigned long?

---1463811839-921558174-1310496837=:6311--
