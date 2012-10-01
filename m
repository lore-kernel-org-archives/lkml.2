Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab2JAPn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 11:43:28 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:37107 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab2JAPn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 11:43:27 -0400
Date: Mon, 1 Oct 2012 11:43:11 -0400
From: Jamie Gloudon <jamie.gloudon@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: x86_64: wrong DirectMap kB
Message-ID: <20121001154311.GA2605@darkstar>
References: <20121001104652.GA1390@darkstar>
 <alpine.LSU.2.00.1210010812530.1914@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1210010812530.1914@eggly.anvils>
User-Agent: Mutt/ (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was also skeptical about DirectMap results added up being less than
MemTotal. I see now, Thanks for the explanation.

Jamie Gloudon

On Mon, Oct 01, 2012 at 08:23:38AM -0700, Hugh Dickins wrote:
> On Mon, 1 Oct 2012, Jamie Gloudon wrote:
> > 
> >  Interesting. I am able to reproduce the same problem as you using mem=700M, which shows: 
> > 
> > DirectMap4k:        4096 kB
> > DirectMap2M:    18446744073709547520 kB
> > 
> > However, it appears to be normal without the boot parameter:
> > 
> > DirectMap4k:        4096 kB
> > DirectMap2M:    15708160 kB
> 
> It appears to be normal because the calculations haven't wrapped around,
> but if you compare with 3.4 or before, I think you'll find that it
> still adds up to too little.
> 
> > 
> > What does your output looks like with the full amount on 3.6?
> 
> On 3.6:
> 
> MemTotal:        8060528 kB
> ...
> DirectMap4k:        2048 kB
> DirectMap2M:     7229440 kB
> 
> So it's showing significantly less direct mapped than is included
> in MemTotal (which itself omits some areas of reserved memory).
> 
> Whereas on 3.4:
> 
> MemTotal:        8060760 kB
> ...
> DirectMap4k:        4096 kB
> DirectMap2M:     8275968 kB
> 
> Hugh
