Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab1KVPCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:02:33 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:25651 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752917Ab1KVPCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:02:32 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: sKQYvy4VM1lfjMtR2tp5QRmaVyzuGLHLMH_a_d_gzoP_moG
 59Q64IM_HnrBQ7j290SaC_gu9FEhxKS.5HlyO8Nl6sPyNHyLKd_Wm8j25XgM
 lWiXRqsSXLpKm6PTkYP1.iX8wt7vRzx4HOAIYcbh1WiP1D6y8dzsI170ex4X
 FFz.aYPRUsdkLbKmPOCkIABxhHmbYsdqdmaH89_AjWqMybe97CFNcsAvF65n
 7eHPINJX3a3P6O0bs6zSAs0TuY_l8EDeZUKVKdIuO1NwVLKjNZk1047X5ap_
 HHsyJZnEMnBtbbGzKoYbneTx2kwaXtlfNGQbBzXsG64aZVm_hxY9YRn2qfMT
 ivnpz0rhFs3V2U4qZ.JHEZmpepVs8Z57JBXCz1XC4M2TGRQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 Nov 2011 09:02:27 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Christian Kujau <lists@nerdbynature.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
In-Reply-To: <1321973567.2474.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1111220900330.25785@router.home>
References: <20111121161036.GA1679@x4.trippels.de>   <1321894353.10470.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>   <1321895706.10470.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>   <20111121173556.GA1673@x4.trippels.de>   <1321900743.10470.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
  <20111121185215.GA1673@x4.trippels.de>   <20111121195113.GA1678@x4.trippels.de> <1321907275.13860.12.camel@pasglop>   <alpine.DEB.2.01.1111211617220.8000@trent.utfs.org>   <alpine.DEB.2.00.1111212105330.19606@router.home>   <20111122084513.GA1688@x4.trippels.de>
  <1321954729.2474.4.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <1321955185.2474.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <alpine.DEB.2.00.1111220844400.25785@router.home> <1321973567.2474.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-315387018-1321974150=:25785"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-315387018-1321974150=:25785
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 22 Nov 2011, Eric Dumazet wrote:

> Le mardi 22 novembre 2011 =C3=A0 08:46 -0600, Christoph Lameter a =C3=A9c=
rit :
> > On Tue, 22 Nov 2011, Eric Dumazet wrote:
> >
> > > I trigger a bug in less than 10 secondes, with this running while a
> > > "make -j16 " kernel build is run.
> > >
> > > while :; do slabinfo -v; done
> >
> > Hmm.... Yeah there was limited testing on the debug features. There cou=
ld
> > be something amiss there. Need to review the validation interactions wi=
th
> > the new code.
> >
> >
>
> Hmm... yes, we probably should take a look.

Allright there is an obvious issue if debugging is off since the lockless
paths do not take the page lock in that case but the validation logic
does. Did you run the test with debugging on or off?

Not sure what the solution is but the simplest would be to disable
validation if lockless is active.



---1463811839-315387018-1321974150=:25785--
