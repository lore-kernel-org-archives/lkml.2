Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab1GUP1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 11:27:43 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:24186 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752035Ab1GUP1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 11:27:42 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: e6Yc9iMVM1kAyPqdMAAwoZXVsvK5Rn9_OIVrc6L3mE73C3G
 jObNJBMgYRWB_dx4UOltVZIhDBSd1YB.8K9GFxODRckjomX5OA7YbqksmC_p
 mSGCAXLuaJyFZL365izEeD6W1.np27uZQDFeaa7.0XYstRnhyORQUKGI1Z5q
 zJzGocn3tERwgBCP6MDFOyX21Wb4UA9NxzNEefPW2qNjviLNM4dMhaYXKVqV
 7PXzPy5DYovu3q2O5wJRhPuOKCyNAbI8hOmhYcqZFVfO96lcg6jwPOwOXSS1
 MmbdwfshLx18SaIeuFzphVqLvOf_QJuCkNEAUfQdPD51XYwc_O0tkgR.3BzU
 .rEzZlCr5hlBtMqRFcyUqhr2D
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 21 Jul 2011 10:27:37 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Mel Gorman <mgorman@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
In-Reply-To: <1311237839.2422.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1107211025530.3995@router.home>
References: <20110720121612.28888.38970.stgit@localhost6>  <alpine.DEB.2.00.1107201611010.3528@tiger> <20110720134342.GK5349@suse.de>  <alpine.DEB.2.00.1107200854390.32737@router.home>  <1311170893.2338.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> 
 <alpine.DEB.2.00.1107200950270.1472@router.home> <1311237839.2422.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1751958307-1311262060=:3995"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-1751958307-1311262060=:3995
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 21 Jul 2011, Eric Dumazet wrote:

> Le mercredi 20 juillet 2011 =C3=A0 09:52 -0500, Christoph Lameter a =C3=
=A9crit :
>
> > We should be making it a per cpu pointer like slub then. I looked at wh=
at
> > it would take to do so a couple of month ago but it was quite invasive.
> >
>
> I took a look at this too, but using percpu data would consume more
> memory, because percpu allocator allocates memory blobs for all possible
> cpus, while current code handles online/offline cpu nicely.

The number of possible cpus is determined on bootup. If the BIOS provides
the right information about which cpus are present and if there is no
hotswapping of cpus possible then only per cpu areas for the actual
functioning cpus are allocated. Certainly no desktop bios will indicate
that 4096 cpus are possible.



---1463811839-1751958307-1311262060=:3995--
