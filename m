Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab2JOQop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:44:45 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39968 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab2JOQoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:44:44 -0400
Date: Mon, 15 Oct 2012 17:49:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter.Huewe@infineon.com, key@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH] TPM: Let the tpm char device be openable
 multiple times
Message-ID: <20121015174922.31fbadd9@pyramind.ukuu.org.uk>
In-Reply-To: <20121015163945.GA32563@obsidianresearch.com>
References: <20120930233345.GJ30637@obsidianresearch.com>
	<20121010163324.GB5013@ennui.austin.ibm.com>
	<20121012205658.GM4124@obsidianresearch.com>
	<74A44E99E3274B4CB570415926B37D440ED140@MUCSE501.eu.infineon.com>
	<20121015163945.GA32563@obsidianresearch.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2012 10:39:45 -0600
Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:

> On Mon, Oct 15, 2012 at 08:35:09AM +0000, Peter.Huewe@infineon.com wrote:
> > > From: Jason Gunthorpe [mailto:jgunthorpe@obsidianresearch.com] 
> > 
> > > Using open/close is an interesting idea, but it wouldn't work. open()
> > > is coded to return EBUSY if another process has it open, rather than
> > > block, and spinning on open would be unacceptable.
> > 
> > Hmm, maybe write a small pass through program which opens /dev/tpm
> > once and accepts its data via a socket or pipe?
> 
> I believe the kernel should not be enforcing this kind of policy into
> userspace. Plus, some of our embedded system are memory constrained
> so an unnecessary process is not welcome..

Sane device drivers for devices where contention is meaningful block on
an open that is busy, or return an error if the O_NONBLOCK option is
specified. That's the normal case.

Alan
