Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab2KILC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:02:59 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45600 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab2KILC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:02:57 -0500
Date: Fri, 9 Nov 2012 11:08:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jongman.heo@samsung.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How to debug system freeze  (not detected by kernel debug
 options)
Message-ID: <20121109110807.3e09fcfc@pyramind.ukuu.org.uk>
In-Reply-To: <574089.21861352427573311.JavaMail.weblogic@epml01>
References: <574089.21861352427573311.JavaMail.weblogic@epml01>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Nov 2012 02:19:33 +0000 (GMT)
Jongman Heo <jongman.heo@samsung.com> wrote:

> 
> Dear kernel hackers,
> 
> I have a problem in SMP environment, in x86 platform (Intel Atom based embedded system)
> 
> In UP, there is no issue, but in SMP, system freezed in tens of minutes (or shorter), if I perform IO test with flash memory and HDD simultaneously (using dd).
> 
> I enabled relevant kernel debug options, like LOCKDEP, DETECT_SOFTLOCKUP, DETECT_HUNG_TASK, along with "nmi_watchdog=1".
> (Yeah, this is somewhat old kernel, 2.6.35.14).
> 
> But no debug message is shown. (I had checked that NMI interrupt count correctly increase.).
> 
> Do you have any thoughts what can cause system freeze without being detected by LOCKDEP, watchdog, and other options.

Hardware problems, firmware bugs, PATA controller hangs, some
classes of PCI device hang, certain cases where for some reason the crash
is so bad the kernel can't get the message out even though it has detected
the failure.

A good starting point is probably "can you make two identical systems do
it". If you've got a pair of boards which fed the same software set and
have the same flash and hdd crash in the same way its unlikely to be a
faulty board.

You may find it useful to make the NMI timeout handler trigger a directly
detectable event via an I/O port if your platform has a buzzer or LED
directly I/O mapped somewhere.

Failing that the fastest approach may be to use hardware debugging aids
if you have access to them for that platform.

Alan
