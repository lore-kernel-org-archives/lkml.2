Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab1F0JnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 05:43:15 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58252 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646Ab1F0Jlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 05:41:32 -0400
Date: Mon, 27 Jun 2011 10:40:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
Message-ID: <20110627104058.45e93c41@pyx>
In-Reply-To: <20110627083633.GA5846@albatros>
References: <20110623152137.GA2536@albatros>
	<20110626103915.GB11093@elte.hu>
	<20110626165409.GA2584@albatros>
	<20110626182628.GA20158@elte.hu>
	<20110626190622.GB4217@albatros>
	<20110626194618.GA21740@elte.hu>
	<20110626202518.GA4915@albatros>
	<20110626220126.GA24004@elte.hu>
	<20110627083633.GA5846@albatros>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Go back and read what I said originally, and think about it.

You have to look at the IUTF bit of the relevant console you are logging
to.

As far as I can see we need:

No IUTF: block various control codes + CSI
IUTF: block various control codes only

But arbitarily blocking anything non ASCII is going to make a mess in
anything non American. Even English needs UTF-8.

Alan
