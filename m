Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab0CXV6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:58:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab0CXV6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:58:05 -0400
Date: Wed, 24 Mar 2010 22:57:29 +0100
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
Message-ID: <20100324215729.GM10659@random.random>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
 <1269347146-7461-8-git-send-email-mel@csn.ul.ie>
 <20100324133347.9b4b2789.akpm@linux-foundation.org>
 <20100324145946.372f3f31@bike.lwn.net>
 <20100324211924.GH10659@random.random>
 <20100324152854.48f72171@bike.lwn.net>
 <20100324214742.GL10659@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324214742.GL10659@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 10:47:42PM +0100, Andrea Arcangeli wrote:
> As far as I can tell, VM_BUG_ON would make _zero_ differences there.
> 
> I think you mistaken a VM_BUG_ON for a:
> 
>   if (could_be_null->something) {

Ooops, I wrote ->something to indicate that "could_be_null" was going
to later be dereferenced for ->something and here we're checking if it
could be null when we dereference something, but now I think it could
be very confusing as I use strict C for all the rest, so maybe I
should clarify in C it would be !could_be_null.

>      WARN_ON(1);
>      return -ESOMETHING;
>   }
> 
> adding a VM_BUG_ON(inode->something) would _still_ be as exploitable

here the same !inode.
