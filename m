Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab2KJI76 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 03:59:58 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:48078 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab2KJI74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 03:59:56 -0500
Message-ID: <509E178B.6090601@acm.org>
Date: Sat, 10 Nov 2012 09:59:55 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [patch,v3 04/10] scsi: allocate scsi_cmnd-s from the device's
 local numa node
References: <1352488687-19935-1-git-send-email-jmoyer@redhat.com> <1352488687-19935-5-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1352488687-19935-5-git-send-email-jmoyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/12 20:18, Jeff Moyer wrote:
> -	cmd = kmem_cache_zalloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
> +	cmd = kmem_cache_alloc_node(pool->cmd_slab,
> +				    gfp_mask | pool->gfp_mask | __GFP_ZERO,
> +				    node);

Hello Jeff,

Is it necessary to add __GFP_ZERO here ? And if so, why ?

Thanks,

Bart.
