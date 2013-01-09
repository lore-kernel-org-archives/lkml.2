Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab3AIBv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 20:51:29 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:58204 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217Ab3AIBv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 20:51:28 -0500
Subject: Re: [PATCH] target: initialize sense_reason_t ret in
 core_scsi3_emulate_pro_register()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
In-Reply-To: <1356210957-30089-1-git-send-email-geert@linux-m68k.org>
References: <y>  <1356210957-30089-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jan 2013 17:51:26 -0800
Message-ID: <1357696286.5660.36.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Apologies for the delay on this one.  Still catching up on some older
holiday items..

On Sat, 2012-12-22 at 22:15 +0100, Geert Uytterhoeven wrote:
> drivers/target/target_core_pr.c: In function ‘core_scsi3_emulate_pro_register’:
> drivers/target/target_core_pr.c:2056: warning: ‘ret’ may be used uninitialized in this function
> 
> If !spec_i_pt, the "goto out_put_pr_reg" on line 2141 seems to be a real
> case where ret is not initialized.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/target/target_core_pr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index e35dbf8..c2e8026 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -2053,7 +2053,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
>  	/* Used for APTPL metadata w/ UNREGISTER */
>  	unsigned char *pr_aptpl_buf = NULL;
>  	unsigned char isid_buf[PR_REG_ISID_LEN], *isid_ptr = NULL;
> -	sense_reason_t ret;
> +	sense_reason_t ret = 0;
>  	int pr_holder = 0, type;
>  
>  	if (!se_sess || !se_lun) {

Looks fine, applied to target-pending/master.

Thank you,

--nab

