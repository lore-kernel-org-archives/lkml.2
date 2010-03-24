Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab0CXVU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:20:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab0CXVU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:20:56 -0400
Date: Wed, 24 Mar 2010 22:19:24 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 07/11] Memory compaction core
Message-ID: <20100324211924.GH10659@random.random>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
 <1269347146-7461-8-git-send-email-mel@csn.ul.ie>
 <20100324133347.9b4b2789.akpm@linux-foundation.org>
 <20100324145946.372f3f31@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324145946.372f3f31@bike.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On Wed, Mar 24, 2010 at 02:59:46PM -0600, Jonathan Corbet wrote:
> On Wed, 24 Mar 2010 13:33:47 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > +	VM_BUG_ON(cc == NULL);  
> > 
> > It's a bit strange to test this when we're about to oops anyway.  The
> > oops will tell us the same thing.
> 
> ...except that we've seen a fair number of null pointer dereference
> exploits that have told us something altogether different.  Are we
> *sure* we don't want to test for null pointers...?

Examples? Maybe WARN_ON != oops, but VM_BUG_ON still an oops that is
and without serial console it would go lost too. I personally don't
see how it's needed. Plus those things are mostly for debug to check
for invariant condition, how long it takes to sort it out isn't very
relevant. So I'm on Andrew camp ;).
