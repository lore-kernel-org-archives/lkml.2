Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab2IRJgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 05:36:53 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:50189 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757514Ab2IRJgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 05:36:51 -0400
Date: Tue, 18 Sep 2012 12:36:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: navin patidar <navinp@cdac.in>
Cc: gregkh@linuxfoundation.org, mfm@muteddisk.com, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: usbip: stub_dev: Fixed oops during removal of
 usbip_host
Message-ID: <20120918093619.GO13767@mwanda>
References: <1347940806-4653-1-git-send-email-navinp@cdac.in>
 <20120918074053.GL4587@mwanda>
 <CAPV97yda9d6yVbTfmET0Rj+xrRDniKzucfKCy=8gUbCDFYR5jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPV97yda9d6yVbTfmET0Rj+xrRDniKzucfKCy=8gUbCDFYR5jg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 03:02:15PM +0530, navin patidar wrote:
> On Tue, Sep 18, 2012 at 1:10 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Tue, Sep 18, 2012 at 09:30:06AM +0530, navin patidar wrote:
> >> stub_device_reset should set kernel thread pointers to NULL.
> >> so that at the time of usbip_host removal stub_shoutdown_connection
> >> doesn't try to kill kernel threads which are already killed.
> >>
> >
> > If you have the Oops output, that's always nice to put in the commit
> > message.
> 
> i'll surely keep this in mind  before submitting further patches.
> 
> > Why don't you set the pointers to NULL in stub_shutdown_connection()
> > since that's where you actually kill the threads.  Setting them to
> > NULL in stub_device_reset() will (sometimes) solve the problem but
> > it gives you a new problem of a resource leak.
> 
>  stub_device_reset() always gets executed after
> stub_shutdown_connection() , never before.
> 

No it isn't.  Read event_handler() more carefully.  They can be
executed independently.

In other words, stub_shutdown_connection() can be called without
calling stub_device_reset() and stub_device_reset() can be called
without stub_shutdown_connection().  If either of those happen then
it causes a problem with the patch you have just sent.

regards,
dan carpenter

