Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab2BBOw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 09:52:26 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49021 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab2BBOwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 09:52:25 -0500
Date: Thu, 2 Feb 2012 15:52:20 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: rcu warnings cause stack overflow
Message-ID: <20120202145219.GD9071@somewhere.redhat.com>
References: <20120201100652.GA2922@osiris.boeblingen.de.ibm.com>
 <20120201151445.GA6731@somewhere.redhat.com>
 <20120202122742.GA2745@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202122742.GA2745@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 01:27:42PM +0100, Heiko Carstens wrote:
> On Wed, Feb 01, 2012 at 04:14:48PM +0100, Frederic Weisbecker wrote:
> > > Removing the WARN_ON_ONCE will fix this and, if lockdep is turned on, still
> > > will find illegal uses. But it won't work for lockdep off configs...
> > > So we probably want something better than the patch below.
> > 
> > Ah ok. Hmm, but why are you using an exception to implement WARN_ON()
> > in s390? Is it to have a whole new stack for the warning path in order
> > to avoid stack overflow from the place that called the WARN_ON() ?
> 
> The reason was to reduce the code footprint of the WARN_ON() and also
> be able to print the register contents at the time the warning happened.

Ah ok, makes sense.

> 
> All architectures which define __WARN_TAINT implement warnings with
> exceptions. Currently that are parisc, powerpc, s390 and sh.
> 
