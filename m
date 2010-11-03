Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab0KCRRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:17:05 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16361 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab0KCRRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:17:03 -0400
Message-ID: <4CD19909.9090103@caviumnetworks.com>
Date: Wed, 03 Nov 2010 10:16:57 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: cdhmanning@gmail.com
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 7/9] Add yaffs tag access code
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com> <1288803204-3849-8-git-send-email-cdhmanning@gmail.com>
In-Reply-To: <1288803204-3849-8-git-send-email-cdhmanning@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Nov 2010 17:17:38.0086 (UTC) FILETIME=[038B8460:01CB7B7B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 09:53 AM, cdhmanning@gmail.com wrote:
[...]
> --- /dev/null
> +++ b/fs/yaffs2/yaffs_tagscompat.c
> @@ -0,0 +1,454 @@
> +/*
> + * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
> + *
> + * Copyright (C) 2002-2010 Aleph One Ltd.
> + *   for Toby Churchill Ltd and Brightstar Engineering
> + *
> + * Created by Charles Manning<charles@aleph1.co.uk>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include "yaffs_guts.h"
> +#include "yaffs_tagscompat.h"
> +#include "yaffs_ecc.h"
> +#include "yaffs_getblockinfo.h"
> +#include "yaffs_trace.h"
> +
> +static void yaffs_handle_rd_data_error(struct yaffs_dev *dev, int nand_chunk);
> +
> +static const char yaffs_count_bits_table[256] = {
> +	0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4,
> +	1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
> +	1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
> +	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
> +	1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
> +	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
> +	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
> +	3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
> +	1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
> +	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
> +	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
> +	3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
> +	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
> +	3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
> +	3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
> +	4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8
> +};
> +
> +int yaffs_count_bits(u8 x)
> +{
> +	int ret_val;
> +	ret_val = yaffs_count_bits_table[x];
> +	return ret_val;
> +}

As in the other file, the kernel has hweight8() that should probably be 
used instead.

On some architectures hweight8() expands to a single instruction. 
Others should already have something as efficient as this, and if they 
don't they probably should.

David Daney
