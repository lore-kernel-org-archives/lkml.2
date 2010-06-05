Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab0FEBQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 21:16:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54931 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab0FEBQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 21:16:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OG0S7PWdNHzSDovi8NTatPwyFIU3QjnSjZMbL1iAyMPVOuMiAopy8QU6mWlPlIrEVQ
         RXEsDMAGwNNbPF09fagfrk3/uKn2V/tM7C0FJ5SIZ8GqWUXVRafOSRJDW1BIcQWo9RqW
         5NCuNdf6y5POhNlS9/2CgwnSDEZAY0z/hPJQs=
Subject: Re: [SUSPECTED SPAM] Re: [linux-pm] Proposal for a new algorithm
 for reading & writing a hibernation image.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: Pavel Machek <pavel@ucw.cz>, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
In-Reply-To: <4C099E8C.7070302@crca.org.au>
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com>
	 <1275694775.3853.29.camel@maxim-laptop>  <4C09930E.20306@crca.org.au>
	 <1275698169.10045.8.camel@maxim-laptop>  <4C099E8C.7070302@crca.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Jun 2010 04:16:09 +0300
Message-ID: <1275700569.18384.12.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> If the memory it writes to isn't protected, there'll be no recursive 
> page fault and no problem, right? I'm imagining this page fault handler 
> will only set a flag to record that the page needs to be atomically 
> copied, copy the original contents to a page previously prepared for the 
> purpose, remove the write protection for the page and allow the write to 
> continue. That should be okay, right?
I think so, although I have no experience yet to comment on such things.
Despite that I think you might run out of 'page previously prepared for
the purpose'
However you can adopt a retrial process, like you do today in tuxonce.
Just abort suspend, and do it again.

> 
> > Of course the sucky part will be how to edit the page tables.
> > You might need to write your own code to do so to be sure.
> > And this has to be arch specific.
> 
> Yeah. I wondered whether the code that's already used for creating page 
> tables for the atomic restore could be reused, at least in part.
This is very dangerous.
The code might work now, and tomorrow somebody will add a code that does
memory writes.
The point is that you must be sure that there are no recursive faults,
or somehow deal with them (this is probably too dangerous to even think
of)


> 
> > Since userspace is frozen, you can be sure that faults can only be
> > caused by access to WO memory or kernel bugs.
> 
> Userspace helpers or uswsusp shouldn't be forgotten.
This is especially bad. because a fault in userspace will mean swapping.
You won't get away with custom page fault for this.
You could assure before suspend that all relevant userspace is not
swapped, or forget about userspace, because its minor thing compared to
speed increases of full memory write.


Best regards,
Maxim Levitsky


