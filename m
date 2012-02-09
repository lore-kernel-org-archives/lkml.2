Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab2BIQ0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 11:26:10 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:43837 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751124Ab2BIQ0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 11:26:08 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: RWk8Y80VM1lo5mUUSPTI0x9AbFEE1GlhypbAJpAN0IFTSCc
 GRFCUwZGTENQeskqvjXjEWL0y9gxs2nYDIaRQ7ZH0VIDvgVlKlzHFvEy5Jmp
 zShHHfWmAXKBq2og0VByS220RD7Hzr9I686I5EVO4FBbcsQw69K7bshwsRad
 pyguZiC6HEyLAnLhQEPHO_fNRHR8SbvrpiF.RO2Ih3tK.cfFiBmag5ZaukE4
 mbjluTnSXFrM1v5dN7gqcTN3IE0AN1hVc_8muPSUwhr5ntPk09jEw6zOwIr0
 j93ubjoVnIgkGZkgVpGEnMkNBfy6pfyFodF7J4rvPukjcFVuGeVP8VFczj7i
 1BEKdoomHPEw.C58yksy3zTHTFmg4L0pp35qZ8i.ZLrx5Uik6KMjkGaPN8Js
 TzI.NhxiziDeGst8Z_sD9imZoU6XbszPQXh_0
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 9 Feb 2012 10:26:02 -0600 (CST)
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
In-Reply-To: <20120209155246.GD22552@somewhere.redhat.com>
Message-ID: <alpine.DEB.2.00.1202091024340.32064@router.home>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com> <1327591185.2446.102.camel@twins> <CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com> <20120201170443.GE6731@somewhere.redhat.com> <CAOtvUMc8L1nh2eGJez0x44UkfPCqd+xYQASsKOP76atopZi5mw@mail.gmail.com>
 <20120202162420.GE9071@somewhere.redhat.com> <alpine.DEB.2.00.1202021028120.6221@router.home> <20120209155246.GD22552@somewhere.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Feb 2012, Frederic Weisbecker wrote:

> > The vmstat timer only makes sense when the OS is doing something on the
> > processor. Otherwise if no counters are incremented and the page and slab
> > allocator caches are empty then there is no need to run the vmstat timer.
>
> So this is a typical example of a timer we want to shutdown when the CPU is idle
> but we want to keep it running when we run in adaptive tickless mode (ie: shutdown
> the tick while the CPU is busy).

You can also shut it down when the cpu is busy and not doing any system
calls. If the percpu differentials are all zero (because you just ran the
timer f.e.) and there are no system activities that would change the
counters then there is no point in running the vmstat timer.

