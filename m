Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935547Ab0HFK4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:56:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33019 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935480Ab0HFK4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:56:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UPAAi6S/Y/jxHuPcR7I+8itGchT+lJypXWyqjxu0TytGBLAzlxZGeTDea0HWs8tNhl
         5ccFYig7SRD86c0GsEGcp4pUrpcOe9oMKZt8b8RIwHwOt2t1Q2gitx57CJBuwOrYtkIS
         KTW1oXvOh/csFh+FqtfnEHcsVS3L+LH1AFHZ8=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <840953.65325.qm@web37607.mail.mud.yahoo.com>
References: <840953.65325.qm@web37607.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 13:56:39 +0300
Message-ID: <1281092199.5213.3.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 00:43 -0700, Alex Dubov wrote: 
> > > > > > 
> > > > > > That's how its called in the spec.
> > > > > > Sectors can be larger than 512b on
> > Pro-HG sticks, and
> > > > > there's additional
> > > > > > TPC_READ/WRITE_QUAD_DATA which operates
> > on larger
> > > > > quantities.
> > > > > But not on ordinary PRO, right?
> > > > 
> > > > Pro sectors are normally 512 bytes.
> > > > 
> > > > > 
> > > > > Small question, can I use Pro-HG stick in my
> > reader that is
> > > > > designed for
> > > > > Standard/PRO only? Does your subsystem
> > support it?
> > > > 
> > > > It should work. It works for me on TI, which has
> > no 8b mode either.
> > > In that case, is there an upper limit on sector size?
> > Also, you don't use the MS_TPC_READ_QUAD_DATA at all.
> > So mspro_blk.c won't work with >512 bytes/sector disk?
> > Or there is some compatibility?
> > 
> 
> The code can work with arbitrarily sized pages, 512b
> value is not hard coded. All that is needed is to slightly alter 
> h_mspro_block_transfer_data function, given, of course, that adapters
> support longer transfer 

No, I mean if I go and buy memstick PRO HG, that has > 512 bytes/sector,
will it work with current code?

Btw, there is currently no way of telling core about maximum transfer
length.
Here absolute maximum is 1024 (number of bit that _might_ hold TPC
length), and FIFO size is 512 bytes (maybe its possible to use fifo
twice)

Best regards,
Maxim Levitsky

