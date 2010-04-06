Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab0DFQyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:54:47 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:44838 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab0DFQyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:54:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bQgdgfQL6ObXDrHd6GZ7wXkAycE7ZtVh3iTGrCduGxl0kVWwu9bc1wxEzE3ZXK9Bmk
         r5h6fiGmXvTn8DLdi5pHZJ2xRAC1UKd0jlf7FApGiE2AIYXKNnMPFunaZ95Vf4x1CjRU
         lCNDKTIzgVRKaTIYh1zFMfHuLCXuTRwYj3tF4=
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
From: Minchan Kim <minchan.kim@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
In-Reply-To: <alpine.LFD.2.00.1004060929130.3487@i5.linux-foundation.org>
References: <20100402175937.GA19690@liondog.tnic>
	 <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>
	 <20100406173754.7E5A.A69D9226@jp.fujitsu.com> <4BBB475A.7070002@redhat.com>
	  <1270568096.1814.145.camel@barrios-desktop>
	 <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>
	 <1270571019.1814.163.camel@barrios-desktop>
	 <alpine.LFD.2.00.1004060929130.3487@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 01:54:26 +0900
Message-ID: <1270572866.1711.10.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 09:32 -0700, Linus Torvalds wrote:
> 
> On Wed, 7 Apr 2010, Minchan Kim wrote:
> > > 
> > > I don't think so. That isn't the racy case. We're working with a 
> > > anon_vma_chain, so the anonvma is all there.
> > 
> > But the anon_vma is using for another anon_vma. 
> 
> No, that can only happen if somebody has done "anon_vma_free()" on it. And 
> nobody does that if the anonvma still has a non-empty'&anon_vma->head'.
> 
> So as long as the anon_vma has a anon_vma_chain entry associated with it 
> (or a ksm refcount, but that's a separate issue), it's not going to be 
> re-allocated for any other use, because it's not going to be free'd.
> 	

> 		Linus

That's what I am missing.
Thanks, Linus. 

I will think over the problem. :)

-- 
Kind regards,
Minchan Kim


