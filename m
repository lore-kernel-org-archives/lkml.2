Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab0DVPPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 11:15:38 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:39738 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab0DVPPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 11:15:37 -0400
Date: Thu, 22 Apr 2010 10:14:04 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Minchan Kim <minchan.kim@gmail.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 04/14] mm,migration: Allow the migration of PageSwapCache
  pages
In-Reply-To: <1271946226.2100.211.camel@barrios-desktop>
Message-ID: <alpine.DEB.2.00.1004221009150.32107@router.home>
References: <1271797276-31358-1-git-send-email-mel@csn.ul.ie>  <alpine.DEB.2.00.1004210927550.4959@router.home>  <20100421150037.GJ30306@csn.ul.ie>  <alpine.DEB.2.00.1004211004360.4959@router.home>  <20100421151417.GK30306@csn.ul.ie> 
 <alpine.DEB.2.00.1004211027120.4959@router.home>  <20100421153421.GM30306@csn.ul.ie>  <alpine.DEB.2.00.1004211038020.4959@router.home>  <20100422092819.GR30306@csn.ul.ie>  <20100422184621.0aaaeb5f.kamezawa.hiroyu@jp.fujitsu.com> 
 <x2l28c262361004220313q76752366l929a8959cd6d6862@mail.gmail.com>  <20100422193106.9ffad4ec.kamezawa.hiroyu@jp.fujitsu.com>  <20100422195153.d91c1c9e.kamezawa.hiroyu@jp.fujitsu.com> <1271946226.2100.211.camel@barrios-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010, Minchan Kim wrote:

> For further optimization, we can hold vma->adjust_lock if vma_address
> returns -EFAULT. But I hope we redesigns it without new locking.
> But I don't have good idea, now. :(

You could make it atomic through the use of RCU.

Create a new vma entry with the changed parameters and then atomically
switch to the new vma.

Problem is that you have some list_heads in there.

