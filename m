Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908Ab2EJVV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:21:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42348 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758982Ab2EJVV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:21:26 -0400
Date: Thu, 10 May 2012 14:21:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Brian Swetland <swetland@google.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] staging: android: logger: Allocate logs dynamically
 at boot (v2)
Message-ID: <20120510212122.GA16432@kroah.com>
References: <4FAC302F.2090004@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAC302F.2090004@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 02:16:31PM -0700, Tim Bird wrote:
> +	log->misc.minor = MISC_DYNAMIC_MINOR;
> +	log->misc.name = kstrdup(log_name, GFP_KERNEL);
> +	if (log->misc.name == NULL) {
> +		ret = -1;
> +		goto out_free_log;

Please return a "real" error number, not just -1.  You do this a few
times in this function, -EINVAL perhaps?  -1 is -EPERM, which is not
what you want to be saying here, right?

thanks,

greg k-h
