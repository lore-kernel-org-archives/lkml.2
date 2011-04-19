Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab1DSPxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 11:53:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41380 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752827Ab1DSPxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 11:53:34 -0400
Date: Tue, 19 Apr 2011 16:54:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command [3/3]
Message-ID: <20110419165429.71cb1508@lxorguk.ukuu.org.uk>
In-Reply-To: <4DADA581.9060700@aknet.ru>
References: <20110224132906.GA15733@redhat.com>
	<4D6675B0.2010700@aknet.ru>
	<20110224153221.GA22770@redhat.com>
	<4D94A788.1050806@aknet.ru>
	<20110331170244.GA13271@redhat.com>
	<4D99D6E6.4070008@aknet.ru>
	<20110404160351.GA23655@redhat.com>
	<4D9A24A0.5050105@aknet.ru>
	<20110405151549.GB17490@redhat.com>
	<4D9B4265.6080403@aknet.ru>
	<20110405164557.GA23248@redhat.com>
	<4DADA22A.1010205@aknet.ru>
	<20110419155830.7ad33312@lxorguk.ukuu.org.uk>
	<4DADA581.9060700@aknet.ru>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The use case is to daemonize the process with threads.
> You first need to detach it from its parent, then use TIOCNOTTY
> ioctl to detach from the tty (TIOCNOTTY_GRP doesn't seem
> to exist too, though, but might be easy to implement).
> There are a few workarounds to that that I am aware of,
> but what exactly interfaces do you have in mind? I have
> found nothing that allows to do the same without a workarounds
> like this:
> https://lkml.org/lkml/2011/4/8/278
> The current way of detaching, which is a fork/exit combo,
> loses all threads, so, when you call daemon() and you had
> threads, you are a toast.

Yes - you need to detach then create the threads.

The reason I ask is you appear to add overhead to various hot paths and
you add 48 bytes to each task struct if I read the code right. Thats half
a megabyte on a server running a pile of java gunge !

Alan
