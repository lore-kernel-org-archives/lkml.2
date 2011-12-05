Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab1LEOfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 09:35:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46789 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932215Ab1LEOfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 09:35:15 -0500
Date: Mon, 5 Dec 2011 14:36:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: melwyn lobo <linux.melwyn@gmail.com>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Borislav Petkov <bp@amd64.org>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: x86 memcpy performance
Message-ID: <20111205143608.76f3781a@lxorguk.ukuu.org.uk>
In-Reply-To: <CAHSGOuvJsJr3r+RwM0+733BQJO6hsK0iP0ZNzRoycWX3YHwE0A@mail.gmail.com>
References: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com>
	<20110812195220.GA29051@elte.hu>
	<20110814095910.GA18809@liondog.tnic>
	<6296.1313462075@turing-police.cc.vt.edu>
	<20110816121604.GA29251@aftab>
	<4E5FA18A.7010205@gmail.com>
	<CAHSGOuvJsJr3r+RwM0+733BQJO6hsK0iP0ZNzRoycWX3YHwE0A@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Will AVX work on Intel ATOM. I guess not. Then is this now not the
> time for having architecture dependant definitions for basic cpu
> intensive tasks

It's pretty much a necessity if you want to fine tune some of this.

> > If you want to speed up memcpy, I think your best bet is to find out why it's
> > so much slower when src and dst aren't 64-byte aligned compared to each other.

rep mov on most x86 processors is an extremely optimised path. The 64
byte alignment behaviour is to be expected given the processor cache line
size.

Alan
