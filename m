Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab0DUOxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 10:53:16 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:26341 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab0DUOxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 10:53:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WvP4vLmoY/YSMohLLSf6OdWpmSbN2Lj6T+G+i2zXfPeTiYMEL8vh3n7o58Bc7Nwdwe
         aobYN7uUe2kpHBz8qt74Pm8dIM2nWG4Pke36kEFzviMfePrEigyhlWNQ+jBgs33O8CPz
         B1fptus+BT7FCKd3T21UlYfILensHOkf8AyBU=
Subject: Re: [PATCH v3] lockdep: Make MAX_STACK_TRACE_ENTRIES configurable.
From: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <alpine.LFD.2.00.1004211407510.4506@localhost.localdomain>
References: <alpine.LFD.2.00.1004161329030.11320@localhost.localdomain>
	 <alpine.LFD.2.00.1004161727000.11320@localhost.localdomain>
	 <alpine.LFD.2.00.1004191841230.6259@localhost>
	 <20100420140941.d085007d.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1004211309560.6646@localhost>
	 <1271849823.1776.87.camel@laptop>
	 <alpine.LFD.2.00.1004211407510.4506@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 07:53:01 -0700
Message-ID: <1271861581.29617.13.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 14:12 +0200, John Kacur wrote:
> 
> On Wed, 21 Apr 2010, Peter Zijlstra wrote:
> 
> > On Wed, 2010-04-21 at 13:12 +0200, John Kacur wrote:
> > > 
> > > Certain configurations that have LOCKDEP turned on, run into the limit
> > > where the MAX_STACK_TRACE_ENTRIES are too small. Rather than simply
> > > turning of the locking correctness validator let the user configure this
> > > value to something reasonable for their system.
> > 
> > I'm not sure its worth having a CONFIG_ value for this, that'll just be
> > yet another random value nobody knows what to do with.
> > 
> > Do you actually have a machine that reproduces this? Can you see how
> > many classes, avg stacktraces per class and the avg entries per
> > stacktrace there are?
> 
> This triggers every single time when I boot my T500 laptop with 
> 2.6.33.2-rt13 with lots of debug options enabled. The problem is not
> specific to this kernel though.
> 

Working from ancient memory here:

I think that this is seen more on the distro side - had the same problem
with SLERT. 

And yes, it did show up more with additional debug options -- when
structs with #ifdef DEBUG_XXX are populated.

IIRC there is another caveat, if MAX_STACK_TRACE_ENTRIES is too large,
you run out of memory uncompressing the Kernel (on 32 bit only?) and it
hangs.

We put patches in place to manually increase to something workable, but
I would ACK this change, allowing tinkering.

Regards,

Sven

