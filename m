Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab1AGXXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 18:23:51 -0500
Received: from thunk.org ([69.25.196.29]:55202 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab1AGXXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 18:23:50 -0500
Date: Fri, 7 Jan 2011 18:23:39 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: David Rientjes <rientjes@google.com>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: mke2fs: page allocation failure w/ kernel 2.6.37
Message-ID: <20110107232339.GS21922@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	David Rientjes <rientjes@google.com>,
	Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-kernel@vger.kernel.org
References: <201101052237.36735.toralf.foerster@gmx.de>
 <alpine.DEB.2.00.1101071443280.23858@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.1101071443280.23858@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 02:45:30PM -0800, David Rientjes wrote:
> On Wed, 5 Jan 2011, Toralf Förster wrote:
> 
> > Hello,
> > 
> > I got this in /var/log/messages today (created a ext2 partition at an external USB drive, worked fine) :
> > 
> 
> Yeah, this failure is from the kmemleak stack which simply means that 
> debugging tool will be disabled rather than any disruption to the 
> workflow.
> 
> I'm curious why kmemleak is masking with GFP_KERNEL and GFP_ATOMIC and not 
> allowing users to pass __GFP_NOWARN to suppress this type of failure, 
> especially since the stack trace is already emitted by kmemleak when it is 
> stopped.  Catalin?

Indeed, is there a reason why the kmemleak code is so noisy?  And can
it display a more obvious message about what is going on?  It took me
a while to figure out why it was unhappy, and whether there it was a
fault of the code it was testing, or just that it could get the memory
it needed....

						- Ted
