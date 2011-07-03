Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab1GCVI0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 17:08:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45818 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751212Ab1GCVIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 17:08:23 -0400
Date: Sun, 3 Jul 2011 22:10:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
Message-ID: <20110703221031.15cc2278@lxorguk.ukuu.org.uk>
In-Reply-To: <CA+55aFz08cObjcHxxZ-FQexP56hwHvML+c+UULQitKMum3MoTA@mail.gmail.com>
References: <20110626190622.GB4217@albatros>
	<20110626194618.GA21740@elte.hu>
	<20110626202518.GA4915@albatros>
	<20110626220126.GA24004@elte.hu>
	<20110627083633.GA5846@albatros>
	<20110627104058.45e93c41@pyx>
	<20110627183829.GA16033@albatros>
	<BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com>
	<20110701143757.GA22567@albatros>
	<20110701154947.133c30f5@lxorguk.ukuu.org.uk>
	<20110703100131.GA2472@albatros>
	<CA+55aFz08cObjcHxxZ-FQexP56hwHvML+c+UULQitKMum3MoTA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That said, if we really want to do this, I think doing it with %s
> filtering is the only way, and it would make the default case where
> people really don't think about possible user-supplied strings be
> safe.
> 
> So saying "%s is for pure 7-bit ASCII with no control codes" is
> annoying, but would really fix it.

It's fairly easy for the console in question to provide a filter but 7bit
ascii wouldn't be a bad default for a printing console, definitely a
wrong default for the log file though.

> That said, I think it should be unconditional. None of this "safe vs
> unsafe" flags, and none of this "printk format strings are different
> from other vsprintf format strings". If special characters are a
> potential security problem for printk(), then they are a potential
> security problem for other things (eg /proc filenames or content etc).

In which case we can't do it because we need \n in proc content so that's
a complete and utter non starter. In addition we have things with
filenames in it and filenames are unicode so we'd break apps that look
filenames up via /proc for things like monitoring.

It depends how much you care as well - any idiot can figure out how to
simply use spaces and/or tabs to build multiple lines of fake looking
output like say a spoofed Oops.

As Lars can no doubt remind people spoofing oopses can be fun ;)

Alan
