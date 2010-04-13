Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0DMCWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 22:22:23 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:58880 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab0DMCWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 22:22:20 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: michaelc@cs.wisc.edu
Subject: Re: [PATCH 2/2] RFC: iscsi ibft: convert iscsi_ibft module to iscsi boot lib
Date: Mon, 12 Apr 2010 22:21:04 -0400
User-Agent: KMail/1.9.10
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       pjones@redhat.com, open-iscsi@googlegroups.com
References: <1271095578-4212-1-git-send-email-michaelc@cs.wisc.edu> <1271095578-4212-2-git-send-email-michaelc@cs.wisc.edu>
In-Reply-To: <1271095578-4212-2-git-send-email-michaelc@cs.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004122221.05326.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 April 2010 14:06:18 you wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
>
> This patch just converts the iscsi_ibft module to the
> iscsi boot sysfs lib module.
>
> This patch was made over the ibft-2.6 tree's ibft-1.03 branch:
> http://git.kernel.org/?p=linux/kernel/git/konrad/ibft-2.6.git;a=shortlog;h=
>refs/heads/ibft-1.03
>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>
I've only two comments:

.. snip..
>  /*
> + * Helper routiners to check to determine if the entry is valid
> + * in the proper iBFT structure.
> + */
> +static mode_t ibft_check_nic_for(void *data, int type)
> +{
> +	struct ibft_kobject *entry = data;
> +	struct ibft_nic *nic = entry->nic;
> +	mode_t rc = 0;
> +
> +	switch (type) {
> +	case ISCSI_BOOT_ETH_INDEX:
> +	case ISCSI_BOOT_ETH_FLAGS:
> +		rc = 1;

Did you mean for that value?
> +		break;
> +	case ISCSI_BOOT_ETH_IP_ADDR:
> +		if (memcmp(nic->ip_addr, nulls, sizeof(nic->ip_addr)))
> +			rc = S_IRUGO;
> +		break;
> +	case ISCSI_BOOT_ETH_SUBNET_MASK:
> +		if (nic->subnet_mask_prefix)
> +			rc = S_IRUGO;
> +		break;
> +	case ISCSI_BOOT_ETH_ORIGIN:
> +		rc = 1;

and this one as well?
