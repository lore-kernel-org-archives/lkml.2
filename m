Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab0HERtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 13:49:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49472 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab0HERs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 13:48:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eM1cKMn56JvjA2V3zTEfXaPMTEbjy2R+v0jNigf/wHVPzp4vrgyzJ7Y+Ig9h/kSOXn
         z4o1YpLZZyzos9E/lW5hRvi/qm35Y/fjxKNDOTg5dFuDj36pBAKfxD7d4bGLuE2yXfBE
         sNVV2zfe/ogQoiSkCWFNsyM/p1ozjYN2v1zsQ=
Subject: Re: [PATCH 1/2] MEMSTICK: fix hangs on unexpected device removal
 in mspro_blk
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <891175.37239.qm@web37607.mail.mud.yahoo.com>
References: <891175.37239.qm@web37607.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 20:48:56 +0300
Message-ID: <1281030536.23959.20.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 01:43 -0700, Alex Dubov wrote: 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: Re: [PATCH 1/2] MEMSTICK: fix hangs on unexpected device removal in mspro_blk
> > > > 
> > > > > Now that del_gendisk syncs, we better
> > > > > start rejecting requests right away.
> > > > 
> > > > 
> > > > I don't quite see why this change is needed. My
> > understanding is, user
> > > > accessible interface should be marked as removed
> > as early, as possible.
> > > 
> > > The problem here is that del_gendisk, syncs the
> > device.
> > > This is new change, made after you did your drivers.
> > > 
> > > I have this problem on jMicron too (which otherwise
> > works fine).
> > The problem is that card check thread explicitly calls
> > ->stop before
> > removing the device.
> > In case of mspro_blk.c that stops the request queue.
> > Attempt to call del_gendisk with stopped request queue
> > hangs due to
> > syncing.
> 
> Well, ok. Sounds good.
> 
> 
> > > 
> > > I have a copy of your ms_block.c.
> > > I would would be very happy if you share with me, what
> > problems does it
> > > still have (besides need of trivial port for changes
> > in block system,
> > > because I want to push it upstream too.
> > > 
> > > I have MS DUO 64M to test it against.
> > > 
> 
> I've got two rather different implementations of ms_block, if I remember
> correctly. Both suffer from random data corruptions, thanks to my
> inexplicable desire to write the state machine as tightly, as possible.
> Only the later one does the spec mandated geometry correctly - I actually
> wrote the first version before I've seen the spec for the first time.

By 'spec mandated geometry' you mean the fact the card needs to be
broken into zones, somewhat like XD?

Best regards,
Maxim Levitsky

