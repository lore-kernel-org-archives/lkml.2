Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab1GAOrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:47:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56509 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756921Ab1GAOrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:47:36 -0400
Date: Fri, 1 Jul 2011 15:49:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
Message-ID: <20110701154947.133c30f5@lxorguk.ukuu.org.uk>
In-Reply-To: <20110701143757.GA22567@albatros>
References: <20110626165409.GA2584@albatros>
	<20110626182628.GA20158@elte.hu>
	<20110626190622.GB4217@albatros>
	<20110626194618.GA21740@elte.hu>
	<20110626202518.GA4915@albatros>
	<20110626220126.GA24004@elte.hu>
	<20110627083633.GA5846@albatros>
	<20110627104058.45e93c41@pyx>
	<20110627183829.GA16033@albatros>
	<BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com>
	<20110701143757.GA22567@albatros>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  of the multiline feature.  Intoducing new "%S" format for single lines
>  makes little sense as there are tons of printk() calls that should be
>  already restricted to one line.

You don't need a new format string surely. Your expectation for printk is 

"multiple new lines are cool providing they are in the format string"

So that bit isn't hard to deal with, 

You make vprintk take an extra arg (trusted/untrusted args)
You make printk pass 'untrusted'
You make %s quote the arguments for control codes if untrusted is set but
you don't mangle format string controls.

End of problem ?

At which point your attacker has more work to do but given a long string
yawns and stars using the right number of spaces for the likely 80 col
screen :)



