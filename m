Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab2FZIiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 04:38:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48505 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758434Ab2FZIiH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 04:38:07 -0400
Message-ID: <1340699831.21991.34.camel@twins>
Subject: Re: [PATCH -mm v2 01/11] mm: track free size between VMAs in VMA
 rbtree
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Rik van Riel <riel@surriel.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, aarcange@redhat.com, minchan@gmail.com,
        kosaki.motohiro@gmail.com, andi@firstfloor.org, hannes@cmpxchg.org,
        mel@csn.ul.ie, linux-kernel@vger.kernel.org
Date: Tue, 26 Jun 2012 10:37:11 +0200
In-Reply-To: <4FE8DD80.9040108@redhat.com>
References: <1340315835-28571-1-git-send-email-riel@surriel.com>
	     <1340315835-28571-2-git-send-email-riel@surriel.com>
	    <1340359115.18025.57.camel@twins> <4FE47D0E.3000804@redhat.com>
	   <1340374439.18025.75.camel@twins> <4FE48054.5090407@redhat.com>
	  <1340375872.18025.77.camel@twins> <4FE4922D.8070501@surriel.com>
	 <1340652578.21991.18.camel@twins> <4FE8DD80.9040108@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 17:52 -0400, Rik van Riel wrote:
> > The thing you propose, the double search, once for len, and once for len
> > +align-1 doesn't guarantee you'll find a hole. All holes of len might be
> > mis-aligned but the len+align-1 search might overlook a hole of suitable
> > size and alignment, you'd have to search the entire range: [len, len
> > +align-1], and that's somewhat silly.
> 
> This may still be good enough. 

OK, as long as this is clearly mentioned in a comment near there.

It just annoys me that I cannot come up with anything better :-)
