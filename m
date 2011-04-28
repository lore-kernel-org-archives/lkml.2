Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab1D1TkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 15:40:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54124 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab1D1TkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 15:40:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=oBlSlh1V0ijjAkJKXs6KFzJn3/Ic4ztYG3ZcKa98tPJ/27lIsaS7ll4k16Q2Ie/T/P
         9TqrVU+oMeswNDvUrF872/4bA5cg6aCbJUZBlT0Nuh3MfmU/yy+kHJ9lHcOYkW5NW4O8
         0tSZ1O6FTmzfWvBjmTdkQr6WXZlbUWHPriFGw=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: greg@kroah.com, Sutharsan <sutharsan.tech@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, david.cross@cypress.com, srmt@cypress.com
Subject: Re: [PATCH] Staging: Westbridge: replace custom debug macros with
 pr_...() macros
References: <1304016521.3749.13.camel@sutharsan-laptop>
Date: Thu, 28 Apr 2011 21:40:07 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vunx85sd3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1304016521.3749.13.camel@sutharsan-laptop>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Apr 2011 20:48:41 +0200, Sutharsan <sutharsan.tech@gmail.com>  
wrote:
> @@ -2121,7 +2121,7 @@ static int cyasgadget_initialize(void)
>  	cy_as_dev->dev_handle = cyasdevice_getdevhandle();
>  	if (0 == cy_as_dev->dev_handle) {
>  		#ifndef NDEBUG
> -		cy_as_hal_print_message("<1> cy_as_gadget: "
> +		pr_debug("<1> cy_as_gadget: "
>  			"no west bridge device\n");
>  		#endif
>  		retval = -EFAULT;

That's actually incorrect.  You should not have "<1>" in the
string.  Not only that, "<1>" means that the message was actually
KERN_ALERT not KERN_DEBUG -- it looks like that is a mistake though.
At any rate, though, if you are using pr_debug() you don't need to
check for NDEBUG macro.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
