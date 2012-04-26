Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab2DZSUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:20:16 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:42414 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758672Ab2DZSUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:20:15 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: cpDcYX4VM1lZED5hfns_0IK1zU3CPr7fYlEkqAcjmR1Gyea
 qYF9MO9q.X8.e1apY7IfUrSGMMyZoEU9edlaNavBI2JnmwtTjBqr6D6M6Pg1
 nQKjKRhMgkFGVYHGeiShlr12QQxc1ouTRamLejgngh1U_Vwd9OEJ6A5dfxM6
 61Z2hslrZAPeJmdBFsabOMjuoqv0S2EiTt6nRrR3jPf8pdn3J_CBEKdDpBgO
 UYpbHjCpXN.ORiuh7ALP_OKhH5SWAP6b3QBGzMLa2zZQZm2VC1y1EkUi5WDN
 SNHv375kjKp49PFZpPKpTwP.fMvKL_6oWGLxGeqBmwJPC.oMToF7.E4shji7
 wzmQ7URSZTZUgs4cb.jeRs7FltVssaDYjIJ.ym6iNWIoyGhpDhjtRsEItEdT
 a
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 26 Apr 2012 13:20:09 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: Richard Davies <richard@arachsys.com>,
        Satoru Moriya <satoru.moriya@hds.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC][PATCH] avoid swapping out with swappiness==0
In-Reply-To: <4F996BA6.9010900@gmail.com>
Message-ID: <alpine.DEB.2.00.1204261318330.16059@router.home>
References: <20120424082019.GA18395@alpha.arachsys.com> <alpine.DEB.2.00.1204260948520.16059@router.home> <4F996BA6.9010900@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2012, KOSAKI Motohiro wrote:

> (4/26/12 10:50 AM), Christoph Lameter wrote:
> > On Tue, 24 Apr 2012, Richard Davies wrote:
> >
> > > I strongly believe that Linux should have a way to turn off swapping
> > > unless
> > > absolutely necessary. This means that users like us can run with swap
> > > present for emergency use, rather than having to disable it because of the
> > > side effects.
> >
> > Agree. And this ooperation mode should be the default behavior given that
> > swapping is a very slow and tedious process these days.
>
> Even though current patch is not optimal, I don't disagree this opinion. Can
> you please explain your use case? Why don't you use swapoff?

Because I do not want to have systems go OOM. In an emergency lets use
swap (and maybe generate some sort of alert if that happens).

> Off topic: I hope linux is going to aim good swap clustered io in future.
> Especially
> when using THP, 4k size io is not really good.

Swap to regular disks is going to be an ever greater problem since
the access speed of rotational media has not changed much whereas the
processing performance of the cpu has increased significantly. There is an
ever increasing gap in speed.


