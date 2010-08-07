Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab0HGUWx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 16:22:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50661 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab0HGUWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 16:22:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RUcRzR+USluKy0u++Q6vtKJJN8wlnzp1khs/trwiesqYM33+U0Zm8l0GuZXYzTW/+e
         bkc2Lt02c8HcJiZC8E9fvNeT+NJGR2D/OhjE/S7a75URLTWveX09jwLbSHzWr82KQ1AU
         Gc8MdBDWKo49Kfc7Nohk+hRVhKZcBpVN2SuhY=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <952321.94696.qm@web37608.mail.mud.yahoo.com>
References: <952321.94696.qm@web37608.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 23:22:45 +0300
Message-ID: <1281212565.3300.20.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have few more questions about memsticks.

First of all, I need an explanation of overwrite flag.
You already explained it to me once, but I still not sure about few
things.



#define MEMSTICK_OVERWRITE_UDST  0x10
This one I understand, thinking about xD again, I think it is very
handy.

My idea (from xD of course) is that copyonwrite is done this way:

1. read old sector
2. allocate new sector
2. write what was just read to new sector.
3. erase old sector.

Could you explain when I need to set and reset the
MEMSTICK_OVERWRITE_UDST?


#define MEMSTICK_OVERWRITE_PGST1 0x20
#define MEMSTICK_OVERWRITE_PGST0 0x40
I suppose these indicate that page(sector) contains incorrect data, just
like in xD there is page status?
Again, better explanation is welcome.
Also, should I touch that flag when I update sector?



#define MEMSTICK_OVERWRITE_BKST  0x80
This marks bad blocks?



Another question is about write of oob data.
When I write it, overwrite flag is updated, or I need to use
MEMSTICK_CP_OVERWRITE to update it?
I think former is true.

When I write a sector, I just write 0 to management flag, right?


And last question,
If I use MEMSTICK_CP_BLOCK, can I start reading a block from non-zero
page offset?


And surely last question, what is 'MS_CMD_BLOCK_END'


Thanks again for all help so far,

Best regards,
Maxim Levitsky

