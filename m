Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2IFW3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 18:29:39 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36680 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab2IFW3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 18:29:38 -0400
Date: Thu, 6 Sep 2012 15:29:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Matt Mackall <mpm@selenic.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] slab: fix the DEADLOCK issue on l3 alien lock
Message-ID: <20120906222933.GR2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5044692D.7080608@linux.vnet.ibm.com>
 <5046B9EE.7000804@linux.vnet.ibm.com>
 <0000013996b6f21d-d45be653-3111-4aef-b079-31dc673e6fd8-000000@email.amazonses.com>
 <504812E7.3000700@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504812E7.3000700@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090622-7182-0000-0000-000002873730
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 11:05:11AM +0800, Michael Wang wrote:
> On 09/05/2012 09:55 PM, Christoph Lameter wrote:
> > On Wed, 5 Sep 2012, Michael Wang wrote:
> > 
> >> Since the cachep and cachep->slabp_cache's l3 alien are in the same lock class,
> >> fake report generated.
> > 
> > Ahh... That is a key insight into why this occurs.
> > 
> >> This should not happen since we already have init_lock_keys() which will
> >> reassign the lock class for both l3 list and l3 alien.
> > 
> > Right. I was wondering why we still get intermitted reports on this.
> > 
> >> This patch will invoke init_lock_keys() after we done enable_cpucache()
> >> instead of before to avoid the fake DEADLOCK report.
> > 
> > Acked-by: Christoph Lameter <cl@linux.com>
> 
> Thanks for your review.
> 
> And add Paul to the cc list(my skills on mailing is really poor...).

Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

