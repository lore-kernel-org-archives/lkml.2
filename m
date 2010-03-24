Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab0CXV27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:28:59 -0400
Received: from tex.lwn.net ([70.33.254.29]:59378 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab0CXV25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:28:57 -0400
Date: Wed, 24 Mar 2010 15:28:54 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Andrea Arcangeli <aarcange@redhat.com>
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
Message-ID: <20100324152854.48f72171@bike.lwn.net>
In-Reply-To: <20100324211924.GH10659@random.random>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
	<1269347146-7461-8-git-send-email-mel@csn.ul.ie>
	<20100324133347.9b4b2789.akpm@linux-foundation.org>
	<20100324145946.372f3f31@bike.lwn.net>
	<20100324211924.GH10659@random.random>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.19.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010 22:19:24 +0100
Andrea Arcangeli <aarcange@redhat.com> wrote:

> > > It's a bit strange to test this when we're about to oops anyway.  The
> > > oops will tell us the same thing.  
> > 
> > ...except that we've seen a fair number of null pointer dereference
> > exploits that have told us something altogether different.  Are we
> > *sure* we don't want to test for null pointers...?  
> 
> Examples? Maybe WARN_ON != oops, but VM_BUG_ON still an oops that is
> and without serial console it would go lost too. I personally don't
> see how it's needed.

I don't quite understand the question; are you asking for examples of
exploits?

	http://lwn.net/Articles/347006/
	http://lwn.net/Articles/360328/
	http://lwn.net/Articles/342330/
	...

As to whether this particular test makes sense, I don't know.  But the
idea that we never need to test about-to-be-dereferenced pointers for
NULL does worry me a bit.

jon
