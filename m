Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab0KDUym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 16:54:42 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:56126 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab0KDUyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 16:54:40 -0400
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2010 16:54:40 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:from:to
	:cc:in-reply-to:references:content-type:date:message-id
	:mime-version:content-transfer-encoding; q=dns; s=sasl; b=vT+5ma
	L6PfXSeytwC7TjePJldoFCrLzHIrDl1w0VmzU7d6DcsXherWhY82MGtv+3lGly2h
	oyoRhs+QbJab6V/QCFsAXyjxmwL6F9AdMuDVvttn0SzDbNpYFeNb+/PwDWCuyZlq
	b9TKkd8Rj1W9kx74q7bg0oLvOWv8MoRF+0fFI=
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
From: Nathan Lynch <ntl@pobox.com>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kapil@ccs.neu.edu, gene@ccs.neu.edu
In-Reply-To: <4CD26270.5050906@kernel.org>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
 <4CD08419.5050803@kernel.org>  <20101102214706.GA28593@lst.de>
 <1288835258.6132.56.camel@tp-t61>  <4CD26270.5050906@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 15:45:37 -0500
Message-ID: <1288903537.2897.28.camel@tp-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 80800626-E854-11DF-A0B6-B53272ABC92C-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-04 at 08:36 +0100, Tejun Heo wrote:
> Hello,
> 
> On 11/04/2010 02:47 AM, Nathan Lynch wrote:
> >>   In this case whitelisting the allowed
> >> state by requiring special APIs for all I/O (or even just standard
> >> APIs as long as they are supposed by the C/R lib you're linked against)
> >> is the more pragmatic, and I think faithful aproach.
> > 
> > I don't think users will go for it.  They'll continue to use dodgy
> > out-of-tree kernel modules and/or LD_PRELOAD hacks instead of porting
> > their applications to a new library.  I think a C/R library is an
> > "ideal" solution, but it's one that nobody would use - especially in
> > HPC, unless the library somehow provides better performance.
> 
> I hear that there are plans to integrate one of the userland
> snapshotting implementations with HPC workload manager.  ISTR the
> combination to be condor + dmtcp but not sure.  I think things like
> that make a lot of sense.

If you look at the C/R implementations of those two projects you'll see
that they don't implement what I take to be hch's suggestion - a library
or platform with special-purpose APIs to which applications are ported
in order to gain C/R ability.  For all their good points, the projects
you mention do interposition for glibc's syscall wrappers and provide a
few optional hooks so apps can control certain aspects of C/R.


