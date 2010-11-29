Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab0K2QEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:04:44 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:28854 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754725Ab0K2QEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:04:43 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: FETedUkVM1nlsyqJ9UplgAjlCujDqVTqb9IcS21nDb_Al6U
 ofj9xlbgKLYDLFqo3v07zjVhMYuP8.n2UNKJcQngz7P1GwRxMWs93zSLYkSR
 YruM4m87eNVmP_Y7PtzPJSIG0_Gf2Zdum8uMXrHBfLCmPhcl7ZJ5MEZ9umdb
 ggS1PdPffZGditEIIJ78hJKkIbyv7lzPxOTGqEzLUvzEH1xFiO19zJEb3IOy
 ZF1FZ1zUJ95gS5_sfAtL5MJWl3RiAI2CGj8mueT8-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 29 Nov 2010 10:04:40 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thisops uV2 06/10] vmstat: Use this_cpu_inc_return for vm
 statistics
In-Reply-To: <AANLkTi=6wVzEQwuMZTgL8WWhFMnNoYgsYv9hZk1jB4jw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1011291004120.3923@router.home>
References: <20101126210937.383047168@linux.com> <20101126210952.446650993@linux.com> <AANLkTi=6wVzEQwuMZTgL8WWhFMnNoYgsYv9hZk1jB4jw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-409510245-1291046681=:3923"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-409510245-1291046681=:3923
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 27 Nov 2010, Pekka Enberg wrote:

> > @@ -167,8 +167,8 @@ static void refresh_zone_stat_thresholds
> > =A0void __mod_zone_page_state(struct zone *zone, enum zone_stat_item it=
em,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int delt=
a)
> > =A0{
> > - =A0 =A0 =A0 struct per_cpu_pageset * __percpu pcp =3D zone->pageset;
> > - =A0 =A0 =A0 s8 * __percpu p =3D pcp->vm_stat_diff + item;
> > + =A0 =A0 =A0 struct per_cpu_pageset __percpu *pcp =3D zone->pageset;
> > + =A0 =A0 =A0 s8 __percpu *p =3D pcp->vm_stat_diff + item;
> > =A0 =A0 =A0 =A0long x;
> > =A0 =A0 =A0 =A0long t;
> >
>
> Shouldn't this hunk be in the other vmstat patch?

Right. I did not run sparse with the first patch alone.

---1463811839-409510245-1291046681=:3923--
