Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1AJQMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:12:17 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:43150 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751292Ab1AJQMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:12:15 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ur2.zFEVM1mEcuNvtqf8qUsmzhk69y0hD165.BakLixqysE
 zuH803IIAFNZTNIkkOVsKMukLM8DCRAqTWkbG.9ByFyxFdhHeQsh1Qn5Ktm4
 4DnVNeNfkpw1fSB23vkw6BL4SVMGg_bulplIKoSd_oxiOlYbevJnAFtdAGOa
 H31N6DYfD1GZ_UXhpaOGUKsW121s7DNv8MxShgiloQrtWXUbsrRa6luVEn7k
 ZxKjO2M4jMXScmLrb38B2nBtH2xrphPdbFsNmknDUhxirSurPYwDjkeyDvTn
 QUBZRQiDetLBHaA4kiUX0ZeHpwp5yUiUGdKK7Rx01HIDx5gDI
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 10 Jan 2011 10:12:09 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slub: Fix sysfs circular locking dependency
In-Reply-To: <AANLkTikf-qO-NkysOsgRvH08ju-NkvrqwdfJ=pFjP6WA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1101101011250.12243@router.home>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1101041939030.27551@chino.kir.corp.google.com> <alpine.DEB.2.00.1101050943120.13032@router.home> <alpine.DEB.2.00.1101051108520.14761@router.home>
 <AANLkTinft80dXqE-U=YDB23d9=BgXLCxJzgiA_gF4cVL@mail.gmail.com> <AANLkTinCZzJWYGnxXq_Nwv7QSkEV4Tg-te-1y0PCeRRY@mail.gmail.com> <AANLkTinQMahgVrWLxR0J6Zbh-_SPjxVJ-wuZt8B5TNjc@mail.gmail.com> <alpine.DEB.2.00.1101060019140.25879@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1101061107500.8655@router.home> <20110107091106.aaa07abe.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1101070922100.3014@router.home> <alpine.DEB.2.00.1101071227160.31653@chino.kir.corp.google.com>
 <AANLkTikf-qO-NkysOsgRvH08ju-NkvrqwdfJ=pFjP6WA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1153692036-1294675931=:12243"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-1153692036-1294675931=:12243
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 8 Jan 2011, Pekka Enberg wrote:

> On Fri, Jan 7, 2011 at 10:34 PM, David Rientjes <rientjes@google.com> wro=
te:
> > =A0[ Should probably be seperated out into two patches, one for the
> > =A0 memory hotplug locking addition and one for the slub fix, both
> > =A0 should be pushed during this merge window. =A0If so, a comment
> > =A0 describing the new semantics of lock_memory_hotplug() to protect
> > =A0 data structures that may be modified in hotplug notifier
> > =A0 callbacks would be appreciated. ]
>
> Agreed.

Kame-san: Could you do the hotplug piece and the description of the use
of the memory hotplug locks to protect extensions of data structures for
new nodes?

---1463811839-1153692036-1294675931=:12243--
