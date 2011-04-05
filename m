Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab1DEP4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:56:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46651 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab1DEP4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:56:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:organization:message-id:in-reply-to
         :user-agent;
        b=bzA2LKhrRgC66+s0n8vVFXafxUonQlbas2r+hPYyfC1Io24H42oXMpuYJtp1gvPTrP
         Zq75gDRv8ze4FzsY4iJO2ObvTzDwBuMR88OM4UBn6ZBBeLFYq/vFjb3sXTpH9rE3eJw5
         UMH6Du5qm8VUMBd6RYjM4eCrwT/Gcm6s8xwNw=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: gregkh@suse.de, "Roger Quadros" <roger.quadros@nokia.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] usb: gadget: f_mass_storage: Prevent NULL pointer
 dereference
References: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com>
 <1302017802-16614-4-git-send-email-roger.quadros@nokia.com>
Date: Tue, 05 Apr 2011 17:56:47 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Organization: Google
Message-ID: <op.vtg2kx0d3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1302017802-16614-4-git-send-email-roger.quadros@nokia.com>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Apr 2011 17:36:40 +0200, Roger Quadros  
<roger.quadros@nokia.com> wrote:
> Prevent a NULL pointer dereference in fsg_config_from_params() if
> 'file' parameter is not specified.

Have you observed this behaviour?  I don't see how it could happen with
module parameters and if it appears in some gadget it's a bug in the
gadget.  Not that I'm saying checking for null pointer is a bad idea.

> Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
> ---
>  drivers/usb/gadget/f_mass_storage.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/gadget/f_mass_storage.c  
> b/drivers/usb/gadget/f_mass_storage.c
> index 5d7de93..f6bd001 100644
> --- a/drivers/usb/gadget/f_mass_storage.c
> +++ b/drivers/usb/gadget/f_mass_storage.c
> @@ -3177,7 +3177,7 @@ fsg_config_from_params(struct fsg_config *cfg,
>  		lun->removable = /* Removable by default */
>  			params->removable_count <= i || params->removable[i];
>  		lun->filename =
> -			params->file_count > i && params->file[i][0]
> +			params->file_count > i && params->file[i]

You're removing the check if an empty file name has been specified.  It
should read:

+			params->file_count > i && params->file[i] && params->file[i][0]

And since the line is getting pretty long, maybe convert it to a proper
“if”.  I'm sure Greg will like that. ;)

>  			? params->file[i]
>  			: 0;
>  	}

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
