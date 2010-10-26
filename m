Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729Ab0JZCIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:08:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64364 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab0JZCIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:08:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=niRnqvJAHiz7Y21y0wz5Zwq8EX1A6ZjfMtAu/GioGWGNVLREfFYAH44YZk/Ook0fUy
         xk5uqGCzWW9LAbBkU5lEjiPjbNvkFTil6DoE9X9YyuR4eSxM8519QGSptll6RC3gF3OE
         tD7W00KmiDYOsud3OsTdctDRnqWigMCKsNsKk=
Subject: Re: [PATCH 14/29] memstick: remove the memstick_set_rw_addr
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <659114.61656.qm@web37608.mail.mud.yahoo.com>
References: <659114.61656.qm@web37608.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 04:08:32 +0200
Message-ID: <1288058912.4024.137.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 08:55 -0700, Alex Dubov wrote:
> 
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 14/29] memstick: remove the memstick_set_rw_addr
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > Remove this function, what was
> > last user that did send the MS_TPC_SET_RW_REG_ADRS
> > directly.
> > 
> > Just invalidate the register window, and next register
> > read/write will send that tpc automaticly.
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> 
> How is an obscure invalidate_reg_window function is any better than
> explicit set_rw_addr? Total number of calls to either of them is exactly
> the same.
Nope.
I just set the reg window where it should be: in register read/write
functions.
Here we tampered with register window by using another card structure,
so we invalidate it. Simple.
The point is that I send the register window update just before register
read/write, and optionaly skip that if cached version matches the one I
need.


> 
> Sony state machine diagrams suggest that doing a precise set_rw_addr when
> necessary is a good thing. 
And that exactly what I am doing.
I am setting that window just before a register read/write.


> The feature was originally conceived because
> Sony intended to manufacture MSIO and hybrid devices, which might have very
> large number of registers (hundreds). It was also supposed to help with
> backward compatibility of devices, as well as with DRM functionality
> 
> We know, at this point of time, that Sony is sort of loosing the format
> war, so MSIO devices these days are very hard to come by. However, some
> hybrid (Transfer Jet) and DRM-secured devices still exist and it is wise
> to retain functionality which can help to operate those (I don't have full
> details on their operation, but it doesn't mean we should forget them
> outright).


Best regards,
	Maxim Levitsky


