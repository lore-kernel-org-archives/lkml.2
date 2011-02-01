Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab1BAPEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 10:04:04 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:40811 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab1BAPEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:04:02 -0500
Subject: Re: [RFC][PATCH 2/6] pagewalk: only split huge pages when necessary
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <20110201100433.GH19534@cmpxchg.org>
References: <20110201003357.D6F0BE0D@kernel>
	 <20110201003359.8DDFF665@kernel>  <20110201100433.GH19534@cmpxchg.org>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 01 Feb 2011 07:03:56 -0800
Message-ID: <1296572636.27022.2870.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 11:04 +0100, Johannes Weiner wrote:
> On Mon, Jan 31, 2011 at 04:33:59PM -0800, Dave Hansen wrote:
> > Right now, if a mm_walk has either ->pte_entry or ->pmd_entry
> > set, it will unconditionally split and transparent huge pages
> > it runs in to.  In practice, that means that anyone doing a
> > 
> >       cat /proc/$pid/smaps
> > 
> > will unconditionally break down every huge page in the process
> > and depend on khugepaged to re-collapse it later.  This is
> > fairly suboptimal.
> > 
> > This patch changes that behavior.  It teaches each ->pmd_entry
> > handler (there are three) that they must break down the THPs
> > themselves.  Also, the _generic_ code will never break down
> > a THP unless a ->pte_entry handler is actually set.
> > 
> > This means that the ->pmd_entry handlers can now choose to
> > deal with THPs without breaking them down.
> 
> Makes perfect sense.  But you forgot to push down the splitting into
> the two handlers in mm/memcontrol.c. 

I did indeed.  I'll go fix those up.  Thanks for the review!

-- Dave

