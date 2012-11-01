Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2KANN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 09:13:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34582 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2KANNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 09:13:54 -0400
Date: Thu, 1 Nov 2012 13:18:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: joeyli <jlee@suse.com>
Cc: Takashi Iwai <tiwai@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121101131849.752df6fd@pyramind.ukuu.org.uk>
In-Reply-To: <1351743715.21227.95.camel@linux-s257.site>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	<20121029174131.GC7580@srcf.ucam.org>
	<s5hobjia6vj.wl%tiwai@suse.de>
	<20121031173728.GA18615@srcf.ucam.org>
	<s5h390utqv3.wl%tiwai@suse.de>
	<1351743715.21227.95.camel@linux-s257.site>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think it make sense because the private key is still protected by
> signer. Any hacker who modified firmware is still need use private key
> to generate signature, but hacker's private key is impossible to match
> with the public key that kernel used to verify firmware.
> 
> And, I afraid we have no choice that we need put the firmware signature
> in a separate file. Contacting with those company's legal department
> will be very time-consuming, and I am not sure all company will agree we
> put the signature with firmware then distribute.

Then you'd better stop storing it on disk because your disk drive is FEC
encoding it and adding a CRC 8)

It does want checking with a lawyer but my understanding is that if you
have a file which is a package that contains the firmware and a signature
then there is not generally a problem, any more than putting it in an RPM
file - it's packaging/aggregation. This should be referred to the Linux
Foundation folks perhaps - no point designing something badly to work
around a non existant issue.

Also the interface needs to consider that a lot of device firmware is
already signed. Nobody notices because they don't ever try and do their
own thus many drivers don't need extra signatures in fact.

Alan
