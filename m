Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab2JWJ4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:56:32 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49934 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab2JWJ4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:56:30 -0400
Date: Tue, 23 Oct 2012 11:01:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Min Zhang <mzhang@mvista.com>
Cc: gregkh@linuxfoundation.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: 8250 check iir rdi in interrupt
Message-ID: <20121023110133.62bed522@pyramind.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.02.1210221633450.28146@nightowl>
References: <alpine.LFD.2.02.1210221633450.28146@nightowl>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Added module parameter skip_rdi_check to opt out this workaround.

NAK. Anything like this should be runtime.

> Tested on Radisys ATCA 46XX which uses FPGA 16550-compatible and
> other generic 16550 UART. It takes from an hour to days to reproduce by
> pumping inputs to serial console continously using TeraTerm script:

You turn this on by default but it's a nasty IRQ latency penalty
on a lot of x86 platforms with the uarts on the lpc bus.

What I am not clear on from this is

- do you see it on both the ports (the bug that is)
- if you do see it on both are you sure its not in reality a symptom of
  some other console/irq handling race ?

Alan
