Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab1C3UYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 16:24:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38132 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932906Ab1C3UYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 16:24:07 -0400
Date: Wed, 30 Mar 2011 21:24:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Palmer <me@danielpalmer.co.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PATA_ARTOP reads byte from PCI IO port without mapping it to
 the right address.
Message-ID: <20110330212440.794e85de@lxorguk.ukuu.org.uk>
In-Reply-To: <4D93890A.60307@danielpalmer.co.uk>
References: <4D937FDC.4090607@danielpalmer.co.uk>
	<20110330202628.5dc8db5f@lxorguk.ukuu.org.uk>
	<4D93890A.60307@danielpalmer.co.uk>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 20:48:26 +0100
Daniel Palmer <me@danielpalmer.co.uk> wrote:

> 
> >  That is the PCI port address.
> 
> I don't pretend to understand most of this fully.
> On the board the PCI address space/PCI controller is apparently at 
> 0xfe240000
> So I guess that when that byte is read it should read from 0xfe240000 + 
> 0x1400?
> That doesn't happen and a read happens at 0x1400 and an oops results.
> I don't know enough to point the finger really.
> 
> There are probably only 2 people using this board still too. So I doubt 
> it really matters. :)

That sounds like the inb() function has been broken by a change perhaps
by some related board change - if your I/O is mapped as you describe I'd
expect inb() to be implemented as something like


	return *(volatile u8 *)(0xfe2400 + addr)

Might be worth bisecting between a good and bad release as it ought to be
easy to find

Alan
