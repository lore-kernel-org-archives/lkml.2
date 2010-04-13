Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0DMCmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 22:42:07 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:59555 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab0DMCmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 22:42:05 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] RFC: iscsi ibft: convert iscsi_ibft module to iscsi boot lib
Date: Mon, 12 Apr 2010 22:36:13 -0400
User-Agent: KMail/1.9.10
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       pjones@redhat.com, open-iscsi@googlegroups.com
References: <1271095578-4212-1-git-send-email-michaelc@cs.wisc.edu> <201004122221.05326.konrad@darnok.org> <4BC3D7C1.90307@cs.wisc.edu>
In-Reply-To: <4BC3D7C1.90307@cs.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004122236.13843.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 April 2010 22:32:33 Mike Christie wrote:
> On 04/12/2010 09:21 PM, Konrad Rzeszutek Wilk wrote:
> >> + * Helper routiners to check to determine if the entry is valid
> >> + * in the proper iBFT structure.
> >> + */
> >> +static mode_t ibft_check_nic_for(void *data, int type)
> >> +{
> >> +	struct ibft_kobject *entry = data;
> >> +	struct ibft_nic *nic = entry->nic;
> >> +	mode_t rc = 0;
> >> +
> >> +	switch (type) {
> >> +	case ISCSI_BOOT_ETH_INDEX:
> >> +	case ISCSI_BOOT_ETH_FLAGS:
> >> +		rc = 1;
> >
> > Did you mean for that value?
> >
> >> +		break;
> >> +	case ISCSI_BOOT_ETH_IP_ADDR:
> >> +		if (memcmp(nic->ip_addr, nulls, sizeof(nic->ip_addr)))
> >> +			rc = S_IRUGO;
> >> +		break;
> >> +	case ISCSI_BOOT_ETH_SUBNET_MASK:
> >> +		if (nic->subnet_mask_prefix)
> >> +			rc = S_IRUGO;
> >> +		break;
> >> +	case ISCSI_BOOT_ETH_ORIGIN:
> >> +		rc = 1;
> >
> > and this one as well?
>
> I did not. They should be S_IRUGO. Do you want me to resubmit the
> patches or are you just going to edit those two lines if you merge them?

No need to resend them (unless Peter eyes found something I missed).
