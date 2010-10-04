Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab0JDMdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 08:33:11 -0400
Received: from www.tglx.de ([62.245.132.106]:38568 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744Ab0JDMdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 08:33:09 -0400
Date: Mon, 4 Oct 2010 14:34:47 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
        "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/5] uio: Implement hotunplug support, using libunload
Message-ID: <20101004123447.GB9961@silverbox.local>
References: <20100917205946.GF2522@local>
 <m139t451b4.fsf_-_@fess.ebiederm.org>
 <20100924104555.GC1819@silverbox.local>
 <m1hbhfcbdo.fsf@fess.ebiederm.org>
 <20100924173106.GA4966@silverbox.local>
 <m14ode662q.fsf@fess.ebiederm.org>
 <20100925003308.GA29910@suse.de>
 <m1wrqa4mg5.fsf@fess.ebiederm.org>
 <20100926192142.GA7252@kroah.com>
 <m1iq1s86jk.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1iq1s86jk.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 03:49:03PM -0700, Eric W. Biederman wrote:
> 
> With this change it is possible to remove a module that implements
> a uio device, or to remove the underlying hardware device of a uio
> device withot crashing the kernel, or causing user space more problems
> than just an I/O error.

Well, that I/O error can also be a segfault if userspace accesses
memory previously mmap'ed. So a userspace program needs to properly
handle -EIO from read(), and has to handle SIG_SEGV. This should also
be mentioned in Documentation/DocBook/uio-howto.tmpl.
Or do you have a better solution?

Thanks,
Hans

