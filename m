Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab1KNPEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 10:04:20 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58311 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717Ab1KNPET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 10:04:19 -0500
Date: Mon, 14 Nov 2011 15:05:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Ilya Zykov <ilya@ilyx.ru>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH v3 2/2] TTY: tty flip buffer optimisation.
Message-ID: <20111114150523.2abdf7a1@lxorguk.ukuu.org.uk>
In-Reply-To: <4EC124EB.4050203@suse.cz>
References: <4EC10DC6.8070807@ilyx.ru>
	<4EC124EB.4050203@suse.cz>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, the results are indeed nice. However is there any *real* load other
> than this tailor-made microbenchmark where the added code complexity is
> worth it?

I'm wondering if we need the complexity in the first place. Certainly 256
does seem a bit small for pty/tty traffic. A 'real world' benchmark would
be an ls -lR / on a machine with a fast graphics card or in console mode

ie

ls -lR /		# prime cache
time ls -lR /

and there are cases where people do a lot of traffic over a pty like this
so I don't think it's entirely fake.

I don't like the complexity but we could certainly go from using 256 byte
buffers to "tty->buf.bufsize" and make it configurable without
that complexity.

Alan
