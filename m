Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032401Ab2COXbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 19:31:21 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:56252 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031246Ab2COXbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 19:31:19 -0400
Subject: Re: [PATCH] scsi: qla2xxx: fix section mismatch in linux-next
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Gerard Snitselaar <dev@snitselaar.org>
Cc: andrew.vasquez@qlogic.com, linux-driver@qlogic.com,
        JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>
In-Reply-To: <1331847626-11141-1-git-send-email-dev@snitselaar.org>
References: <1331847626-11141-1-git-send-email-dev@snitselaar.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 16:31:16 -0700
Message-ID: <1331854276.10203.143.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 14:40 -0700, Gerard Snitselaar wrote:
> qla_tgt_exit() is annotated __exit , but called in
> qla2x00_module_init().
> 
> Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
> ---
>  drivers/scsi/qla2xxx/qla_target.c |    2 +-
>  drivers/scsi/qla2xxx/qla_target.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 

Hi Gerard,

> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 6d6f1cf..699d16e 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -4730,7 +4730,7 @@ out:
>  	return ret;
>  }
>  
> -void __exit qla_tgt_exit(void)
> +void qla_tgt_exit(void)
>  {
>  	destroy_workqueue(qla_tgt_wq);
>  	mempool_destroy(qla_tgt_mgmt_cmd_mempool);
> diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
> index db6b399..b9d0aa1 100644
> --- a/drivers/scsi/qla2xxx/qla_target.h
> +++ b/drivers/scsi/qla2xxx/qla_target.h
> @@ -934,7 +934,7 @@ extern void qla_tgt_fc_port_deleted(struct scsi_qla_host *, fc_port_t *);
>  extern void qla_tgt_set_mode(struct scsi_qla_host *ha);
>  extern void qla_tgt_clear_mode(struct scsi_qla_host *ha);
>  extern int __init qla_tgt_init(void);
> -extern void __exit qla_tgt_exit(void);
> +extern void qla_tgt_exit(void);
>  
>  static inline bool qla_tgt_mode_enabled(struct scsi_qla_host *ha)
>  {

This looks fine.  Applied to lio-core, and will get this fixed up in
target-pending/for-next-merge shortly.

Thanks for your patch!

--nab




