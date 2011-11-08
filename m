Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab1KHNYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 08:24:53 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36886 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730Ab1KHNYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 08:24:49 -0500
Date: Tue, 8 Nov 2011 13:23:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Eric Paris <eparis@parisplace.org>,
        kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to
 /proc/interrupts
Message-ID: <20111108132326.214bcaf8@lxorguk.ukuu.org.uk>
In-Reply-To: <20111108091121.GA10198@albatros>
References: <20111107192915.GA4690@albatros>
	<CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com>
	<4EB83674.3040207@zytor.com>
	<20111107201120.GA5775@albatros>
	<4EB843FF.5080201@zytor.com>
	<CA+55aFwYGivYFZTLprSB+oDm3E4MG0s3PEQabs166v6YRL5u-Q@mail.gmail.com>
	<4EB84F05.1000704@zytor.com>
	<CA+55aFxFNaRuTx-0vx+RhrkavrcNDiDh5jxcRyWPy8-QZHGD9A@mail.gmail.com>
	<20111107232132.2c6880a5@lxorguk.ukuu.org.uk>
	<20111107232750.GA4854@kroah.com>
	<20111108091121.GA10198@albatros>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> /proc/{interrupts,stat} are 0444, which may be used by local attacker to
> learn statistical information about user's keystrokes, including the
> passwords.

So the distro can chmod it 0400

> /dev/pts/* and /dev/tty* leak the same timing information in inode's
> atime and mtime.

That one is trickier. I don't think it is a real leak because the last
update timing info is in seconds granularity so is pretty useless for
that. The atime/mtime behaviour is however required ABI and used by
applications so can't simply go away.

> Do we want to restrict permissions of interrupts/stat and remove atime
> and mtime from ttys and relax these permissions when revoke() is introduced?

revoke makes no difference I can see to either of these, they appear to
be a completely unrelated discussion.
