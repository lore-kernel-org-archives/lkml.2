Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab1I3Jsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 05:48:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59529 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754563Ab1I3Jsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 05:48:41 -0400
Date: Fri, 30 Sep 2011 10:47:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: IIO (+ more general?) Error condition handling (e.g. wire fell
 out errors)
Message-ID: <20110930104707.0645afda@lxorguk.ukuu.org.uk>
In-Reply-To: <4E858F5A.5000901@cam.ac.uk>
References: <4E858F5A.5000901@cam.ac.uk>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 3) Consider these out of band (from the out of band event data)
> and look at other options for reporting them.

Treat it like a socket/pipe perhaps - if it "goes down" then report it as
having hung up and deliver a SIGPIPE or similar and with an appropriate
error code for those catching it (-EIO ?)

That generally gets noticed.

> Is there anything general out there for reporting hardware failures
> that would be appropriate?  Sometime these conditions are the sort
> of thing that should cause a siren to go off.
> They might be sensor failure

There are two things here - one is making sure the app notices (where we
have equivalent handling in other interfaces) the other is what to do
about it. We don't have a general framework for reporting system
component failure. That's something that ought to get fixed generally to
report everything from "that new nasty smell was formerly your hard disk"
to a sensor fail.

> (p.s. I hope no one is using the current driver for trains, though
> that might explain British trains...)

Tssh... there is Linux on UK trains, but it's usually driving annoying
announcement/video systems.

Alan
