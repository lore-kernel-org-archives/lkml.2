Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab0DFQuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:50:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34009 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753224Ab0DFQuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:50:01 -0400
Date: Tue, 6 Apr 2010 17:53:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhltc@us.ibm.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive
 spinning
Message-ID: <20100406175311.11e5d3a8@lxorguk.ukuu.org.uk>
In-Reply-To: <4BBB5CEF.6060803@redhat.com>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
	<4BBA5305.7010002@redhat.com>
	<4BBA5C00.4090703@us.ibm.com>
	<4BBA6279.20802@redhat.com>
	<4BBA6B6F.7040201@us.ibm.com>
	<4BBB36FA.4020008@redhat.com>
	<1270560931.1595.342.camel@laptop>
	<4BBB3A15.6020502@redhat.com>
	<1270562948.1595.442.camel@laptop>
	<4BBB5CEF.6060803@redhat.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That works for the uncontended case.  For the contended case, the waiter 
> and the owner have to go into the kernel and back out to transfer 
> ownership.

If you insist on doing it that way yes, but knowing the lock owner is
likely to be away for a while also lets you do things like punt work
either by picking another work package in the meantime, or by queueing
the work you can't do on a list the pre-empted lock owner will review
before dropping the lock.

