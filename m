Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab0KHNm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 08:42:56 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46884 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab0KHNmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 08:42:55 -0500
Message-ID: <4CD7FE61.4000606@kernel.dk>
Date: Mon, 08 Nov 2010 14:42:57 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: ioctl: fix information leak to userland
References: <1288882096-13456-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1288882096-13456-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-04 15:48, Vasiliy Kulikov wrote:
> Structure hd_geometry is copied to userland with 4 padding bytes
> between cylinders and start fields uninitialized on 64-bit platforms.
> It leads to leaking of contents of kernel stack memory.
> 
> Currently there is no memset() in real implementations of getgeo()
> in drivers/block/, so it makes sense to have memset() in blkdev_ioctl().

Thanks, applied.

-- 
Jens Axboe

