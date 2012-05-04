Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667Ab2EDXhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 19:37:12 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:33824 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2EDXhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 19:37:11 -0400
Date: Fri, 4 May 2012 16:37:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Brian Swetland <swetland@google.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: android: logger: Allocate logs dynamically at
 boot
Message-ID: <20120504233707.GA24213@kroah.com>
References: <4FA4673C.7010209@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA4673C.7010209@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 04:33:16PM -0700, Tim Bird wrote:
> +#define MAX_LOGS	5
> +struct logger_log *logs_array[MAX_LOGS];

You are going to make this a list and not a static array in the
future, right?

> -static int __init init_log(struct logger_log *log)
> +static int __init add_log(struct logger_log *log)
>  {
> -	int ret;
> +	int i;
> 
> +	for (i = 0; i < MAX_LOGS; i++) {
> +		if (logs_array[i] == 0) {
> +			logs_array[i] = log;
> +			return 0;
> +		}
> +	}
> +	return -1;
> +}

I see you didn't run your patch through sparse :(

Care to fix up the sparse warnings and resend?

thanks,

greg k-h
