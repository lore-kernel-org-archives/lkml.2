Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab0HHUJI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 16:09:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55478 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab0HHUJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 16:09:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=r45X3snA8L5wYCHS1LZzoxhRiD1N+dg3uSssS3UvRO8QDjroG531zgKNROYKTFGojb
         DXVKZ4xOnXw7W640jmkZwOIiFXSo0SmKY+yIC7aGlcMA44R459AR171O3RWupZYr4J6J
         H7G7AvHimblfh3OtlQokbDRi5qXoQ+sf664SI=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281280044.10030.27.camel@maxim-laptop>
References: <518887.35250.qm@web37604.mail.mud.yahoo.com>
	 <1281280044.10030.27.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 Aug 2010 23:08:59 +0300
Message-ID: <1281298140.10030.96.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-08 at 18:07 +0300, Maxim Levitsky wrote: 
> On Sun, 2010-08-08 at 07:26 -0700, Alex Dubov wrote: 
> > > Hi,
> > > 
> > > I have few more questions about memsticks.
> > > 
> > > First of all, I need an explanation of overwrite flag.
> > > You already explained it to me once, but I still not sure
> > > about few
> > > things.
> > 
> > Overwrite register can be accessed either as part of extra data access
> > or separately (CP_OVERWRITE access mode).
> > 
Few more questions I gathered today.

I currently assume that if I set req->need_card_int, the driver will
wait till device raises MEMSTICK_INT_CED regardless of serial/parallel
mode. This bit is always available on serial line.
Is that OK to assume?


Another thing that I want to ask is about writes to overwrite/managment
flag.
Common sense tells me that I can write the flash many times, but write
can only clear bits. Therefore if I write 0xFF, this just means do
nothing.
Probably same applies to data content, but that isn't much of the use.
Thats why I see that default (good) value of bits in overwrite flag is
1.
This is correct I assume?


Another interesting thing I observed was that MEMSTICK_INT_ERR can mean
a correctable error,  therefore it shouldn't alone  reject read/write of
a sector. (I think that it means that one of
MEMSTICK_STATUS1_UCFG..MEMSTICK_STATUS1_DTER is set)
Same question about this.


Best regards,
Maxim Levitsky

