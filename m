Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab2BYFX7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 00:23:59 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59159 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab2BYFX6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 00:23:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jorgyano@gmail.com designates 10.101.72.16 as permitted sender) smtp.mail=jorgyano@gmail.com; dkim=pass header.i=jorgyano@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120224194929.GA24613@kroah.com>
References: <1329603020-5302-1-git-send-email-jorgyano@gmail.com>
	<20120224194929.GA24613@kroah.com>
Date: Sat, 25 Feb 2012 03:23:57 -0200
Message-ID: <CABRD5hKZHs6jO=TuosxsQ0fJOEczvUnEj-ZMkN7syF5TnLWYKQ@mail.gmail.com>
Subject: Re: [PATCH 3/3 v2] Staging: crystalhd: Replace the BCMLOG_ERR macro
 with pr_err
From: Jorgyano vieira <jorgyano@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        nsankar@broadcom.com, jarod@wilsonet.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 5:49 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> This is nice, but, as this is a driver, I really prefer the use of
> dev_err() instead, which allows us to properly identify the device and
> driver that spit out the error message.  Care to redo this patch in that
> style instead?
>
> thanks,
>
> greg k-h

sure, I can do this.
but first, there is something wrong about the structure dependencies
on the headers:
now, the usage of the dev_err() breaks the build.
for example:
 dev_err(&ctx->adp->pdev->dev, " ...");  on crystalhd_cmds.c returns
the error: dereferencing pointer to incomplete type.

I will fix this and send it all on another series.

-- 
Regards,
Jorgyano Vieira
