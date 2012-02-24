Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab2BXT4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:56:22 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54595 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab2BXT4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:56:21 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.129.166 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Fri, 24 Feb 2012 11:49:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jorgyano Vieira <jorgyano@gmail.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        nsankar@broadcom.com, jarod@wilsonet.com
Subject: Re: [PATCH 3/3 v2] Staging: crystalhd: Replace the BCMLOG_ERR macro
 with pr_err
Message-ID: <20120224194929.GA24613@kroah.com>
References: <1329603020-5302-1-git-send-email-jorgyano@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329603020-5302-1-git-send-email-jorgyano@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 18, 2012 at 08:10:20PM -0200, Jorgyano Vieira wrote:
> Replace the usage of BCMLOG_ERR with pr_err and remove the macro definition.
> Also added pr_fmt to identify the driver error messages.
> 
> Signed-ff-by: Jorgyano Vieira <jorgyano@gmail.com>
> ---
>  drivers/staging/crystalhd/crystalhd_cmds.c |   68 ++++++++--------
>  drivers/staging/crystalhd/crystalhd_hw.c   |  119 ++++++++++++++--------------
>  drivers/staging/crystalhd/crystalhd_lnx.c  |   96 +++++++++++-----------
>  drivers/staging/crystalhd/crystalhd_lnx.h  |    4 +-
>  drivers/staging/crystalhd/crystalhd_misc.c |   70 ++++++++--------
>  drivers/staging/crystalhd/crystalhd_misc.h |   10 +--
>  6 files changed, 181 insertions(+), 186 deletions(-)
> 
> diff --git a/drivers/staging/crystalhd/crystalhd_cmds.c b/drivers/staging/crystalhd/crystalhd_cmds.c
> index 3735ed3..46fac01 100644
> --- a/drivers/staging/crystalhd/crystalhd_cmds.c
> +++ b/drivers/staging/crystalhd/crystalhd_cmds.c
> @@ -75,12 +75,12 @@ static enum BC_STATUS bc_cproc_notify_mode(struct crystalhd_cmd *ctx,
>  	int rc = 0, i = 0;
>  
>  	if (!ctx || !idata) {
> -		BCMLOG_ERR("Invalid Arg!!\n");
> +		pr_err("%s: Invalid Arg!!\n", __func__);

This is nice, but, as this is a driver, I really prefer the use of
dev_err() instead, which allows us to properly identify the device and
driver that spit out the error message.  Care to redo this patch in that
style instead?

thanks,

greg k-h
