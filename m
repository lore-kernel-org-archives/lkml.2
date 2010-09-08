Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab0IHRgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 13:36:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39299 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751469Ab0IHRgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 13:36:10 -0400
Date: Wed, 8 Sep 2010 18:56:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Lowe <nick.lowe@gmail.com>
Cc: Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org
Subject: Re: AMD Geode NOPL emulation for kernel 2.6.36-rc2
Message-ID: <20100908185605.55671889@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTi=U40mzeMh-UJJy=ggVDry2qDWW-MYYyBhS_Kex@mail.gmail.com>
References: <fmbxh-5N8-41@gated-at.bofh.it>
	<55BC9463-95B9-4034-AA1E-55042D6E9354@gmail.com>
	<201009081115.15544.hpj@urpla.net>
	<AANLkTi=U40mzeMh-UJJy=ggVDry2qDWW-MYYyBhS_Kex@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If a process crashes because of NOPL usage, you get the feedback loop to fix it.

Trouble is that means rebuilding entire distributios, who don't
neccessarily care about Geode. We had the same problem before with cmov
and the VIA processors, GCC programmers didn't read the Intel PPro
manual and got it wrong but it was the end users who suffered, and most of
them were not in a position to rebuild their distro (and every security
update, and test them all ...) and their distro didn't care.

So lots of people ran a kernel with a CMOV hack in it - never got
mainstream which is unfortunate because if it had it would have helped
a lot more people and had the hole in it fixed.

> The beauty of open source is that we can recompile to correct the bad
> assumption; the latest version of binutils (GAS) finally corrects the
> bad semantic that generic i686 includes NOPL.

And the reality is that this won't happen. Yes you can do it but it's an
enormously slow and inefficient way to tackle the problem.

So the patch (corrected) makes complete sense.

Alan
