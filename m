Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab0CQDnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 23:43:42 -0400
Received: from tenax.loup.net ([209.169.16.66]:50171 "EHLO tenax.loup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab0CQDnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 23:43:41 -0400
Date: Tue, 16 Mar 2010 21:30:07 -0600
Message-Id: <201003170330.o2H3U7j5011328@alien.loup.net>
From: Mike Hayward <hayward@loup.net>
To: hancockrwd@gmail.com
CC: linux-kernel@vger.kernel.org, mvds.00@gmail.com
In-reply-to: <4B9EC36F.8010404@gmail.com> (message from Robert Hancock on Mon,
	15 Mar 2010 17:31:59 -0600)
Subject: Re: SCSI GENERIC command queueing for block storage is unstable.
References: <201003151825.o2FIPUTV006948@alien.loup.net> <4B9EC36F.8010404@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

 > > After discovering that O_NONBLOCK reads and writes were actually
 > > blocking calls, I attempted to use the SCSI generic driver for
 > > nonblocking io.  The good news is that it is nonblocking; the bad news
 > > is that it is not dependable in any of the systems I have tested with.
 > >
 > > Does anyone know if these defects have been fixed in later kernels?
 > >
 > > 1. When queueing, write can occassionally return errno 12 (ENOMEM, Cannot
 > >     allocate memory).  This is documented in the SCSI GENERIC HOWTO,
 > >     however only for indirect io and it says extremely rare.  I can cause
 > >     it easily within a few hours and it can return even for direct io when
 > >     no io's are queued and 80% of the ram is free or in buffer cache.  The
 > >     fd polls as available for writing, but retrying never clears the error
 > >     and the fd is no longer usable.  This is a complete show stopper.
 > >
 > >     Linux 2.6.22.1-32.fc6 #1 SMP Wed Aug 1 14:30:16 EDT 2007 x86_64 x86_64 x86_64 GNU/Linux
 > 
 > First off, have you tested any of these problems against a newer kernel?

Ok, #1 is also happening on 2.6.32.9-70.fc12.x86_64... this time on
several processes nearly simultaneously, so it appears it isn't just
tied to one fd.  This time instead of ENOMEM though, I got errno ==
Invalid argument(16) when writing the sg_io_hdr.

interface_id S dxfer_direction fffffffe cmd_len a mx_sb_len fc
iovec_count 0 dxfer_len 200000 dxferp 0x7f85e53dd200 cmdp 1f30a38
sbp 1f30a48 timeout 20000 flags 1 pack_id 0 usr_ptr 0x1f30a00

There appears nothing wrong with the sg_io_hdr.  If I can get through
bug #2, my app will normally run constant io for hours before blowing
and it is unlikely three daemons running against separate sg devices
would simultaneously hit this error unless something were wrong in the
sg driver itself.

- Mike
