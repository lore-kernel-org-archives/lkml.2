Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab1DSInl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:43:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36694 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753318Ab1DSInk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:43:40 -0400
Date: Tue, 19 Apr 2011 09:44:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] Implement /dev/byte (a generic byte source similiar
 to /dev/zero)
Message-ID: <20110419094436.0b667410@lxorguk.ukuu.org.uk>
In-Reply-To: <4DAD48FC.5040003@ahsoftware.de>
References: <1303126676-3456-1-git-send-email-holler@ahsoftware.de>
	<BANLkTi=yaXOWnUi2s1A-BtoAFgjExX8q4w@mail.gmail.com>
	<4DAD48FC.5040003@ahsoftware.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As for /dev/zero there are many other possible reasons to use such a 
> device, besides filling something with a value. For me it's as 
> reasonable as dev/zero, just that it offers a bit more flexibility and 
> provides another, at least for me useful, default value. Maybe 
> /dev/nzero would have been a good name too. ;)

/dev/zero exists not to put \0's into files as such but because it is
very useful to be able to map the zero page (a read only, or
copy-on-write blank page) into programs. The mmap is the reason it is
there.

> But I don't really care about inclusion into the kernel, it's just 
> something I had lying around (and needed only marginally work to 
> finalize as a proper patch) and I thought someone else could find it 
> usefull and I should share that here.

Implementationwise I think I would have gone for allocating a new device
and range of 256 minors - that would avoid the funky stuff setting what
it fills with as you'd just fill with the minor number.

Alan
