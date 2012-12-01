Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab2LASjv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 13:39:51 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:40689 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab2LASjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 13:39:49 -0500
Date: Sat, 1 Dec 2012 21:39:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Robert Love <rlove@google.com>,
        Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
        Dima Zavin <dima@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [RFC PATCH] staging, android, ashmem: invalidate pin/unpin ioctl
 for private map
Message-ID: <20121201183929.GA6568@mwanda>
References: <1354297557-24486-1-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354297557-24486-1-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2012 at 02:45:57AM +0900, Joonsoo Kim wrote:
> @@ -614,21 +616,35 @@ static int ashmem_pin_unpin(struct ashmem_area *asma, unsigned long cmd,
>  	pgstart = pin.offset / PAGE_SIZE;
>  	pgend = pgstart + (pin.len / PAGE_SIZE) - 1;
>  
> -	mutex_lock(&ashmem_mutex);
> +	if (asma->shared_mapping) {
> +		mutex_lock(&ashmem_mutex);

Wouldn't we need to hold the mutex while we check the
->shared_mapping?

regards,
dan carpenter

