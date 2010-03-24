Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab0CXVy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:54:26 -0400
Received: from tex.lwn.net ([70.33.254.29]:35004 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab0CXVyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:54:25 -0400
Date: Wed, 24 Mar 2010 15:54:23 -0600
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
Message-ID: <20100324155423.68c3d5b6@bike.lwn.net>
In-Reply-To: <20100324214742.GL10659@random.random>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
	<1269347146-7461-8-git-send-email-mel@csn.ul.ie>
	<20100324133347.9b4b2789.akpm@linux-foundation.org>
	<20100324145946.372f3f31@bike.lwn.net>
	<20100324211924.GH10659@random.random>
	<20100324152854.48f72171@bike.lwn.net>
	<20100324214742.GL10659@random.random>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.19.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010 22:47:42 +0100
Andrea Arcangeli <aarcange@redhat.com> wrote:

> I think you mistaken a VM_BUG_ON for a:
> 
>   if (could_be_null->something) {
>      WARN_ON(1);
>      return -ESOMETHING;
>   }
> 
> adding a VM_BUG_ON(inode->something) would _still_ be as exploitable
> as the null pointer deference, because it's a DoS. It's not really a
> big deal of an exploit but it _sure_ need fixing.

Ah, but that's the point: these NULL pointer dereferences were not DoS
vulnerabilities - they were full privilege-escalation affairs.  Since
then, some problems have been fixed and some distributors have started
shipping smarter configurations.  But, on quite a few systems a NULL
dereference still has the potential to be fully exploitable; if there's
a possibility of it happening I think we should test for it.  A DoS is
a much better outcome...

jon
