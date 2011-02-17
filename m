Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab1BQBs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 20:48:27 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52740 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab1BQBsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 20:48:17 -0500
Date: Thu, 17 Feb 2011 01:48:08 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ryan@bluewatersys.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Message-ID: <20110217014808.GD5824@sirena.org.uk>
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <201102100722.47854.manningc2@actrix.gen.nz> <20110216080419.GA21261@infradead.org> <201102171112.07101.manningc2@actrix.gen.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102171112.07101.manningc2@actrix.gen.nz>
X-Cookie: Causes moderate eye irritation.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 11:12:06AM +1300, Charles Manning wrote:
> On Wednesday 16 February 2011 21:04:20 Christoph Hellwig wrote:

> > The procfs interfaces should be replaced by something saner, 
> > the insane amount of ad-hoc tracing crap should be replaced by much
> > less strategically placed trace events, and all those stupid compile
> > time options have absolutely no business at all beeing there for a
> > filesystem - 

> Why not?

> > remember you can get media from all over the place. 

> No you can't. This is a flash file system for soldered down flash. I think 
> that is a fundamental place where your understanding of what yaffs is falls 
> down.

Even for embedded systems people do end up wanting to do things like
using the same kernel on multiple systems which may have different
hardware configurations (distros and reference boards are the obvious
examples, but I've worked on systems where multiple generations and
builds of the product were in active use and similar enough to be
maintained from the same kernel).  Even with single system kernels
there's still an issue with things like reference boards where users are
doing things like picking up a new upstream kernel rather than the
vendor BSP.

> > If you can't encode these difference in your on-disk format it has
> > absolutely no business going into mainline with this format.

> Yaffs does not really have an on-disk format like most other fs do.

I'm not sure exactly how you'd do this for a filesystem but this is
starting to sound a lot like platform data...  Though presumably if the
data isn't stored on the device currently it'd be a simple matter of
programming (if wasteful) to add it.
