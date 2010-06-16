Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052Ab0FPWQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 18:16:51 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37900 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab0FPWQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 18:16:49 -0400
Message-ID: <4C194DD6.7090706@cs.wisc.edu>
Date: Wed, 16 Jun 2010 17:19:02 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: open-iscsi@googlegroups.com
CC: Rakesh Ranjan <rakesh@chelsio.com>, LK-NetDev <netdev@vger.kernel.org>,
       LK-SCSIDev <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Karen Xie <kxie@chelsio.com>,
       David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Anish Bhatt <anish@chelsio.com>
Subject: Re: [PATCH 3/3] cxgb4i_v4.3 : main driver files
References: <1275973167-8640-1-git-send-email-rakesh@chelsio.com> <1275973167-8640-2-git-send-email-rakesh@chelsio.com> <1275973167-8640-3-git-send-email-rakesh@chelsio.com> <1275973167-8640-4-git-send-email-rakesh@chelsio.com>
In-Reply-To: <1275973167-8640-4-git-send-email-rakesh@chelsio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2010 11:59 PM, Rakesh Ranjan wrote:
> From: Rakesh Ranjan<rakesh@chelsio.com>
>
>
> Signed-off-by: Rakesh Ranjan<rakesh@chelsio.com>
> ---
>   drivers/scsi/cxgbi/cxgb4i.h         |  175 +++++
>   drivers/scsi/cxgbi/cxgb4i_ddp.c     |  653 ++++++++++++++++
>   drivers/scsi/cxgbi/cxgb4i_init.c    |  317 ++++++++
>   drivers/scsi/cxgbi/cxgb4i_offload.c | 1409 +++++++++++++++++++++++++++++++++++
>   4 files changed, 2554 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/scsi/cxgbi/cxgb4i.h
>   create mode 100644 drivers/scsi/cxgbi/cxgb4i_ddp.c
>   create mode 100644 drivers/scsi/cxgbi/cxgb4i_init.c
>   create mode 100644 drivers/scsi/cxgbi/cxgb4i_offload.c
>

Do you think you can look through this patch and identify the places 
where you basically just copied a cxgb3i function or copied it but 
renamed some stuff and then move these type of things to the lib patch?

A lot of the scatter list stuff for example looks the same in each driver.

ddp_find_unused_entries - cxgb4i_ddp_find_unused_entries
ddp_unmark_entries - cxgb4i_ddp_unmark_entries
cxgb3i_ddp_find_page_index - cxgb4i_ddp_find_page_index
cxgb3i_ddp_adjust_page_table - cxgb4i_ddp_adjust_page_table
..... (lots of the ddp code looks duplicated).

The *_offload.c code looks the same.
