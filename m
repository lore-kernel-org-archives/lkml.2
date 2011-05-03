Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1ECLOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 07:14:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50195 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751500Ab1ECLOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 07:14:03 -0400
Date: Tue, 3 May 2011 12:15:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: jimmy.chen@moxa.com, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, wim@iguana.be
Subject: Re: [PATCH 2/2] watchdog: add support for MOXA V2100 watchdog
 driver
Message-ID: <20110503121510.5bba70c5@lxorguk.ukuu.org.uk>
In-Reply-To: <20110503105735.GB2497@pengutronix.de>
References: <20110503103704.69aba5b2@lxorguk.ukuu.org.uk>
	<ECB3782BB8F03341905DD923270296115F720B@mhqms01.moxa.com>
	<20110503105735.GB2497@pengutronix.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm, code in a header? Can't this go into the main source? Hmm, at least
> it87_wdt.c has something very similar. Maybe it can even be shared? What
> about locking BTW?

The spinlock handles it if you look at the caller points, because you
have to own the super I/O and select it each time.


Ultimately it wants to be using request_muxed_* but that isn't in any of
the mainstream code yet so can be done in the future when the mux patches
go in.

Alan
