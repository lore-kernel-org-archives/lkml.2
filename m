Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab0DFQg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:36:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669Ab0DFQgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:36:49 -0400
Date: Tue, 6 Apr 2010 09:32:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
cc: Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
In-Reply-To: <1270571019.1814.163.camel@barrios-desktop>
Message-ID: <alpine.LFD.2.00.1004060929130.3487@i5.linux-foundation.org>
References: <20100402175937.GA19690@liondog.tnic>  <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>  <20100406173754.7E5A.A69D9226@jp.fujitsu.com> <4BBB475A.7070002@redhat.com>  <1270568096.1814.145.camel@barrios-desktop> 
 <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org> <1270571019.1814.163.camel@barrios-desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Apr 2010, Minchan Kim wrote:
> > 
> > I don't think so. That isn't the racy case. We're working with a 
> > anon_vma_chain, so the anonvma is all there.
> 
> But the anon_vma is using for another anon_vma. 

No, that can only happen if somebody has done "anon_vma_free()" on it. And 
nobody does that if the anonvma still has a non-empty'&anon_vma->head'.

So as long as the anon_vma has a anon_vma_chain entry associated with it 
(or a ksm refcount, but that's a separate issue), it's not going to be 
re-allocated for any other use, because it's not going to be free'd.
	
		Linus
