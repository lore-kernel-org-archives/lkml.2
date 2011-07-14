Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab1GNXhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 19:37:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37986 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932590Ab1GNXhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 19:37:37 -0400
Date: Fri, 15 Jul 2011 00:39:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Waychison <mikew@google.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Allow disabling of sys_iopl, sys_ioperm
Message-ID: <20110715003912.149dcedd@lxorguk.ukuu.org.uk>
In-Reply-To: <CAGTjWtA5qobWAZb=SbM1y5SFtDKPuJVuAsbDKmkaxxL7mA6OKg@mail.gmail.com>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
	<1310675693-9204-2-git-send-email-mikew@google.com>
	<20110714234248.7ed43534@lxorguk.ukuu.org.uk>
	<CAGTjWtDHH_VXXAsh5WPspTwPEhzcKi4_Jno7w=jReiS7HSALQw@mail.gmail.com>
	<20110715000037.3fc1670a@lxorguk.ukuu.org.uk>
	<CAGTjWtA5qobWAZb=SbM1y5SFtDKPuJVuAsbDKmkaxxL7mA6OKg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In my case, I simply don't want these "features", which is why I took
> the compile time approach to turning this stuff off.  I realize that
> these syscalls (and the /dev/port interface) are not comprehensive (I
> didn't say they were either).  I'm happy though to take suggestions

Indeed - but from the point of view of doing the job to a standard for
an upstream kernel there ought to be a meaningful testable definition of
what the security shift you achieve is.

> for stuff I probably should be disabling considering my goal of making
> it difficult for root to compromise a system.  And yes, modules are
> disabled :)

If you have CAP_SYS_RAWIO and some of the other interfaces you only think
it is - the kiddies toolkits already include out of the box direct module
loading hacks (in fact its fairly easy if you've got GPU PCI access to
just put the module into video memory so that only the patching needs to
be done and the module internal addresses are all fixed and can be
arranged on a suitably convenient target address)

So really there needs to be a definition of what you are trying to
achieve. My own guess is that for

	"Disallow direct access paths to hardware"

the actual answer is 'revoke RAWIO' and then give it back to very
specific selected code in very specific selected ways or possibly in some
cases where rawio is needed for stuff that shouldn't be by writing new
driver bits to provide the proper interface that we are lacking ?

So lets turn the question around a moment - what breaks if you simply
take CAP_SYS_RAWIO away from everything ?
