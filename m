Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab1DYLlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 07:41:14 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:43446 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758469Ab1DYLlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 07:41:14 -0400
Date: Sun, 24 Apr 2011 22:47:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rik van Riel <riel@redhat.com>
Cc: rwhitton@iee.org, linux-kernel@vger.kernel.org
Subject: Re: Background memory scrubbing
Message-ID: <20110424204447.GA2467@ucw.cz>
References: <20131.1303319102@jupiter.eclipse.co.uk>
 <4DAF1DA7.9040705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAF1DA7.9040705@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>>for each PFN from 256 to the highest valid PFN
> >>>{
> >>>if (pfn_valid(PFN))
> >>>{
> >>>page = pfn_to_page(PFN)
> >>>va = kmap(page)
> >>>atomic_scrub(va, PAGE_SIZE)
> >>>kunmap(page)
> >>>}
> >>>
> >>>sleep(for_a_while)
> >>>}
> >>
> >>What exactly does atomic_scrub do?
> >
> >atomic_scrub is part of the edac subsystem see arch/x86/include/asm/edac.h. It simply does a locked add of zero to each DWORD in the specified range.
> 
> I can think of only a few ways in which that could cause a
> kernel page fault.
> 
> One of the more obvious causes would be running into an
> area of kernel memory that is mapped read-only.  Writing
> to a page that is mapped read-only would cause a page
> fault :)

...also... you are actually making kernel use "self modifying code"
here. There  are CPU bugs in that area...  for example on K6.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
