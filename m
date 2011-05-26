Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab1EZIPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 04:15:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45282 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756421Ab1EZIPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 04:15:50 -0400
Date: Thu, 26 May 2011 09:17:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andreas Bombe <aeb@debian.org>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: tty_lock held during transmit wait in close: still unresolved
Message-ID: <20110526091726.55edf6c3@lxorguk.ukuu.org.uk>
In-Reply-To: <20110525235920.GA5279@amos.fritz.box>
References: <20110525235920.GA5279@amos.fritz.box>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A minimalist way to trigger this issue is with a serial port that has
> nothing attached:
> 
> stty -F /dev/ttyS0 crtscts
> echo >/dev/ttyS0
> 
> The echo triggers a 30 second timeout on close while the driver is
> trying to flush the newline. Another way is developing an USB device
> with a virtual serial port and having it stop (by debugger or
> crash/lockup)...
> 
> Any ideas on how to progress?

Send patches.

At any point you can show the code sleeps you can drop and retake the
tty mutex either side of it, so you should be able to do that in the
close timeout case. You may need to think about the order of locking with
the port mutex but I suspect you can drop and retake both there.

Most use of the mutex (but not quite all) could also be moved to a tty
specific mutex fairly easily once someone has time, but that alone won't
entirely fix your case.

Alan
