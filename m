Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab2BZEqm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 23:46:42 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35653 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab2BZEqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 23:46:40 -0500
MIME-Version: 1.0
In-Reply-To: <1330067945-9128-5-git-send-email-santoshsy@gmail.com>
References: <1330067945-9128-1-git-send-email-santoshsy@gmail.com>
	<1330067945-9128-5-git-send-email-santoshsy@gmail.com>
Date: Sun, 26 Feb 2012 12:46:39 +0800
Message-ID: <CAJd=RBAVfG1J66VVrCNAiaoMEJ3O7MZOU21g-T_CkyF10WJa8w@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] [SCSI] ufshcd: SCSI error handling
From: Hillf Danton <dhillf@gmail.com>
To: Santosh Y <santoshsy@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, arnd@linaro.org,
        girish.shivananjappa@linaro.org, saugata.das@linaro.org,
        vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com,
        yeji@jasper.es
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 3:19 PM, Santosh Y <santoshsy@gmail.com> wrote:
> +/**
> + * ufshcd_is_tmq_full - checks if the task management slots are full
> + * @hba: per adapter instance
> + *
> + * Returns maximum number of task management request slots in case of
> + * task management queue full or returns the free slot number
> + */
> +static inline int ufshcd_is_tmq_full(struct ufs_hba *hba)

This helper function is named to be misleading, little to do with
its functionality as full is checked at callsite.

-hd

> +{
> +       return find_first_zero_bit(&hba->outstanding_tasks, hba->nutmrs);
> +}
> +
[...]
> +       host = hba->host;
> +
> +       spin_lock_irqsave(host->host_lock, flags);
> +
> +       /* If task management queue is full */
> +       free_slot = ufshcd_is_tmq_full(hba);
> +       if (free_slot >= hba->nutmrs) {
> +               spin_unlock_irqrestore(host->host_lock, flags);
> +               dev_err(&hba->pdev->dev, "Task management queue full\n");
> +               err = FAILED;
> +               goto out;
> +       }
