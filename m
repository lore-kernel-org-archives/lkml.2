Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab1HTQXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 12:23:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39598 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752969Ab1HTQXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 12:23:19 -0400
Date: Sat, 20 Aug 2011 17:21:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: mikeci@acm.org
Cc: "Jiri Slaby" <jslaby@suse.cz>, <linux-kernel@vger.kernel.org>
Subject: Re: Possible bug in 8250.c
Message-ID: <20110820172156.1ece472c@lxorguk.ukuu.org.uk>
In-Reply-To: <29681.1313801904@sonic.net>
References: <29681.1313801904@sonic.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So in first iteration, interrupt is cleared, and in second, function will execute:
> 
>           } else if (end == NULL)
>                         end = l;
> 
> which will terminate the loop, but the return code will be IRQ_RETVAL(0).

If you are getting an extra IRQ when then chip itself is indicating no
IRQ then the IRQ is spurious. That probably means you have a problem
elsewhere - eg the IRQ controller being misconfigured between level/edge
triggered.

Alan
