Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab0CXVP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:15:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751550Ab0CXVP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:15:26 -0400
Date: Wed, 24 Mar 2010 14:14:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 07/11] Memory compaction core
Message-Id: <20100324141400.72479ce6.akpm@linux-foundation.org>
In-Reply-To: <20100324145946.372f3f31@bike.lwn.net>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
	<1269347146-7461-8-git-send-email-mel@csn.ul.ie>
	<20100324133347.9b4b2789.akpm@linux-foundation.org>
	<20100324145946.372f3f31@bike.lwn.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010 14:59:46 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

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
> 

It's hard to see what the test gains us really - the kernel has
zillions of pointer derefs, any of which could be NULL if we have a
bug.  Are we more likely to have a bug here than elsewhere?

This one will oops on a plain old read, so it's a bit moot in this
case.
