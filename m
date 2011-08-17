Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1HQRZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:25:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35766 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753624Ab1HQRZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:25:29 -0400
Date: Wed, 17 Aug 2011 14:37:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, lennart@poettering.net,
        linux-man@vger.kernel.org, roland@hack.frob.com,
        torvalds@linux-foundation.org
Subject: Re: +
 prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision .patch
 added to -mm tree
Message-ID: <20110817143728.7abc955b@lxorguk.ukuu.org.uk>
In-Reply-To: <CAPXgP10A4rcQLht--h1d3PJE=oOrm=MSjGXTUSKVF+ssnkt_gw@mail.gmail.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org>
	<20110817115543.GA8745@redhat.com>
	<20110817130531.GA12204@redhat.com>
	<CAPXgP10A4rcQLht--h1d3PJE=oOrm=MSjGXTUSKVF+ssnkt_gw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> Why would it? Systemd can serialize its state and properly re-exec
> itself as many times as needed during its lifetime. Why would the
> kernel take something away from a process, which it explicitly asked
> for?

Because a re-exec is a change of context, in the same was as a re-exec
closes some file handles kills alarms, adjusts signals etc. Across an
suid boundary of course it gets even more important.

Why would the kernel allow a parent process, possibly with a different
security context, to muck with defined and guaranteed standards compliant
behaviour it may rely upon.

> Hmm, I don't see why that would be necessary. It's just one of our
> parents that aks for our signals.

I think it is fundamentally the wrong answer. The behaviour in question
is in every Unix since day one and apps rely upon it.

Now I can see why you want to know when processes exit and do it without
tampering with the process, but it seems to me that's simply a question
of us lacking a way to do this nicely, whether inotify/dnotify/etc
on /proc, some kind of 'also signal me' property or some kind of process
event interface.

Of those a signal based one seems the weakest because programmers and
signal often don't mix well because it is asychronous and also because it
wouldn't naturally allow multiple users (eg a process monitoring tool and
systemd to share)

For that matter your init process could farm them back out down a named
pipe or some other such interface and do the monitoring in userspace.

Alan
