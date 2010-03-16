Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966605Ab0CPSHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 14:07:30 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52750 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933063Ab0CPSH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 14:07:28 -0400
Message-ID: <4B9FC9AD.3000409@cs.wisc.edu>
Date: Tue, 16 Mar 2010 13:10:53 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: James.Bottomley@suse.de, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: Re: [PATCH 1/3] SCSI: be2iscsi, fix lock imbalance
References: <1268753039-17214-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1268753039-17214-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 10:23 AM, Jiri Slaby wrote:
> Stanse found that one error path in mgmt_invalidate_icds omits to unlock
> ctrl->mbox_lock. Fix that.
>
> Added in 756d29c8c7ed8887ed7d752371ce2f (Enable async mode for mcc rings)
> where the spinlock was moved.
>
> Signed-off-by: Jiri Slaby<jslaby@suse.cz>
> Cc: Jayamohan Kallickal<jayamohank@serverengines.com>
> Cc: James Bottomley<James.Bottomley@suse.de>
> ---
>   drivers/scsi/be2iscsi/be_mgmt.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
> index 72617b6..e641922 100644
> --- a/drivers/scsi/be2iscsi/be_mgmt.c
> +++ b/drivers/scsi/be2iscsi/be_mgmt.c
> @@ -169,6 +169,7 @@ unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
>   		SE_DEBUG(DBG_LVL_1,
>   			 "Failed to allocate memory for"
>   			 "mgmt_invalidate_icds \n");
> +		spin_unlock(&ctrl->mbox_lock);
>   		return -1;
>   	}
>   	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);

Looks good.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
