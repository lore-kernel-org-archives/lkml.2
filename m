Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab0DPOxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:53:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755702Ab0DPOxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:53:14 -0400
Date: Fri, 16 Apr 2010 07:48:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Felipe Balbi <felipe.balbi@nokia.com>
cc: Rik van Riel <riel@redhat.com>, Borislav Petkov <bp@alien8.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "sgunderson@bigfoot.com" <sgunderson@bigfoot.com>
Subject: Re: [PATCH] rmap: add exclusively owned pages to the newest
 anon_vma
In-Reply-To: <20100416060924.GD1710@nokia.com>
Message-ID: <alpine.LFD.2.00.1004160743430.15116@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org> <20100412072056.GA2432@liondog.tnic> <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org> <20100412215027.GA6263@liondog.tnic> <alpine.LFD.2.00.1004121508290.3647@i5.linux-foundation.org> <20100413093827.GA6954@liondog.tnic> <20100414175928.5e1bdce2@annuminas.surriel.com>
 <alpine.LFD.2.00.1004151256090.15116@i5.linux-foundation.org> <20100416060924.GD1710@nokia.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 Apr 2010, Felipe Balbi wrote:
> 
> while at that, would it make sense to first provide list_last_entry() since we
> already have list_first_entry() ??

Yeah, it probably would make sense. Especially as doing a simple grep for 
'list_entry.*prev' does seem to imply that there might be quite a few 
places that would be able to use it. Although some of them do seem to be 
about finding the previous entry rather than the last in a list.

That said, doing the same grep for 'next' shows that a lot of places don't 
use the list_first_entry() that we _do_ have, so..

		Linus
