Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab1H3J6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 05:58:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52719 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750768Ab1H3J6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:58:38 -0400
Date: Tue, 30 Aug 2011 10:56:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Kyle Moffett <kyle@moffetthome.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFD: x32 ABI system call numbers
Message-ID: <20110830105637.35f9e46e@lxorguk.ukuu.org.uk>
In-Reply-To: <m2ty8znzoz.fsf@firstfloor.org>
References: <4E582577.2060805@zytor.com>
	<CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com>
	<4E582EAA.1040108@zytor.com>
	<CA+55aFxdRMxWLh1B_8v29qFafM425uH7kbYRfqoPe3TpVwOx-w@mail.gmail.com>
	<CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.gmail.com>
	<4E584492.5090406@zytor.com>
	<CA+55aFw8+fkwjgAYOzxnO1HY3uCBCuf+N6z1XX2m=FhSjD5Wqg@mail.gmail.com>
	<CAMuHMdXhdg6GuJqSjK5SdKBrBzZwGYus2LH1yqgkSnSEp8ZXyg@mail.gmail.com>
	<CA+55aFzuY+U0nf58-9P5CFaYAPKMQ3fQMGGUUkjbxRRCK7=A3Q@mail.gmail.com>
	<CAGZ=bqKjnsEKz_CxcW+wRoCL_CY-kipedf2wB=BVUWRB0427tw@mail.gmail.com>
	<m2ty8znzoz.fsf@firstfloor.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The only programs which really care are those which map many gigs
> > of stuff into memory (IE: big databases, etc). 
> 
> You mean anything that mmaps a file?
> 2-3GB is not a whole lot these days.

For most stuff its a lot, and most apps that mmap files mmap the bits
they need. O_LARGEFILE and 64bit time_t do make sense though.

> 2Gb is a very similar thing as Linus y2038, just you're much more
> likely to hit it.

Also if using a 64bit time_t means less compat gunge it makes things much
easier. At that point 32bit time_t becomes a userspace/library thunking
problen.

> IMHO the only excuse right now for 32bit is to use it in a JIT
> that can dynamically expand the pointer. Or for old binaries.

Or for a lot of code which runs way faster in 32bit pointer mode. Less
memory, smaller cache footprint.

Alan
