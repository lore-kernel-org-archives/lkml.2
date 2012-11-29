Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab2K2RwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 12:52:07 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:64416 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab2K2RwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 12:52:04 -0500
MIME-Version: 1.0
In-Reply-To: <20121129173053.GQ27196@axis.com>
References: <20121129173053.GQ27196@axis.com>
Date: Thu, 29 Nov 2012 11:52:03 -0600
Message-ID: <CAH2r5mvKGnZdUNb1-Msb10NBypG2cQm+5JrN-Ajv8VNvmX2+Pg@mail.gmail.com>
Subject: Re: [RFQ PATCH] cifs: Change default security error message
From: Steve French <smfrench@gmail.com>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has already been changed in the cifs-2.6.git for-next  branch.
We had run into problems with Apple Server with ntlmv2 so it took
longer than expected to test it, and it was too late for 3.7 so the
patch to move to ntlmssp encapsulated ntlmv2 which removes this
warning is in cifs-2.6.git and queued for 3.8

On Thu, Nov 29, 2012 at 11:30 AM, Jesper Nilsson
<jesper.nilsson@axis.com> wrote:
> Hi!
>
> Connecting with a default security mechanism prompts an KERN_ERROR
> output warning to the user that the default mechanism will be changed
> in Linux 3.3.
>
> We're now at 3.7, so we either could remove the warning completely
> (if the default has been changed), or we could bump the number to
> what our current target for the change is.
>
>
> The below patch changes the cERROR (which turns into a printk with KERN_ERROR)
> into a straight printk with KERN_WARNING and changes the text to indicate
> that it was changed in 3.3.
>
> I expect that the patch is incorrect and that we should choose
> another of the alternative solutions above, but I'd like to get
> some input on this.
>
> Not-Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
> ---
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index c83f5b65..968456f 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2480,9 +2480,9 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
>         supported for many years, time to update default security mechanism */
>         if ((volume_info->secFlg == 0) && warned_on_ntlm == false) {
>                 warned_on_ntlm = true;
> -               cERROR(1, "default security mechanism requested.  The default "
> -                       "security mechanism will be upgraded from ntlm to "
> -                       "ntlmv2 in kernel release 3.3");
> +               printk(KERN_WARNING "default security mechanism requested.  "
> +                       "The default security mechanism was changed "
> +                       " from ntlm to ntlmv2 in kernel release 3.3");
>         }
>         ses->overrideSecFlg = volume_info->secFlg;
>
>
>
> /^JN - Jesper Nilsson
> --
>                Jesper Nilsson -- jesper.nilsson@axis.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
