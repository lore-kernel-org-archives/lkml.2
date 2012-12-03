Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab2LCW1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 17:27:10 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:47160 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab2LCW1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 17:27:08 -0500
MIME-Version: 1.0
In-Reply-To: <1354416022-20189-5-git-send-email-tipecaml@gmail.com>
References: <1354416022-20189-1-git-send-email-tipecaml@gmail.com>
	<1354416022-20189-5-git-send-email-tipecaml@gmail.com>
Date: Mon, 3 Dec 2012 14:27:07 -0800
Message-ID: <CAHtARFE0y=ug1icuPdUcA0BVqnn6VfknAaVs=V16J-hcbZemGQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] scsi: megaraid: remove a useless call to memset().
From: adam radford <aradford@gmail.com>
To: Cyril Roelandt <tipecaml@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        megaraidlinux@lsi.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 1, 2012 at 6:40 PM, Cyril Roelandt <tipecaml@gmail.com> wrote:
> This call is followed by a call to memcpy() on the same memory area, so it can
> be safely removed.
>
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |    2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 74030af..71cc3eb 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -1028,8 +1028,6 @@ map_cmd_status(struct megasas_cmd_fusion *cmd, u8 status, u8 ext_status)
>
>                 cmd->scmd->result = (DID_OK << 16) | ext_status;
>                 if (ext_status == SAM_STAT_CHECK_CONDITION) {
> -                       memset(cmd->scmd->sense_buffer, 0,
> -                              SCSI_SENSE_BUFFERSIZE);
>                         memcpy(cmd->scmd->sense_buffer, cmd->sense,
>                                SCSI_SENSE_BUFFERSIZE);
>                         cmd->scmd->result |= DRIVER_SENSE << 24;
> --

Acked-by: Adam Radford <aradford@gmail.com>
