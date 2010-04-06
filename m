Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab0DFNt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 09:49:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33500 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755828Ab0DFNtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 09:49:23 -0400
Date: Tue, 6 Apr 2010 14:51:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, Darren Hart <dvhltc@us.ibm.com>,
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
Message-ID: <20100406145128.6324ac9a@lxorguk.ukuu.org.uk>
In-Reply-To: <1270560931.1595.342.camel@laptop>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
	<4BBA5305.7010002@redhat.com>
	<4BBA5C00.4090703@us.ibm.com>
	<4BBA6279.20802@redhat.com>
	<4BBA6B6F.7040201@us.ibm.com>
	<4BBB36FA.4020008@redhat.com>
	<1270560931.1595.342.camel@laptop>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Apr 2010 15:35:31 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2010-04-06 at 16:28 +0300, Avi Kivity wrote:
> > 
> > Yes, but that's the best case for spinning.  You could simply use a 
> > userspace spinlock in this case. 
> 
> Userspace spinlocks are evil.. they should _never_ be used.

Thats a gross and inaccurate simplification. For the case Avi is talking
about spinning in userspace makes sense in a lot of environments. Once
you've got one thread pinned per cpu (or gang scheduling >-) ) there are
various environments where it makes complete and utter sense.
