Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175Ab0HELUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 07:20:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56897 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759028Ab0HELUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 07:20:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=yDihac6m7RY6HlxpzCFYV0Rao6ruaig3IEBXrIXRq+Yx0y2AouzWfTq9kSJnCX3QpL
         zjNrqAvX7s/hfgqpvdLqY3+Wuo6H5uFt77EFyw2yQ0aVBsnmGu8eQYlvDt+tRZwS3qTJ
         ux4P8KiEbMi14HAS2C5GBqY8d+i1BdARqoiaM=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <952321.94696.qm@web37608.mail.mud.yahoo.com>
References: <952321.94696.qm@web37608.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 14:20:45 +0300
Message-ID: <1281007245.8617.15.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 01:30 -0700, Alex Dubov wrote: 
> > Maxim Levitsky wrote: 
> > > On Wed, 2010-08-04 at 00:57 -0700, Alex Dubov wrote: 
> > > > I see two immediate problems with this patch:
> > > > 
> > > > 1. On cosmetic level, custom debug macros should
> > not be employed. Device
> > > > core already have this functionality (dynamic
> > debug levels and such). Please,
> > > > use dev_dbg and friends for print-outs.
> > > This allows much easier control for debug.
> > > Single module parameter is enough to adjust it.
> > > This helps me help users.
> > > (Eg, kernel compilation is out of question)
> 
> I doubt it will be that useful, but it's not my call to make anyway.
> 
> 
> > > 
> > > 
> > > > 
> > > > 2. On a structural level, I'd rather prefer host
> > drivers to not start their
> > > > own threads. If you look at both current host
> > implementations, they operate
> > > > in callback fashion. Apart from saving some
> > resources, this reduces the
> > > > amount of problems encountered during
> > suspend/resume and shutdown.
> > > This isn't possible.
> > > Hardware doesn't support interrupts on memstick bus
> > changes, it only
> > > supports DMA done from/to internal FIFO, and DMA it
> > only possible for
> > > 512 byte TPCs.
> > > 
> > 
> 
> How depressing.
> 
> > 
> > Another question.
> > 
> > I see that current code ignores MEMSTICK_CAP_AUTO_GET_INT
> > Instread mspro_blk.c enables this capability for parallel
> > mode, assuming
> > that hw supports it. Its true in my case, but might not be
> > true in other
> > cases.
> > I think I should fix that, right?
> 
> This is mandated by the spec. INT should be available automatically in
> parallel mode, and some hardware does it in serial as well.
> 
> > 
> > Also I see that you bath
> > TPC_READ_LONG_DATA/TPC_READ_LONG_DATA
> > Does that mean that every HW sector is larger that 512?
> > If so, you are doing copy on write, right?
> > I have small caching in my sm_ftl of last sector. It helps
> > performance a
> > lot.
> 
> 
> That's how its called in the spec.
> Sectors can be larger than 512b on Pro-HG sticks, and there's additional
> TPC_READ/WRITE_QUAD_DATA which operates on larger quantities.
But not on ordinary PRO, right?

Small question, can I use Pro-HG stick in my reader that is designed for
Standard/PRO only? Does your subsystem support it?

8-bit mode really isn't supported here, but it is optional I am sure.

> 
> > 
> > 
> > Also I want to clarify that the only kind of interrupts
> > supported by hw
> > (besides usual card detection interrupt), is DMA done
> > interrupt.
> > Thats why I have to use thread.
> > Doing polling in r592_submit_req (which runs in atomic
> > context is just
> > cruel).
> 
> Yes, I see you have a timed wait there.
> 

Alex, how should I proceed in merge of my driver?
Do you have any objections against it now?

Best regards,
Maxim Levitsky

