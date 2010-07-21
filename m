Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab0GUELB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:11:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875Ab0GUELA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:11:00 -0400
Date: Tue, 20 Jul 2010 21:10:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Lynch <ntl@pobox.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Davide Libenzi <davidel@xmailserver.org>, stable@kernel.org
Subject: Re: [PATCH] signalfd: fill in ssi_int for posix timers and message
 queues
Message-Id: <20100720211018.e586c7ce.akpm@linux-foundation.org>
In-Reply-To: <1279683859.3030.121.camel@localhost>
References: <1278117528.21917.354.camel@localhost>
	<20100720154205.667e95aa.akpm@linux-foundation.org>
	<1279683859.3030.121.camel@localhost>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010 22:44:19 -0500 Nathan Lynch <ntl@pobox.com> wrote:

> > So it's not 100% obvious that this change is desirable.  Does the
> > functionality which this patch adds justify the introduction of these
> > problems?
> 
> I think the change is desirable in that no user of the interface could
> reasonably expect the current behavior with respect to the ssi_int
> field, and that it reconciles signalfd's behavior with its design
> intentions.  On the other hand, I noticed this discrepancy only because
> I was cribbing signalfd's data structures for checkpoint/restart, not
> because I am aware of any application that is affected, nor was I able
> to find one using Google's code search.  It would be highly speculative
> of me to say that no application depends on the current behavior, but it
> is difficult to imagine a correctly functioning application that depends
> on it.

It's not a matter of a current application depending on current
behaviour!  The problem is that an application written in 2018 which
depends on the _new_ behaviour will not work on 2.6.34.

It wouldn't be the worst thing we've ever done to our long-suffering
users, but it is a permanent cost of having screwed things up :(
