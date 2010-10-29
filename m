Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab0J2OzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 10:55:17 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:27180 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757398Ab0J2OzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 10:55:12 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: dwXfj8sVM1mZd.baM0V0XHG9dvaV15cY2AwcPTV.h9Kk9PU
 MSorjB2b8GhLjfsyTQsGUAmfKQzVx2X6MMEbcbCO2tK94ZvSXVVCc_QYQo.T
 CtrKC9hQvB6a7HUH0wP..aujUJVAYEe1V5KtwsVCVvHwafq58wAYWP944Kef
 ZcggHb5LsbH5vkeK9Y5aGdgLH9asmXAI3LH8aFrVpvqKgZ9c0.AA9x7.psPU
 Q0PH1H0uYSdmul_GAr1qrGwHASgO4h6YljgSKvtXyEg--
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 29 Oct 2010 09:55:08 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] numa: fix slab_node(MPOL_BIND)
In-Reply-To: <20101028140725.755aea50.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1010290952190.20370@router.home>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com> <1288158182-1753-1-git-send-email-brgerst@gmail.com> <1288159670.2652.181.camel@edumazet-laptop> <1288173442.15336.1490.camel@twins> <1288186405.2709.117.camel@edumazet-laptop>
 <4CC82C2F.1020707@kernel.org> <1288187870.2709.128.camel@edumazet-laptop> <4CC83067.5000009@kernel.org> <1288189461.2709.144.camel@edumazet-laptop> <1288190387.2709.147.camel@edumazet-laptop> <4CC83A85.3070608@kernel.org> <1288192868.2709.152.camel@edumazet-laptop>
 <4CC846D5.50106@kernel.org> <1288195668.2709.167.camel@edumazet-laptop> <1288200823.5619.46.camel@edumazet-laptop> <AANLkTikmNc7qqDzoff_3i_FRbG=pmOC7TG3eeZnmvaTD@mail.gmail.com> <alpine.DEB.2.00.1010281154150.26782@router.home>
 <20101028140725.755aea50.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Oct 2010, Andrew Morton wrote:

> On Thu, 28 Oct 2010 11:55:18 -0500 (CDT)
> Christoph Lameter <cl@linux.com> wrote:
>
> > On Thu, 28 Oct 2010, Linus Torvalds wrote:
> >
> > > And so does - although less obviously - mm/vmscan.c for the
> > > wait_iff_confgested() thing.
> > >
> > > So are those buggy too, since first_zones_zonelist() can apparently return NULL?
> >
> > The code is fine.
> >
> > first_zones_zonelist() can only return NULL for the case that a nodemask
> > was specified and the code in vmscan.c does not specify a nodemask.
>
> Geeze, how did you work that out and how the heck was anyone else
> supposed to know this :(

Look at the code and how it was modified by Lee. The initial assumption
before his patch was that the zonelist contains all zones of the system.
Therefore you will allways find all possible zone types in the system.
The function did not contain a check for the end of the zonelist and does
not now for the nodemask == NULL.

However, the modification to filter the zonelist then makes it possible to
have subsets of zones not containing the requested zone types now.
Therefore Lee added a check for the end of the zonelist for that case.

Could be better documented. Took me some staring at the code to figure it
out.

