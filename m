Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab1GAOSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:18:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37985 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756598Ab1GAOSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:18:39 -0400
Date: Fri, 1 Jul 2011 15:20:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and
 control characters in printk()
Message-ID: <20110701152051.763fd594@lxorguk.ukuu.org.uk>
In-Reply-To: <20110701125411.GA21551@albatros>
References: <20110626182628.GA20158@elte.hu>
	<20110626190622.GB4217@albatros>
	<20110626194618.GA21740@elte.hu>
	<20110626202518.GA4915@albatros>
	<20110626220126.GA24004@elte.hu>
	<20110627083633.GA5846@albatros>
	<20110627104058.45e93c41@pyx>
	<20110627183829.GA16033@albatros>
	<BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com>
	<20110701120059.GL20990@elte.hu>
	<20110701125411.GA21551@albatros>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> $ dmesg | tail
> ...
> [16291.982492] init[21579]: segfault at 0 ip 00007f527186028a sp 00007fff08251dd8 error 4 in libc-2.11.1.so[7f52717d8000+17a000]
> [16379.001357] fail[21586]: segfault at 0 ip 00007f332831028a sp 00007fffc52de568 error 4 in libc-2.11.1.so[7f3328288000+17a000]
> $ 
> (see 1234 => init change)
> 
> As you see here, the previous log entry was showed not as it was
> initally logged.  Core dump message was chosen fully arbitrary, just to
> show that some specific part of it can be "edited".

Your syslog daemon appears to need improvement and that would be the
right fix for dmesg etc.

The other case is the actual printk direct to console case, particularly
on a serial port. That one actually has more potential for actual
annoyance.



