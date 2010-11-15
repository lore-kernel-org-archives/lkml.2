Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab0KOOqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 09:46:15 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:59151 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756977Ab0KOOqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 09:46:14 -0500
Date: Mon, 15 Nov 2010 07:46:12 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Luben Tuikov <ltuikov@yahoo.com>,
        Greg KH <greg@kroah.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>
Subject: Re: SCSI TMF processing; tag allocation
Message-ID: <20101115144612.GA6178@parisc-linux.org>
References: <380694.87733.qm@web31812.mail.mud.yahoo.com> <20101113123750.GF18258@parisc-linux.org> <4CE0FD24.4030000@fusionio.com> <1289831595.2233.5.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289831595.2233.5.camel@mulgrave.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 08:33:15AM -0600, James Bottomley wrote:
> Right, it's the clock algorithm to prevent tag starvation.  If you have
> hands representing the first and last tag and they're never allowed to
> cross, the device can't starve any tag for too long because eventually
> it will be the only outstanding command.
> 
> It's not the only algorithm however.  Banging down an ordered tag every
> 200 or so commands has exactly the same effect.  In fact the clock
> algorithm was what the 53c700 driver used (before it was converted to
> generic tags) and the ordered tag what aic7xxx uses.
> 
> Realistically, tag starvation isn't really a problem.  It was a known
> issue for 80s era hardware.  I've got some of the oldest drives on the
> planet and I didn't see a problem when the clock algorithm was removed
> from 53c700.

The problem is that each driver is solving the problem in its own way
right now, which is clearly daft.  And no drive manufactured in the past
fifteen years supports ordered tags anyway, so they're only a placebo
at this point.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
