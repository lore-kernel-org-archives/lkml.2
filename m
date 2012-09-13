Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2IMGed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:34:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49108 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab2IMGe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:34:29 -0400
Date: Wed, 12 Sep 2012 23:33:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 09/12] thp: introduce khugepaged_prealloc_page and
 khugepaged_alloc_page
In-Reply-To: <alpine.LSU.2.00.1209122316200.7831@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1209122329320.7848@eggly.anvils>
References: <5028E12C.70101@linux.vnet.ibm.com> <5028E20C.3080607@linux.vnet.ibm.com> <alpine.LSU.2.00.1209111807030.21798@eggly.anvils> <50500360.5020700@linux.vnet.ibm.com> <alpine.LSU.2.00.1209122316200.7831@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2012, Hugh Dickins wrote:
> > @@ -1825,6 +1825,7 @@ static bool khugepaged_prealloc_page(struct page **hpage, bool *wait)
> >  			return false;
> > 
> >  		*wait = false;
> > +		*hpage = NULL;
> >  		khugepaged_alloc_sleep();
> >  	} else if (*hpage) {
> >  		put_page(*hpage);
> 
> The unshown line just below this is
> 
> 		*hpage = NULL;
> 
> I do wish you would take the "*hpage = NULL;" out of if and else blocks
> and place it once below both.

Hold on, I'm being unreasonable: that's an "else if", and I've no good
reason to request you to set *hpage = NULL when it's already NULL.
It would be okay if you did, but there's no reason for me to prefer it.

Hugh
