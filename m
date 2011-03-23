Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab1CWSnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 14:43:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:51576 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278Ab1CWSns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 14:43:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,232,1299484800"; 
   d="scan'208";a="407378570"
Date: Wed, 23 Mar 2011 11:43:46 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] checkpatch: add option to change warning return value.
Message-ID: <20110323184346.GA5947@xanatos>
References: <20110322231310.GA7338@xanatos>
 <20110323100707.GC2297@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323100707.GC2297@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 11:07:07AM +0100, Johannes Weiner wrote:
> On Tue, Mar 22, 2011 at 04:13:10PM -0700, Sarah Sharp wrote:
> > There are a lot of warnings in checkpatch.pl that are rather subjective.
> > For instance, when a line is 81 characters long, and the patch submitter
> > is just cleaning up existing code, a maintainer may not care that
> > checkpatch.pl warns about the over 80-character line.  It should be up to
> > the maintainer what warnings they want to pay attention to.
> > 
> > Unfortunately, if you try to run checkpatch.pl as part of a git pre-commit
> > hook and a patch in a series being applied by git-am fails checkpatch.pl,
> > the whole process stops.  At that point I usually end up just disabling
> > that git hook, which means I don't see real errors in the patches.
> > 
> > Add an option to checkpatch.pl to print the warnings, but not return an
> > error code when the --lazy flag is present.  (Anyone with a better name
> > can pipe up, lazy just seemed to be the opposite to strict.)  This allows
> > the maintainer to view the warnings, but still allow the patch application
> > process to continue.
> 
> I first thought you would add code that allowed turning only select
> errors into warnings.
> 
> If you just want to have git continue in any case, why not append
> '|| true' to the line that invokes checkpatch in your hook script?

Because I still want to stop the patch application process if a true
error was found.  I just don't want to stop the patch application
process if just a warning was found.

Sarah Sharp
