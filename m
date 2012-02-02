Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab2BBQaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 11:30:06 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:27380 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751278Ab2BBQaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 11:30:04 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: E_5XOq4VM1nxrbAOS5U6JAGcSDSe5ioBwRQWQypf2BAQlGm
 RWBRBwcN4UfzPUd78qGZKqlgZy7Tb9ajtIrVv3fNNbCGw14.JDoNtHBJl2u.
 Hcfjer6Zp8D0CTSE2TsJNIx3LxmdVXBr4iPVgFcBcwazert7Qfxayy1ZSW4i
 sLsCSx97bRZh_mtZ6S4xcya5QFwqi5TjBuiEXInb0u734XhPihkTRoKpOpFl
 wfSvQtQhtPN1xg1BFDL3.SxnfhD1OOmJ8R_6TWXWT7KhZtk18c69rLxg_vvu
 5Z0rKZsUM8o3Ru2cF_owxwqDdnALXTgZ_qmlqS1K6ql5aAZ4.pT8tU_.B0vO
 7E_HMxBneuOBy6tumpm8ELzNjuXARYGIcTM97LnVc8N3foeZeRTwB7KWwNrS
 m
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 2 Feb 2012 10:29:57 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
In-Reply-To: <20120202162420.GE9071@somewhere.redhat.com>
Message-ID: <alpine.DEB.2.00.1202021028120.6221@router.home>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com> <1327591185.2446.102.camel@twins> <CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com> <20120201170443.GE6731@somewhere.redhat.com> <CAOtvUMc8L1nh2eGJez0x44UkfPCqd+xYQASsKOP76atopZi5mw@mail.gmail.com>
 <20120202162420.GE9071@somewhere.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-439244359-1328200202=:6221"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-439244359-1328200202=:6221
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 2 Feb 2012, Frederic Weisbecker wrote:

> > Some pinned timers might be able to get special treatment as well - tak=
e for
> > example the vmstat=A0work being schedule every second, what should we d=
o with
> > it for CPU isolation?
>
> Right, I remember I saw these vmstat timers on my way when I tried to get=
 0
> interrupts on a CPU.
>
> I think all these timers need to be carefully reviewed before doing anyth=
ing.
> But we certainly shouldn't adopt the behaviour of migrating timers by def=
ault.
>
> Some timers really needs to stay on the expected CPU. Note that some
> timers may be shutdown by CPU hotplug callbacks. Those wouldn't be migrat=
ed
> in case of CPU offlining. We need to keep them.
>
> > It makes sense to me to have that stop scheduling itself when we have t=
he tick
> > disabled for both idle and a nohz task.

The vmstat timer only makes sense when the OS is doing something on the
processor. Otherwise if no counters are incremented and the page and slab
allocator caches are empty then there is no need to run the vmstat timer.
---1463811839-439244359-1328200202=:6221--
