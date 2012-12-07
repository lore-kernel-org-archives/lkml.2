Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424588Ab2LGVKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 16:10:42 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56971 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424546Ab2LGVKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 16:10:40 -0500
Date: Fri, 7 Dec 2012 21:16:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-arch@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Using IO functions across ARM, PPC and Microblaze architectures
Message-ID: <20121207211606.6c5d5bc8@pyramind.ukuu.org.uk>
In-Reply-To: <CAHTX3d+VNDVQjnTnAB=Ywxo7odvNmCPu=wGZ03-xWLecSMsS9A@mail.gmail.com>
References: <CAHTX3d+VNDVQjnTnAB=Ywxo7odvNmCPu=wGZ03-xWLecSMsS9A@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Because I need to use IO functions which will behave
> on arm as little endian and on powerpc as big endian
> and on microblaze depends on endian setting.
> I haven't found any IO function which I could use by 3 architectures
> without using preprocessor macros or runtime detection

Its a rather weird mix. We can do "always big" and "always little"

> 1. Using helper function + preprocessor macros
> (using static inline function also possible)

Then someone comes along and sticks a daughterboard into the system with
the same device the other way around and there are years

> 2. Using function pointers

Probably smarter. 8250.c works this way and it has to handle some
extremely bizarre mappings.
 
> b) Runtime initialization - here is the question if there is
> any standard function which I could use.

Set the pointers up and pass them as data with your platform device, that
way the function definitions are buried in your platform code where they
depend.

Alan
