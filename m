Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162805Ab1FAIYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:24:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162843Ab1FAIYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:24:40 -0400
Message-ID: <4DE5F78C.1010102@redhat.com>
Date: Wed, 01 Jun 2011 04:25:48 -0400
From: Mark Wu <dwu@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mark Wu <dwu@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [virt] virtio-blk: Use ida to allocate disk index
References: <1306913069-23637-1-git-send-email-dwu@redhat.com>
In-Reply-To: <1306913069-23637-1-git-send-email-dwu@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2011 03:24 AM, Mark Wu wrote:
> -	if (index_to_minor(index)>= 1<<  MINORBITS)
> -		return -ENOSPC;
> +	do {
> +		if (!ida_pre_get(&vd_index_ida, GFP_KERNEL))
> +			return err;
> +
There's a problem in above code: err is not initialized before using, so 
change it to return -1;
+       do {
+               if (!ida_pre_get(&vd_index_ida, GFP_KERNEL))
+                       return -1;

