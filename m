Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab1CWKHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:07:45 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:35465 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932464Ab1CWKHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:07:10 -0400
Date: Wed, 23 Mar 2011 11:07:07 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] checkpatch: add option to change warning return value.
Message-ID: <20110323100707.GC2297@cmpxchg.org>
References: <20110322231310.GA7338@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322231310.GA7338@xanatos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 04:13:10PM -0700, Sarah Sharp wrote:
> There are a lot of warnings in checkpatch.pl that are rather subjective.
> For instance, when a line is 81 characters long, and the patch submitter
> is just cleaning up existing code, a maintainer may not care that
> checkpatch.pl warns about the over 80-character line.  It should be up to
> the maintainer what warnings they want to pay attention to.
> 
> Unfortunately, if you try to run checkpatch.pl as part of a git pre-commit
> hook and a patch in a series being applied by git-am fails checkpatch.pl,
> the whole process stops.  At that point I usually end up just disabling
> that git hook, which means I don't see real errors in the patches.
> 
> Add an option to checkpatch.pl to print the warnings, but not return an
> error code when the --lazy flag is present.  (Anyone with a better name
> can pipe up, lazy just seemed to be the opposite to strict.)  This allows
> the maintainer to view the warnings, but still allow the patch application
> process to continue.

I first thought you would add code that allowed turning only select
errors into warnings.

If you just want to have git continue in any case, why not append
'|| true' to the line that invokes checkpatch in your hook script?

	Hannes
