Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab0DFUC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 16:02:58 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48854 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab0DFUCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 16:02:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=pdkPj0pMp4B23dXwXpajTANRUzNGu1UvS165hGEfKiBbkpLq1op4O9dqrl5Cy77SSJ
         IDVP9zVENg4XdiXdeWtJ7mDd277zwxoCx08bnOSRIscCx5z86HiCXtHbhgl8hEHqAndi
         FBlYgKvg/YaT5IY9eegWIpb35dbmXAfRlCLqY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004062024560.32352@localhost.localdomain>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> 
	<4BBA5C00.4090703@us.ibm.com> <4BBA6279.20802@redhat.com> 
	<4BBA6B6F.7040201@us.ibm.com> <4BBB36FA.4020008@redhat.com> 
	<1270560931.1595.342.camel@laptop> <20100406145128.6324ac9a@lxorguk.ukuu.org.uk> 
	<4BBB531A.4070500@us.ibm.com> <20100406174459.60088461@lxorguk.ukuu.org.uk> 
	<alpine.LFD.2.00.1004062024560.32352@localhost.localdomain>
From: Ulrich Drepper <drepper@gmail.com>
Date: Tue, 6 Apr 2010 13:02:28 -0700
Message-ID: <y2qa36005b51004061302t53bccf60v2cc152e7c64b20ca@mail.gmail.com>
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive 
	spinning
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Darren Hart <dvhltc@us.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
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

On Tue, Apr 6, 2010 at 12:31, Thomas Gleixner <tglx@linutronix.de> wrote:
> We need to figure out a more efficient way to
> do the spinning in the kernel where we have all the necessary
> information already.

Really?  The owner information isn't in general available in the
kernel.  Futex operation doesn't require the value used to be the PID
(or negative of the PID).  That is a dramatic limitation of the
usefulness of futexes.

At userlevel there is access to other fields of the data structure
which can contain the owner information.

I would like to see the method using a per-thread pinned page and an
update of a memory location on scheduling.  For benchmarking at least.
 I agree that a sys_yield_to() syscall would be at the very least
useful as well.  But it's useful for other things already.
