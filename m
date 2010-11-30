Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab0K3TNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:13:51 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:38112 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753174Ab0K3TNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:13:50 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: NjKfM5UVM1msUNmtkHVIEfJejylPyGNN1VEyG1u.VbWbosx
 OsdkEcLEDa_rTDwg8fTuTrOsaoHAqo8b9.DhA7LpHiJcPx9AuGgnvC42UZPc
 qNpabg_Jy2FkR1JExMCsmzJcORuUUfn9Dso_b.BZB1MqzMCTQ7gOAttsrbFN
 EqDqNNrZlFKdZ1Ih0AAH.EictvLUb22.YkLbSqv31R7pJNEo4rTbiizZRm.x
 .jSFRDz.p4YQ-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 30 Nov 2010 13:13:46 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Simon Kirby <sim@hostway.ca>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: Free memory never fully used, swapping
In-Reply-To: <20101130091325.GA17340@hostway.ca>
Message-ID: <alpine.DEB.2.00.1011301311530.3134@router.home>
References: <20101124092753.GS19571@csn.ul.ie> <20101124191749.GA29511@hostway.ca> <20101125101803.F450.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011260943220.12265@router.home> <20101130091325.GA17340@hostway.ca>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, Simon Kirby wrote:

> Can we also mess with these /sys files on the fly?

Sure. Go ahead. These are runtime configurable.

> I'm not familiar with how slub works, but I assume there's some overhead
> or some reason not to just use order 0 for <= kmalloc-4096?  Or is it
> purely just trying to reduce cpu by calling alloc_pages less often?

Using higher order pages reduces the memory overhead for objects (that
after all need to be packed into an order N page), decreases the amount
of metadata that needs to be managed and decreases the use of the
slowpaths. That implies also a reduction in the locking overhead.


