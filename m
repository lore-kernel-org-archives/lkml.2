Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab1GCTxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 15:53:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52899 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab1GCTxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 15:53:13 -0400
Date: Sun, 3 Jul 2011 23:53:06 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Joe Perches <joe@perches.com>
Cc: kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [kernel-hardening] Re: [RFC v1] implement SL*B and stack
 usercopy runtime checks
Message-ID: <20110703195306.GA9714@albatros>
References: <20110703111028.GA2862@albatros>
 <CA+55aFzXEoTyK0Sm-y=6xGmLMWzQiSQ7ELJ2-WL_PrP3r44MSg@mail.gmail.com>
 <20110703185709.GA7414@albatros>
 <CA+55aFwuvk7xifqCX=E3DtV=JCJEzyODcF4o6xLL0U1N_P-Rbg@mail.gmail.com>
 <20110703192442.GA9504@albatros>
 <1309721875.18925.30.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309721875.18925.30.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 03, 2011 at 12:37 -0700, Joe Perches wrote:
> On Sun, 2011-07-03 at 23:24 +0400, Vasiliy Kulikov wrote:
> > Btw, if the perfomance will be acceptable, what do you think about
> > logging/reacting on the spotted overflows?
> 
> If you do, it might be useful to track the found location(s)

Sure.


> and only emit the overflow log entry once as found.

Hmm, if consider it as a purely debugging feature, then yes.  But if
consider it as a try to block some exploitation attempt, then no.
I'd appresiate the latter.


> Maybe use __builtin_return_address(depth) for tracking.

PaX/Grsecurity uses dump_stack() and do_group_exit(SIGKILL);  If setup,
it kills all user's processes and locks the user for some time.  I don't
really propose the latter, but some reaction (to at least slowdown a
blind bruteforce) might be useful.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
