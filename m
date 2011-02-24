Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab1BXL0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 06:26:47 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43373 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756195Ab1BXL0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 06:26:45 -0500
Date: Thu, 24 Feb 2011 11:29:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Timur Tabi <timur@freescale.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How important is it that tty_write_room doesn't lie?
Message-ID: <20110224112902.71047445@lxorguk.ukuu.org.uk>
In-Reply-To: <20110223202915.GB9081@suse.de>
References: <4D656679.90907@freescale.com>
	<20110223202915.GB9081@suse.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think that people don't normally hit this as the console code isn't
> used as a tty and a console at the same time, right?

And also on most hardware that it doesn't actually matter.

The underlying logic is that printk output is important, and Linus has
always insisted that what matters is that it gets out, even with
collateral damage be that vt output mangling or serial losses.

If it's an actual problem in your environment you could do a bit of quiet
internal buffering (or report less than you really have if your fifo
queue is big)

Alan
