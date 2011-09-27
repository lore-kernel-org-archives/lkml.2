Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab1I0QNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:13:18 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:39643 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751328Ab1I0QNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:13:17 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Tb6_z1oVM1k7ZUjYVaLCP2_rY2V_bLC0NaUelAKudMgeJcm
 YFhYeAeCJEuvi7y7w4rtsy.ZZ1B5GpT7W8KPq8Eev5M.kd1QpBMxPOew3nUK
 h9D9GgYuQPswCgpmmyZi65dexrsVIthpbkkr3XBVhwECxH9PwteJNTgjecc4
 aqokODYuHl8KQK_6Jj6Kum2DZll6c04rEkGMCG.FvcouwNqPGiQbo3HEIRs9
 DCC0s7iVrJlO2UGlLDZ874pU_GMVulx9wUxorQYFyLS7R0SyCgt0P5cxOQ4H
 3MJR2ShRJvy0Z37vy_AIfKDEi4Lye0irubXPwxGzbEMWOvCXkxk8rWcz6Dcm
 4d5MMIw_JaoM1IfST591o79qK8Ke9A5gZFXkvrZQ5h9pTk0Q-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 27 Sep 2011 11:13:13 -0500 (CDT)
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
In-Reply-To: <CAOtvUMcvwWFxxxv7tsOj6FO-wrHAU8EYc+U=9u8yT=cz7XajBA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1109271109570.9569@router.home>
References: <1316940890-24138-1-git-send-email-gilad@benyossef.com> <1316940890-24138-5-git-send-email-gilad@benyossef.com> <1317001924.29510.160.camel@sli10-conroe> <CAOtvUMddUAATZcU_5jLgY10ocsHNnOO2GC2c4ecYO9KGt-U7VQ@mail.gmail.com>
 <alpine.DEB.2.00.1109261023400.24164@router.home> <CAOtvUMcvwWFxxxv7tsOj6FO-wrHAU8EYc+U=9u8yT=cz7XajBA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011, Gilad Ben-Yossef wrote:

> My hope is to come up with a way to do more code on the CPU doing the
> flush_all (which
> as you said is a rare and none performance critical code path anyway)
> and by that gain the ability
> to do the job without interrupting CPUs that do not need to flush
> their per cpu pages.

You may not need that for the kmem_cache_destroy(). At close time there
are no users left and no one should be accessing the cache anyways. You
could flush the whole shebang without IPIs.

Problem is that there is no guarantee that other processes will not still
try to access the cache. If you want to guarantee that then change some
settings in either struct kmem_cache or struct kmem_cache_cpu that makes
allocation and freeing impossible before flushing the per cpu pages.

