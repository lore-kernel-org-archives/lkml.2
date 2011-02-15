Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab1BOQqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:46:30 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57966 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab1BOQq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:46:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c3Vm454tt98rhDI/sbge82UMcrFAmuL57vOo+Bccu/olIMXUyznMGlhbiBW24fGUiv
         cYxbLbcrz5HoZNA4wNX2HvEZykji8ibDHTjv7lEftE5frELFUXU36hXEoqAf8iLH1j/D
         WBNmDD3dhTnzyTHgDUxk6dtDyx/1oiDb20pEE=
Date: Tue, 15 Feb 2011 08:46:14 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hidinput: kernel oops in out_cleanup in function
 hidinput_connect
Message-ID: <20110215164614.GA18862@core.coreip.homeip.net>
References: <1297780870-4006-1-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297780870-4006-1-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 03:41:10PM +0100, Benjamin Tissoires wrote:
> Goto out_cleanup infers a kernel oops: hidinput_disconnect calls
> input_unregister_driver to all members of hid->inputs.
> However, hidinput already has been added to hid->inputs even
> though input_register_device was not called.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>

Yep, well spotted.

Reviewed-by: Dmitry Torokhov <dtor@mail.ru>

> ---
> Hi,
> 
> while playing with hidinput_connect, I found this bug.
> 
> Cheers,
> Benjamin
> 
>  drivers/hid/hid-input.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index 7f552bf..f53911d 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -928,6 +928,7 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
>  	return 0;
>  
>  out_cleanup:
> +	list_del(&hidinput->list);
>  	input_free_device(hidinput->input);
>  	kfree(hidinput);
>  out_unwind:
> -- 
> 1.7.4
> 

-- 
Dmitry
