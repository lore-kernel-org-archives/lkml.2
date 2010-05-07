Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab0EGQZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:25:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:44117 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab0EGQZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:25:06 -0400
Subject: Re: [PATCH 4/4] futex: Add FUTEX_LOCK with optional adaptive
 spinning
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Ulrich Drepper <drepper@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Avi Kivity <avi@redhat.com>
In-Reply-To: <alpine.LFD.2.00.1005071818380.3401@localhost.localdomain>
References: <1273127060-30375-1-git-send-email-dvhltc@us.ibm.com>
	 <1273127060-30375-5-git-send-email-dvhltc@us.ibm.com>
	 <alpine.LFD.2.00.1005071818380.3401@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 18:24:51 +0200
Message-ID: <1273249491.1642.360.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 18:20 +0200, Thomas Gleixner wrote:
> +               if (!owner->oncpu)

can't do that, that relies on __ARCH_WANT_UNLOCKED_CTXSW

Please keep the code as near mutex_spin_on_owner() as possible.

