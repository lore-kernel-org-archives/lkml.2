Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab0FDGhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 02:37:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41771 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab0FDGhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 02:37:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Kyp1Y0nB+A/1zn7EWnWXwTS5nQpr9EwrHerFZ02kVxdrFhdWZhtngGuz9xG+CfX5/h
         c24V5nBC0LxWOk0cXCJRSlU4iwCTzykRlJbN/tBpdojorMQrhqJ6eNDdT2z6NemjL8tv
         r7aeW/6MzIVAmyWQYtA5A9xs/6iYD1+Jm4Lkc=
Date: Thu, 3 Jun 2010 23:37:34 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>
Subject: Re: [PATCH 3/4] input: evdev: Convert to dynamic event buffer (rev3)
Message-ID: <20100604063734.GD21239@core.coreip.homeip.net>
References: <1275552062-8153-1-git-send-email-rydberg@euromail.se>
 <1275552062-8153-2-git-send-email-rydberg@euromail.se>
 <1275552062-8153-3-git-send-email-rydberg@euromail.se>
 <1275552062-8153-4-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275552062-8153-4-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 10:01:01AM +0200, Henrik Rydberg wrote:
>  
> +	evdev->bufsize = evdev_compute_buffer_size(dev);
> +	evdev->buffer = kzalloc(evdev->bufsize * sizeof(struct input_event),
> +				GFP_KERNEL);

kcalloc().

> +	if (!evdev->buffer) {
> +		error = -ENOMEM;
> +		goto err_free_evdev;
> +	}
> +
>  	error = input_register_handle(&evdev->handle);
>  	if (error)
>  		goto err_free_evdev;

-- 
Dmitry
