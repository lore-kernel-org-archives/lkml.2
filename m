Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab0FCIKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 04:10:46 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:39588 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754431Ab0FCIKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 04:10:44 -0400
Date: Sun, 30 May 2010 07:25:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [linux-pm] Proposal for a new algorithm for reading & writing
 a hibernation image.
Message-ID: <20100530052546.GA25287@ucw.cz>
References: <4BE7475A.8030901@crca.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE7475A.8030901@crca.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> 2. Prior to writing any of the image, also set up new 4k page tables 
> such that an attempt to make a change to any of the pages we're about to 
> write to disk will result in a page fault, giving us an opportunity to 
> flag the page as needing an atomic copy later. Once this is done, write 
> protection for the page can be disabled and the write that caused the 
> fault allowed to proceed.

Tricky.

page faulting code touches memory, too...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
