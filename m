Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761522Ab0J2QYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 12:24:55 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55647 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab0J2QYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 12:24:54 -0400
Date: Fri, 29 Oct 2010 17:24:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Cc: linus.walleij@stericsson.com, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
Message-ID: <20101029172443.61f7b067@pyx>
In-Reply-To: <AANLkTinj93zAXJAipB3HjE62Xa1Z=9k9gPBxaT=+MLtg@mail.gmail.com>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com>
	<20101022135130.617f0ce8@lxorguk.ukuu.org.uk>
	<AANLkTinj93zAXJAipB3HjE62Xa1Z=9k9gPBxaT=+MLtg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; i686-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The reason is that the work is generated so often that a work is not
> finished before next work of same type comes. This is especially true
> for transmit and receive. Then I get 0 back when queuing the work and
> there is no real way to solve it from what I can see than to allocate
> new work structures every time.

So if that is the case what bounds your memory usage - can a busy box end
up with thousands of work queue slos used ? It sounds like your model is
perhaps wrong - if there is a continual stream of work maybe you should
simply have a kernel thread to handle it if it cannot be deferred
- remember ldisc code is able to sleep in most paths.

