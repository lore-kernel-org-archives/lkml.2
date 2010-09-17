Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab0IQKNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 06:13:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50764 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751284Ab0IQKNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 06:13:07 -0400
Date: Fri, 17 Sep 2010 11:33:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH 1/7] notify userspace about time changes
Message-ID: <20100917113325.147734b6@lxorguk.ukuu.org.uk>
In-Reply-To: <1284675049-23479-2-git-send-email-virtuoso@slind.org>
References: <1284675049-23479-1-git-send-email-virtuoso@slind.org>
	<1284675049-23479-2-git-send-email-virtuoso@slind.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Certain userspace applications (like "clock" desktop applets or cron) might
> want to be notified when some other application changes the system time. It
> might also be important for an application to be able to distinguish between
> its own and somebody else's time changes.

A program that cannot work out if it or someone else changed the time is
very very broken indeed !

> This patch implements a notification interface via eventfd mechanism. Proccess
> wishing to be notified about time changes should create an eventfd and pass it
> to time_change_notify() syscall along with notification options.

This seems complete overkill and it doesn't really help applications much
that I can see because of suspend/resume.

What are your actual use cases ?

Clocks apps don't care because they check the actual time so notice it
shfited. Cron and anacron appear to contain the needed internal handling.

Anything sleeping until a time occurs maybe ? In which case its a lot
simpler and cleaner than events to provide a new itimer which wakes the
process when the wall time hits the time specified in the timer.

Alan
