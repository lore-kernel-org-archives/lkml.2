Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab0DJXx4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 19:53:56 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:52688 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab0DJXxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 19:53:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=oTKwHpOvw+CnZ0dH3ZVmRLxSeZaUmlECqsT+a6EFcZ0lT5SAWI6xiMzXSFb/qY20l8
         W3MlnLghsx2zt2LH/SQmg1cg5DqwtiyCGHY8pIDz5XlD0vcVZV+h1JgO2x6C2TMhLdW3
         +GRUP7D7B4bF96FIJMTbuFhpnMrQIqmEmYLe0=
MIME-Version: 1.0
In-Reply-To: <20100411003529.28fe5c3b@lxorguk.ukuu.org.uk>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> 
	<4BBA6279.20802@redhat.com> <4BBA6B6F.7040201@us.ibm.com> 
	<4BBB36FA.4020008@redhat.com> <1270560931.1595.342.camel@laptop> 
	<20100406145128.6324ac9a@lxorguk.ukuu.org.uk> <4BBB531A.4070500@us.ibm.com> 
	<20100406174459.60088461@lxorguk.ukuu.org.uk> <j2ia36005b51004061034p8c59ecag87c4d90660f33562@mail.gmail.com> 
	<20100411003529.28fe5c3b@lxorguk.ukuu.org.uk>
From: Ulrich Drepper <drepper@gmail.com>
Date: Sat, 10 Apr 2010 16:53:33 -0700
Message-ID: <i2ta36005b51004101653ka0411bc6z5841f35cbd1e41d1@mail.gmail.com>
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive 
	spinning
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 10, 2010 at 16:35, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> You only need one page per 4096 threads

Very expensive.  Each cache line would be fought over by 64 threads.
Constant RFOs make context switches significantly slower.

At most 4096/64 = 64 threads should share one page.  One page would
still cover almost all processes.
