Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab1LFPlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 10:41:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49998 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142Ab1LFPlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 10:41:09 -0500
Date: Tue, 6 Dec 2011 15:42:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, ben@decadent.org.uk,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] lockdep, bug: Exclude
 TAINT_FIRMWARE_WORKAROUND from disabling lockdep
Message-ID: <20111206154206.441e85c6@lxorguk.ukuu.org.uk>
In-Reply-To: <20111206151345.GA22353@elliptictech.com>
References: <tip-xopopjjens57r0i13qnyh2yo@git.kernel.org>
	<20111206151345.GA22353@elliptictech.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Dec 2011 10:13:45 -0500
Nick Bowler <nbowler@elliptictech.com> wrote:

> On 2011-12-06 01:38 -0800, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  df754e6af2f237a6c020c0daff55a1a609338e31
> > Gitweb:     http://git.kernel.org/tip/df754e6af2f237a6c020c0daff55a1a609338e31
> > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > AuthorDate: Mon, 14 Nov 2011 13:13:49 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Tue, 6 Dec 2011 08:16:47 +0100
> > 
> > lockdep, bug: Exclude TAINT_FIRMWARE_WORKAROUND from disabling lockdep
> > 
> > It's unlikely that TAINT_FIRMWARE_WORKAROUND causes false
> > lockdep messages, so do not disable lockdep in that case.
> > We still want to keep lockdep disabled in the
> > TAINT_OOT_MODULE case:
> > 
> >   - bin-only modules can cause various instabilities in
> >     their and in unrelated kernel code
> > 
> >   - they are impossible to debug for kernel developers
> > 
> >   - they also typically do not have the copyright license
> >     permission to link to the GPL-ed lockdep code.
> 
> This is all bogus.  We have a proprietary module taint for the above.
> Out of tree does not mean "bin-only", "non-GPL" or anything else like
> that.  

It also stops people developing drivers of their own who are not
building them in the kernel tree currently (eg when I'm building tests
of the GMA500 graphics driver). This is a ludicrous patch and should be
reverted

Alan

