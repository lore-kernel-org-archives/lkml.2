Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab0JQTjZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 15:39:25 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36551 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932540Ab0JQTjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 15:39:24 -0400
Date: Sun, 17 Oct 2010 21:39:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
        warthog9@kernel.org, hpa@zytor.com, devel@lists.fedoraprojet.org
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
Message-ID: <20101017193908.GA20157@elf.ucw.cz>
References: <20101016065206.GO4681@dastard>
 <20101016192027.GA6883@infradead.org>
 <1287295077.3020.83.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287295077.3020.83.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-10-17 01:57:57, Mimi Zohar wrote:
> On Sat, 2010-10-16 at 15:20 -0400, Christoph Hellwig wrote:
> > Besides the algorithmic problems with ima, why is kernel.org using
> > IMA to start with?  Except for IBM looking for a reason to jusity why
> > TPM isn't a completely waster of ressources it's pointless.  And it was
> > only merged under the premise that it would not affect innocent normal
> > users.
> > 
> 
> Can we keep this at the design level please? When IMA is enabled, it
> needs to store information on a per inode basis, yet has to wait to
> late_initcall() for the TPM, at which point some inodes would have
> already been created.  For this reason, there is a two step

Move TPM earlier in the boot process...?

And... having huge structure for storing just number of writers (as
Eric explained) seems just wrong. Surely, you can do something like
lsof; which will be slow but only done when actually enabling IMA?


								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
