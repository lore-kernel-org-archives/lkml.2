Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab0IMQgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:36:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48028 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0IMQgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:36:44 -0400
Date: Mon, 13 Sep 2010 17:33:22 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: florian@mickler.org, x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86: don't compile with gcc-3.3.3
Message-ID: <20100913163322.GA3819@n2100.arm.linux.org.uk>
References: <1284366708-30154-1-git-send-email-florian@mickler.org> <1284367195.2275.29.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284367195.2275.29.camel@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 10:39:55AM +0200, Peter Zijlstra wrote:
> On Mon, 2010-09-13 at 10:31 +0200, florian@mickler.org wrote:
> > hpa commented on bug 16506[1] :
> > "Please note that gcc-3.3.3 is known broken on x86; gcc-3.4 is the oldest
> > version which is known to *not* be broken."
> > 
> > References: 
> > 	[0]: https://bugzilla.kernel.org/show_bug.cgi?id=16633
> > 	[1]: https://bugzilla.kernel.org/show_bug.cgi?id=16506#c28
> > 
> > If that is indeed so, we should abort the build? No?
> 
> Does it in fact still build with 3.4? I seem to recall some talk about
> pushing the minimum version to 4.x for x86, although I can't remember
> where..

I'm still building kernels with gcc 3.4.3 (for the ARMs which don't
require a later compiler) or gcc 4.3.2+patches for those which do.

ARM gcc 3.4.3 is certainly noticably faster than gcc 4.3.2 even on
x86 - and as long as ARM gcc 3.4.3 works, and there's not great pain
in allowing it to build the arch-independent stuff, I see no reason
to deny it across the entire kernel build.

I think we should have a minimum compiler version for the generic
kernel, and individual minimum compiler versions for the architectures,
so that arches can specify a higher minimum compiler version if they
have specific problems there.
