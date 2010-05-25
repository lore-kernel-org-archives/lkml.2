Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab0EYHre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 03:47:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:46202 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab0EYHrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 03:47:32 -0400
Date: Tue, 25 May 2010 09:47:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: iceberg <iceberg@ispras.ru>, Alexey Dobriyan <adobriyan@gmail.com>,
       Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Removed unused variable from hidraw_read
In-Reply-To: <1274301670.22226.4.camel@localhost>
Message-ID: <alpine.LNX.2.00.1005250947210.28092@pobox.suse.cz>
References: <1274301670.22226.4.camel@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010, Stefan Achatz wrote:

> Removed unused variable from hidraw_read.
> 
> Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
> ---
>  drivers/hid/hidraw.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
> index 6eadf1a..bfe1e26 100644
> --- a/drivers/hid/hidraw.c
> +++ b/drivers/hid/hidraw.c
> @@ -46,7 +46,6 @@ static ssize_t hidraw_read(struct file *file, char __user *buffer, size_t count,
>  {
>  	struct hidraw_list *list = file->private_data;
>  	int ret = 0, len;
> -	char *report;
>  	DECLARE_WAITQUEUE(wait, current);
>  
>  	mutex_lock(&list->read_mutex);
> @@ -84,7 +83,6 @@ static ssize_t hidraw_read(struct file *file, char __user *buffer, size_t count,
>  		if (ret)
>  			goto out;
>  
> -		report = list->buffer[list->tail].value;
>  		len = list->buffer[list->tail].len > count ?
>  			count : list->buffer[list->tail].len;
>  

Applied, good catch. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
