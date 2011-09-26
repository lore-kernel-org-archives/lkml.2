Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1IZPZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 11:25:06 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:31220 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751727Ab1IZPZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 11:25:04 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: oAJqxR4VM1k4Bw7tZ7VbcAGmf75K82fg_mSFPc2B70wicYg
 nhexvtUscEoj6TpXwgXFpHsX.F85X8ygKqgi7aPPH0fS0e5DE_Zdr1NhdmBo
 qc4weETwCloXiJW974ED9BkqHTCqUihsEZtBhizvRfjED6ZB60e9gq9kbUsl
 S1nL8Mq_UV5X8nbbynsUiH6mlReX_yhdwplVjS0XIrMdgT48bHtm5lD7zR.H
 .EoCSLlPN8or0zOhrFBasT.COXYylEL.ENSWP41HtNWhY9pydTLsWvePKEfC
 x.Hl_PtYyTnuEuK6VnLwrcXe9tJvi3h471lATvmVRppWPrUw4cClP3iKOREV
 rIDdamXt4GIPpWrz.iRJ5QZ1fCFmHifw68kb0nA5dk5Vn1oY-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 26 Sep 2011 10:24:59 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 4/5] mm: Only IPI CPUs to drain local pages if they
 exist
In-Reply-To: <CAOtvUMddUAATZcU_5jLgY10ocsHNnOO2GC2c4ecYO9KGt-U7VQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1109261023400.24164@router.home>
References: <1316940890-24138-1-git-send-email-gilad@benyossef.com> <1316940890-24138-5-git-send-email-gilad@benyossef.com> <1317001924.29510.160.camel@sli10-conroe> <CAOtvUMddUAATZcU_5jLgY10ocsHNnOO2GC2c4ecYO9KGt-U7VQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011, Gilad Ben-Yossef wrote:

> I do not know if these scenarios warrant the additional overhead,
> certainly not in all situations. Maybe the right thing is to make it a
> config option dependent. As I stated in the patch description, that is
> one of the thing I'm interested in feedback on.

The flushing of the per cpu pages only done when kmem_cache_shrink() is
run or when a slab cache is closed. And for diagnostics. So its rare and
not performance critical.


