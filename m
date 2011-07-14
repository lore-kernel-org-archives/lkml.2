Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab1GNXEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 19:04:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43708 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932437Ab1GNXEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 19:04:37 -0400
Date: Fri, 15 Jul 2011 00:00:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Waychison <mikew@google.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Allow disabling of sys_iopl, sys_ioperm
Message-ID: <20110715000037.3fc1670a@lxorguk.ukuu.org.uk>
In-Reply-To: <CAGTjWtDHH_VXXAsh5WPspTwPEhzcKi4_Jno7w=jReiS7HSALQw@mail.gmail.com>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
	<1310675693-9204-2-git-send-email-mikew@google.com>
	<20110714234248.7ed43534@lxorguk.ukuu.org.uk>
	<CAGTjWtDHH_VXXAsh5WPspTwPEhzcKi4_Jno7w=jReiS7HSALQw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > a) you can do this with a security module
> 
> I can?   How?   The whole LSM approach seems intractable to me.

It would certainly need some trivial tweaking (to be specific we'd need
to move from capable(x) to capable_syscall(x, syscall_code) for those
interfaces that mattered, but that would probably be a good thing anyway
from the point of view of beating the capability model into something more
flexible and would help stuff like SELinux as well I think.

We have an underlying separation of security from the other details - we
really should keep it clean that way.

Alan
