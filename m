Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0LMTb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:31:56 -0500
Received: from smtp.microsoft.com ([131.107.115.215]:34922 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab0LMTby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:31:54 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] hv: Use only one receive buffer and kmalloc on
 initialize
Thread-Topic: [PATCH 1/1] hv: Use only one receive buffer and kmalloc on
 initialize
Thread-Index: AQHLmu0aQ+svDewugEOir2/SbGE0mJOfORkA//+JKnA=
Date: Mon, 13 Dec 2010 19:31:42 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C5622C0BB71F@TK5EX14MBXC116.redmond.corp.microsoft.com>
References: <1292262350-29001-1-git-send-email-hjanssen@microsoft.com>
 <20101213183448.GA11745@kroah.com>
In-Reply-To: <20101213183448.GA11745@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Monday, December 13, 2010 10:35 AM
> > ---
> >  drivers/staging/hv/hv_utils.c |   68 +++++++++++++++++++------------------
> ---
> >  1 files changed, 32 insertions(+), 36 deletions(-)
> >
> > diff --git a/drivers/staging/hv/hv_utils.c
> > b/drivers/staging/hv/hv_utils.c index 53e1e29..4ed4ab8 100644
> > --- a/drivers/staging/hv/hv_utils.c
> > +++ b/drivers/staging/hv/hv_utils.c
> > @@ -38,12 +38,15 @@
> >  #include "vmbus_api.h"
> >  #include "utils.h"
> >
> > +/*
> > + * Buffer used to receive packets from Hyper-V  */ static u8
> > +*chan_buf;
> 
> One buffer is nicer, yes, but what's controlling access to this buffer?
> You use it in multiple functions, and what's to say those functions can't be
> called at the same time on different cpus?  So, shouldn't you either have
> some locking for access to the buffer, or have a per-function buffer instead?
> 
> And if you have a per-function buffer, again, you might need to control
> access to it as the functions could be called multiple times at the same time,
> right?
> 

The current versions of Hyper-V support interrupt handling on CPU0 only.
I can make multiple buffers per channel, but because of Hyper-V implementation
It does not really make a difference.

Hank.

