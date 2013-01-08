Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab3AHPe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 10:34:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659Ab3AHPe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 10:34:56 -0500
Date: Tue, 8 Jan 2013 10:34:48 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 11/24] cfq-iosched: add leaf_weight
Message-ID: <20130108153448.GB29635@redhat.com>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-12-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356726946-26037-12-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 12:35:33PM -0800, Tejun Heo wrote:

[..]
> +
> +	/* on root, leaf_weight is mapped to weight */
> +	{
> +		.name = "leaf_weight_device",
> +		.flags = CFTYPE_ONLY_ON_ROOT,
> +		.read_seq_string = cfqg_print_weight_device,
> +		.write_string = cfqg_set_weight_device,
> +		.max_write_len = 256,
> +	},
> +	{
> +		.name = "leaf_weight",
> +		.flags = CFTYPE_ONLY_ON_ROOT,
> +		.read_seq_string = cfq_print_weight,
> +		.write_u64 = cfq_set_weight,
> +	},

Hi Tejun,

How does it help to map leaf weight to weight in root group. Old programs
anyway don't know about leaf_weight. So nobody is going to update it. And
if they update it, they better know what does it do.

I think we just need to map "weight" to "leaf_weight" once you switch to
making use of leaf_weight and at that point of time a user will expect
that updating weight retains the old behavior. I think you have done
that in later patch.

But mapping leaf_weight to weight seems unnecessary atleast from backward
compatibility point of view.

Thanks
Vivek
