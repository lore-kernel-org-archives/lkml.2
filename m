Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2H2P47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 11:56:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37801 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab2H2P46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 11:56:58 -0400
Date: Wed, 29 Aug 2012 08:56:46 -0700
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jim Meyering <jim@meyering.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] kmemleak: avoid buffer overrun: NUL-terminate
 strncpy-copied command
Message-ID: <20120829154209.GA20836@mwanda>
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
 <1345481724-30108-4-git-send-email-jim@meyering.net>
 <20120824102725.GH7585@arm.com>
 <876288o7ny.fsf@rho.meyering.net>
 <20120828202459.GA13638@mwanda>
 <874nnm6wkg.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874nnm6wkg.fsf@rho.meyering.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 08:28:47AM +0200, Jim Meyering wrote:
> Dan Carpenter wrote:
> > On Fri, Aug 24, 2012 at 01:23:29PM +0200, Jim Meyering wrote:
> >> In that case, what would you think of a patch to use strcpy instead?
> >>
> >>   -		strncpy(object->comm, current->comm, sizeof(object->comm));
> >>   +		strcpy(object->comm, current->comm);
> >
> > Another option would be to use strlcpy().  It's slightly neater than
> > the strncpy() followed by a NUL assignment.
> >
> >> Is there a preferred method of adding a static_assert-like statement?
> >> I see compile_time_assert and a few similar macros, but I haven't
> >> spotted anything that is used project-wide.
> >
> > BUILD_BUG_ON().
> 
> Hi Dan,
> 
> Thanks for the feedback and tip.  How about this patch?
> 

I'm not someone who can approve kmemleak patches, but that's
horrible.  I'm not sure we need a BUILD_BUG_ON(), I was just telling
you the standard way to do a build time assert.  If we did put the
assert in then it should only be in one place in the header file
where the data is decared instead of repeated over and over.

I like strlcpy().  Both strcpy() and strlcpy() will silence your
static checker tool.  strcpy() may be better, but strlcpy() feels
very safe so that might be preferred.

regards,
dan carpenter

