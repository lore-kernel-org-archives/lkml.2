Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab1KQItH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 03:49:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:52382 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab1KQItF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 03:49:05 -0500
Subject: Re: [PATCH 1/2] lockdep,rtmutex,bug: Show taint flags on error
From: Peter Zijlstra <peterz@infradead.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Ingo Molnar <mingo@redhat.com>, Nick Bowler <nbowler@elliptictech.com>,
        Greg KH <greg@kroah.com>, Dave Jones <davej@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Date: Thu, 17 Nov 2011 09:48:29 +0100
In-Reply-To: <20111116215236.GD3366@decadent.org.uk>
References: <1319773015.6759.30.camel@deadeye>
	 <20111116215236.GD3366@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321519709.27735.13.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 21:52 +0000, Ben Hutchings wrote:
> On Fri, Oct 28, 2011 at 04:36:55AM +0100, Ben Hutchings wrote:
> > Currently lock debugging is disabled when the kernel is tainted, with
> > a few exceptions.  It is already recognised that this can be useful
> > for staging modules (TAINT_CRAP), but that also goes for out-of-tree
> > modules (TAINT_OOT_MODULE) so long as core kernel developers don't
> > have to spend time debugging them.  Also, there are several reasons
> > for tainting that are unlikely to introduce false locking bug reports
> > (e.g. TAINT_FIRMWARE_WORKAROUND).



> > Instead of disabling lock debugging, show the taint flags in all
> > lockdep and rtmutex-debug error messages.


So this is two patches in one. I took the last part, the printing of the
taint flags thing, not the first part.

I did a small patch adding TAINT_FIRMWARE_WORKAROUND to the list of
TAINTS that shouldn't disable lockdep.

As for OOT_MODULE, with staging the only reason not to merge a module is
it being the wrong license and I really can't be arsed about OOT stuff
anyway, so no.
