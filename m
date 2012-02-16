Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab2BPO3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:29:52 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59182 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab2BPO3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:29:51 -0500
Date: Thu, 16 Feb 2012 14:31:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] hrtimers: Special-case zero length sleeps
Message-ID: <20120216143132.293c8f50@pyramind.ukuu.org.uk>
In-Reply-To: <20120216142733.GA15632@srcf.ucam.org>
References: <1317308372-6810-1-git-send-email-mjg@redhat.com>
	<alpine.LFD.2.02.1202151537500.2794@ionos>
	<20120215145225.GA21448@srcf.ucam.org>
	<alpine.LFD.2.02.1202152059230.2794@ionos>
	<20120215202221.GA29552@srcf.ucam.org>
	<alpine.LFD.2.02.1202152125500.2794@ionos>
	<20120215203814.GA29795@srcf.ucam.org>
	<alpine.LFD.2.02.1202152140110.2794@ionos>
	<20120215204757.GA30275@srcf.ucam.org>
	<20120216142733.GA15632@srcf.ucam.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Userspace clearly has an expectation that sleep(0) is magic in some 
> ill-defined way. We'd be well within our rights to break that 
> expectation, but I think it's common enough to warrant special casing.

In historical Unix sleep(0) ends up the nearest equivalent it had to
triggering a reschedule and giving up the rest of the timeslice.

I suspect special casing it as yield() isn't far from the right result ?

Alan
 
