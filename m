Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab0IWVAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:00:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53115 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752337Ab0IWVAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:00:23 -0400
Date: Thu, 23 Sep 2010 22:23:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: markh@compro.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: line BRK detection on ttyS0
Message-ID: <20100923222326.543f3365@lxorguk.ukuu.org.uk>
In-Reply-To: <4C9BBD0E.4010804@compro.net>
References: <4C9A5AD0.5070804@compro.net>
	<20100923010329.0a66546c@lxorguk.ukuu.org.uk>
	<4C9BBD0E.4010804@compro.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010 16:48:14 -0400
Mark Hounschell <markh@compro.net> wrote:

> On 09/22/2010 08:03 PM, Alan Cox wrote:
> > On Wed, 22 Sep 2010 15:36:48 -0400
> > Mark Hounschell <markh@compro.net> wrote:
> > 
> >> Does the kernel support sending a SIGINT from a line BRK on ttyS0 to a thread of a process
> >> where the process has a controlling terminal that is NOT ttyS0 and the thread is using ttyS0
> >> in a cfmakeraw mode? I see doc that implies that ttyS0 must be the controlling terminal but
> >> can my thread have a controlling terminal while my main process has it's own ?
> > 
> > If they have two different ttys open then yes at least as far as Linux is
> > concerned. I don't know how glibc handles it as it can do signal groups
> > and the like and delivery of signals to process not threads etc.
> > 
> > You can see parity anyway. In PARMRK mode you get \377 \0 [whatever] for
> > parity/break etc but \377 is also doubled for a real one - ie \377 \377
> > 
> 
> \377 \0  or  [whatever] just looks like valid data to my thread though.

If you have PARMRK mode set then you need to parse the data stream. If
you see \377 \0 then you know it is control information because any \377
received from the other device will be passed to you as \377\377

> So you're saying it's gonna be a glibc thing and not a kernel thing that
> prevents my thread from getting a signal?

I'm saying you need to ask glibc people - I'm not sure exactly how they
set up the posix signals for threads, and posix thread signalling is
fairly demented.

Alan
