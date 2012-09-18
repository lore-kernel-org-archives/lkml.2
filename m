Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab2IRJcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 05:32:18 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56189 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841Ab2IRJcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 05:32:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120918074053.GL4587@mwanda>
References: <1347940806-4653-1-git-send-email-navinp@cdac.in>
	<20120918074053.GL4587@mwanda>
Date: Tue, 18 Sep 2012 15:02:15 +0530
X-Google-Sender-Auth: 44oaljdV1cPBAYEvAP9ljB4CNIs
Message-ID: <CAPV97yda9d6yVbTfmET0Rj+xrRDniKzucfKCy=8gUbCDFYR5jg@mail.gmail.com>
Subject: Re: [PATCH] staging: usbip: stub_dev: Fixed oops during removal of usbip_host
From: navin patidar <navinp@cdac.in>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, mfm@muteddisk.com, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 1:10 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, Sep 18, 2012 at 09:30:06AM +0530, navin patidar wrote:
>> stub_device_reset should set kernel thread pointers to NULL.
>> so that at the time of usbip_host removal stub_shoutdown_connection
>> doesn't try to kill kernel threads which are already killed.
>>
>
> If you have the Oops output, that's always nice to put in the commit
> message.

i'll surely keep this in mind  before submitting further patches.

> Why don't you set the pointers to NULL in stub_shutdown_connection()
> since that's where you actually kill the threads.  Setting them to
> NULL in stub_device_reset() will (sometimes) solve the problem but
> it gives you a new problem of a resource leak.

 stub_device_reset() always gets executed after
stub_shutdown_connection() , never before.


>
> regards,
> dan carpenter
>

--navin-patidar
