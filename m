Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2G0PwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 11:52:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37315 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2G0PwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 11:52:11 -0400
Date: Fri, 27 Jul 2012 08:52:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: ccross@android.com, hmh@hmh.eng.br, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [PATCH 1/3] sysfs: introduce a sysfs_create_file_uevent new API
Message-ID: <20120727155208.GB535@kroah.com>
References: <1343361763-10307-1-git-send-email-bryan.wu@canonical.com>
 <1343361763-10307-2-git-send-email-bryan.wu@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343361763-10307-2-git-send-email-bryan.wu@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 12:02:41PM +0800, Bryan Wu wrote:
> Send a uevent notification whenever a new sysfs file is created to allow
> userspace processes such as udev to modify permissions on the new files.

This makes no sense, why not just call kobject_uevent after creating the
file when needed?  Wrapping it up in a single function call doesn't add
any benefit that I can see, can you?

> 
> This new API function helps to do this.
> 
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> ---
>  fs/sysfs/file.c       | 28 ++++++++++++++++++++++++++++
>  include/linux/sysfs.h | 13 +++++++++++++
>  2 files changed, 41 insertions(+)
> 
> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index 00012e3..5a22d13 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -576,6 +576,34 @@ int sysfs_create_file(struct kobject * kobj, const struct attribute * attr)
>  
>  }
>  
> +/**
> + *	sysfs_create_file_uevent - create an attribute file for an object
> +					and send a uevent to userspace.

kerneldoc needs to be on one line for function names, right?

greg k-h
