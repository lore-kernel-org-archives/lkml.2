Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1DEQJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:09:50 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39834 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1DEQJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:09:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:mime-version
         :content-transfer-encoding:from:organization:date:message-id
         :in-reply-to:user-agent;
        b=rEzyeRKvkk4RTuf/+lMU7toafYMGtblgnYnLA0gdfOiqAMOlJjADJ/ajm6SjLL4hOs
         QlehwOBF9vR7CXUph75jtjdYoY8QWnmSMtLbnxDOYvAbG/9fYVfyYjA8bW16NrHlayF7
         RIVwH5ejiadaatEOu9E1UQxWZ4pbcSKAGpaMM=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: gregkh@suse.de, "Roger Quadros" <roger.quadros@nokia.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] usb: gadget: f_mass_storage: Fix Bulk-only RESET
 handling
References: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com>
 <1302017802-16614-2-git-send-email-roger.quadros@nokia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Organization: Google
Date: Tue, 05 Apr 2011 18:09:44 +0200
Message-ID: <op.vtg26ick3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1302017802-16614-2-git-send-email-roger.quadros@nokia.com>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Apr 2011 17:36:38 +0200, Roger Quadros  
<roger.quadros@nokia.com> wrote:
> The ep0 request tag was not recorded thus resulting in phase
> problems while sending status/response in handle_execption() handler.
> This was resulting in MSC compliance test failures with USBCV tool.
>
> With this patch, the Bulk-Only Mass storage RESET request is
> handled correctly and the MSC compliance tests pass.
>
> Signed-off-by: Roger Quadros <roger.quadros@nokia.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> --- a/drivers/usb/gadget/f_mass_storage.c
> +++ b/drivers/usb/gadget/f_mass_storage.c
> @@ -613,6 +613,11 @@ static int fsg_setup(struct usb_function *f,
>  	if (!fsg_is_set(fsg->common))
>  		return -EOPNOTSUPP;
> +	++fsg->common->ep0_req_tag;	/* Record arrival of a new request */
> +	req->context = NULL;
> +	req->length = 0;
> +	dump_msg(fsg, "ep0-setup", (u8 *) ctrl, sizeof(*ctrl));
> +
>  	switch (ctrl->bRequest) {
> 	case USB_BULK_RESET_REQUEST:

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
