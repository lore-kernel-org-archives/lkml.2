Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab2CCRhV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 12:37:21 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36396 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2CCRhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 12:37:20 -0500
Date: Sat, 3 Mar 2012 17:39:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "John G. Heim" <jheim@math.wisc.edu>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: speakup bug
Message-ID: <20120303173916.7eca9391@pyramind.ukuu.org.uk>
In-Reply-To: <BFFDBC9B6BA14BE1AC8E266A3A456A63@hinkle>
References: <BFFDBC9B6BA14BE1AC8E266A3A456A63@hinkle>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Mar 2012 11:18:12 -0600
"John G. Heim" <jheim@math.wisc.edu> wrote:

> I need help fixing a bug in the driver for serial hardware  speech synths in 
> the speakup screen reader. According to the comments in the code, it is in a 
> part of the code that is trying to "steal" the serial port.

Yes - and the code is broken. To start with it's assumig a legacy PC
serial port at 0x3F8 and that it can beat the serial layer to it.

> returns an error code. But it looks as if the region for a serial port, 
> 0x3f8 - 0x3ff,  in ioport_resource cannot be reserved because the entire 
> range from 0x000 through 0xcf7 is already taken by something named "PCI Bus 
> 0000:00".  Therefore calling request_resource always fails and the driver 
> for the speech synth errors out.

It's a heirarchical space, so you can allocate things within it. Look
at /proc/ioports.

> And therefore I can't use my hardware speech synth without modifying the 
> kernel code.  If you comment out the line that checks the return code from 
> request_region, it works. So you have to modify  the kernel code and compile 
> a custom kernel to use a hardware speech synth. That's not such a problem 
> for me but it is for a lot of people. Plus, the grml live CD doesn't work 
> with hardware speech.  That is a problem for me.
> 
> Can anyone tell me how to fix this so it can be patched in the official 
> kernel code?

The proper fix is to make the drivers work via the serial layer properly.
The speakup people have been told this repeatedly for years and years
which is why their drivers work on less and less systems and won't run
with things PCI or USB serial ports, and why they are forever buried in
staging.

Alan
