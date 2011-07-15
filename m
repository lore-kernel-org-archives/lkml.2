Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965261Ab1GOJx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 05:53:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33764 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964982Ab1GOJx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 05:53:28 -0400
Date: Fri, 15 Jul 2011 10:55:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Waychison <mikew@google.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Allow disabling of sys_iopl, sys_ioperm
Message-ID: <20110715105557.7cb3dfcc@lxorguk.ukuu.org.uk>
In-Reply-To: <CAGTjWtD+5cZxQiE+tikUyz2SNgm3bR95GE2veevEv15cPX1E9A@mail.gmail.com>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
	<1310675693-9204-2-git-send-email-mikew@google.com>
	<20110714234248.7ed43534@lxorguk.ukuu.org.uk>
	<CAGTjWtDHH_VXXAsh5WPspTwPEhzcKi4_Jno7w=jReiS7HSALQw@mail.gmail.com>
	<20110715000037.3fc1670a@lxorguk.ukuu.org.uk>
	<CAGTjWtA5qobWAZb=SbM1y5SFtDKPuJVuAsbDKmkaxxL7mA6OKg@mail.gmail.com>
	<20110715003912.149dcedd@lxorguk.ukuu.org.uk>
	<CAGTjWtD+5cZxQiE+tikUyz2SNgm3bR95GE2veevEv15cPX1E9A@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So lets turn the question around a moment - what breaks if you simply
> > take CAP_SYS_RAWIO away from everything ?
> >
> 
> Alright, I see your point.   ISTR that CAP_SYS_RAWIO was required for
> accessing block devices directly, but this doesn't seem to be the
> case.

Its needed for certain kinds of command issue (raw commands) but not I
believe raw block I/O

> I think the approach I'll try next is to try and drop it with
> PR_CAPBSET_DROP from early userspace's init.
> 
> Any other vectors you would suggest to keep the kiddies away?

/dev/mem /dev/kmem (which do have options to clamp down on)
module loading you have down

GPU if you don't need any graphics. Not so much because its a specific
threat area but because its a large exposure.

For media there are exploit paths to consider where an attacker rewrites
the boot media and reboots. If you need raw disk I/O those are a spot
harder to mend.

