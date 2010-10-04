Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab0JDNHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 09:07:46 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:24939 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755774Ab0JDNHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 09:07:45 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: yOqRpRwVM1kdCjQfli8yDprbAChVqZK6.YBFNV78SfVCOqx
 T3rXHMOZfoY1ptWj6Cn7wT919vWvZwyAZM5dBmNrs9G7L4g_BShUKS1eu.yW
 CNw_KF8bnezMX4dtaAqDeoc1WLIsWVnHstdZmX8bkfuJ1iHelKj.BURBd0f4
 a0HrbUW6E6yXa8lkWTbeEiIYpW2QdeAsJQGjduOPx3RIKR3aUU5oRLHbPzZw
 jrLYa5UcQPYtSDAS8za4.jxs9zesHanxx6g--
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 4 Oct 2010 08:07:42 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Mel Gorman <mel@csn.ul.ie>, Rob Mueller <robm@fastmail.fm>,
        linux-kernel@vger.kernel.org, Bron Gondwana <brong@fastmail.fm>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad forfile/email/web
 servers
In-Reply-To: <20101004211112.E8B1.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1010040805500.2502@router.home>
References: <20100927110049.6B31.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1009270828510.7000@router.home> <20101004211112.E8B1.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Oct 2010, KOSAKI Motohiro wrote:

> > The problem with zone reclaim mainly is created for large apps whose
> > working set is larger than the local node. The special settings are only
> > needing for those applications.
>
> In theory, yes. but please talk with userland developers. They always say
> "Our software work fine on *BSD, Solaris, Mac, etc etc. that's definitely
> linux problem". /me have no way to persuade them ;-)

Do those support NUMA? I would think not. You would have to switch on
interleave at the BIOS level (getting a hardware hack in place to get
rid of the NUMA effects) to make these OSes run right.

> This is one of option. but we don't need to create x86 arch specific
> RECLAIM_DISTANCE. Because practical high-end numa machine are either
> ia64(SGI, Fujitsu) or Power(IBM) and both platform already have arch
> specific definition. then changing RECLAIM_DISTANCE doesn't make any
> side effect on such platform. and if possible, x86 shouldn't have
> arch specific definition because almost minor arch don't have a lot of
> tester and its quality often depend on testing on x86.
>
> attached a patch below.

Looks good.

Acked-by: Christoph Lameter <cl@linux.com>

