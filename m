Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab0I3LLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:11:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33928 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751754Ab0I3LLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:11:11 -0400
Date: Thu, 30 Sep 2010 12:35:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Marc - A. Dahlhaus" <mad@wol.de>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, isdn@linux-pingi.de
Subject: Re: [PATCH] Fix capi devicenames
Message-ID: <20100930123537.165375de@lxorguk.ukuu.org.uk>
In-Reply-To: <1285843077.748.32.camel@marc>
References: <4CA391B3.1030806@wol.de>
	<20100930103010.1a6a7785@lxorguk.ukuu.org.uk>
	<1285843077.748.32.camel@marc>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The Documentation doesn't even represent what is in the code right now.
> kernelcapi.ko creates /dev/capi as the capi control device
> and /dev/capi[0-9]+ for the applications. Documentation states the
> Devices are /dev/capi20 and /dev/capi20.[0-9]+ for applications.

Ok that much needs sorting out.

> Because of this udev removed the possibility to change devicenodes to new names without
> keeping the kernels suggested devicenode name. I hope i got this right.

Not my problem. Udev can do what it likes

> So IMO the documentation is wrong. And also the kernelcapi module is
> wrong about that node it creates.

The problem is that the current default naming is ABI. The fact someone
screwed it up years ago and never fixed it merely makes it worse. At the
very least we need to sort out what the naming should be and support
*both* sets of names for a while. That would I think be an acceptable
path.

> I just want that it works with the latest upstream sources out of the
> box and this isn't the case right now.

That is fine, but I also want it to work on whatever random setups people
have had for the past ten years and on other distros which may be using
the kernel default names.

If we really do have a mess of that scale here then we need to follow the
proper sequence of things for obsoleting an interface, and that is

- Document it
- Add the new one
- Wait a long time
- Remove the old one

Alan
