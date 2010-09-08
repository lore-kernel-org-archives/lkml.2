Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab0IHKDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 06:03:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:56748 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757535Ab0IHKDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 06:03:20 -0400
Date: Wed, 8 Sep 2010 12:03:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Julia Lawall <julia@diku.dk>, Dmitry Torokhov <dtor@mail.ru>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: wake up reading tasks when debug event occurs
In-Reply-To: <1283189265-5015-1-git-send-email-chase.douglas@canonical.com>
Message-ID: <alpine.LNX.2.00.1009081202290.26813@pobox.suse.cz>
References: <1283189265-5015-1-git-send-email-chase.douglas@canonical.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010, Chase Douglas wrote:

> From: Chase Douglas <chase.douglas@ubuntu.com>
> 
> Some devices poke the hid core in a way that causes hid_debug_event to
> be called, while never calling hid_dump_input. Without this wakeup
> addition, tasks reading for hid events through debugfs may never see any
> events. It may be that a well written driver doesn't cause this, but
> then what's the point of debugfs?

Well the main reason for the debugfs interface has been to debug strange 
devices. But your fix is a clear improvement for pathological cases, which 
is OK for debugging interface.

Applied, thanks.

> 
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> ---
>  drivers/hid/hid-debug.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
> index 850d02a..adff4ef 100644
> --- a/drivers/hid/hid-debug.c
> +++ b/drivers/hid/hid-debug.c
> @@ -570,6 +570,8 @@ void hid_debug_event(struct hid_device *hdev, char *buf)
>  				buf[i];
>  		list->tail = (list->tail + i) % HID_DEBUG_BUFSIZE;
>          }
> +
> +	wake_up_interruptible(&hdev->debug_wait);
>  }
>  EXPORT_SYMBOL_GPL(hid_debug_event);
>  
> -- 
> 1.7.1
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
