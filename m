Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0IQOWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 10:22:05 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:41291 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753908Ab0IQOWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 10:22:04 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: xE_mZioVM1kovGE26NTOCXeOOrG13JKq2hoMfdC75.W1.B_
 nNSOJJnJ0ZMjIrc2ADvpdPTJDhi7_k02zJXFpMtvmBs6gWZHCYzltb9uoykD
 zsYGfBCbc.IzDi0Fl6f5D7MMTPe3DWXI1Km5iu51A3csoZN2JiluxKxy0ofU
 H5KrSM00k3egUxBQob6OglUtU9lZxpL7IvOWgSpsf4lVDSOBPiW07TUgHGN9
 a7ElWU6DWuizN5j.ij3RcDyIVL9MD
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 17 Sep 2010 09:22:00 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Bron Gondwana <brong@fastmail.fm>
cc: Robert Mueller <robm@fastmail.fm>, Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad for
 file/email/web servers
In-Reply-To: <20100917140916.GA8474@brong.net>
Message-ID: <alpine.DEB.2.00.1009170916130.11900@router.home>
References: <1284349152.15254.1394658481@webmail.messagingengine.com> <20100916184240.3BC9.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1009161153210.22849@router.home> <1284684653.10161.1395434085@webmail.messagingengine.com> <1284703264.3408.1.camel@sli10-conroe.sh.intel.com>
 <1284708756.2702.1395472601@webmail.messagingengine.com> <alpine.DEB.2.00.1009170851200.11900@router.home> <20100917140916.GA8474@brong.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Sep 2010, Bron Gondwana wrote:

> > From the first look that seems to be the problem. You do not need to be
> > bound to a particular cpu, the scheduler will just leave a single process
> > on the same cpu by default. If you then allocate all memory only from this
> > process then you get the scenario that you described.
>
> Huh?  Which bit of forking server makes you think one process is allocating
> lots of memory?  They're opening and reading from files.  Unless you're
> calling the kernel a "single process".

I have no idea what your app does. The data that I glanced over looks as
if most allocations happen for a particular memory node and since the
memory is optimized to be local to that node other memory is not used
intensively. This can occur because of allocations through one process /
thread that is always running on the same cpu and therefore always
allocates from the memory node local to that cpu.

It can also happen f.e. if a driver always allocates memory local to the
I/O bus that it is using.

