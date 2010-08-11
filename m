Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab0HKIcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 04:32:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50921 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab0HKIcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 04:32:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OCK+uK+HX2y5gP8e1phpdDLfkeg+S2apl/2LlOJTRFmCjlOXEH7aCnQv+Zqn+LKi5z
         KSs9M2epC0ZO4OYMTa9VIm9/mw9ep/AbOWLmQmVo8FN6NIoXaxO+YzR3/dC+kF0krhKu
         wE104rXX8AGld+3FvTbVjTWIYwmwIprCVL/BA=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <199584.21009.qm@web37604.mail.mud.yahoo.com>
References: <199584.21009.qm@web37604.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 11:32:04 +0300
Message-ID: <1281515524.21459.14.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-11 at 01:08 -0700, Alex Dubov wrote: 
> > I know everything you have just said.
> > I just want to point out that code in many places assumes
> > that register
> > window is the same as set on device initialization.
> 
> It's not.
> Can you please point at a particular place?
> 
> > > But, if you're using the auto incrementing write, you
> > will have to write
> > > extra register for every page transferred.
> > But what if I fill extra register with 0xFF?
> > And besides on reads, the fact that I *write* the extra
> > register before
> > I execute read command shouldn't matter at all regardless
> > of what I
> > write there.
> > On writes however I *do* need to write extra register
> > anyway with proper
> > values.
> > 
> > Therefore I see no reason why I can't set write window to
> > cover both
> > param and extra register, and leave it always like that.
> 
> Because when you do autoincrementing write you _can not_ write into param register. You will break the command execution.
Thanks, I finally understand you, so you are objection to write of
_param_ register, not the _extra_.
I agree with you.


> 
> On the other thought, it may be unnecessary to write unique extra data to every page, so one full register write at the beginning of the command may do. Considering, that legacy memstick is not going to evolve, this may be reasonable assumption.
Indeed that what I do now.
Maximum I might need to clear page status bits, but I can do that later
after I write the block.
This won't be any performance impact because amount of bad pages
shouldn't be normally greater that zero.
(Otherwise there will be data loss...)

One interesting thing that I just want your opinion on is what to do
with correctable errors.
Common sense suggests to relocate the sector + and mark it bad.
But I don't know how common such sectors are, and thus I could do more
harm that good by marking too many sectors as bad.

Of course all such problems are reason why today flash devices contain
the FTL inside, and can improve/define it in the way they want.

No more questions for now, thank you very much for help.

I hope I create ms_block.c soon, and put that old problem to the rest.

As time permits I will also port your driver for xD portion of jMicron
device (which I have).

Best regards,
Maxim Levitsky



