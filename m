Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab1CFH36 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 02:29:58 -0500
Received: from sh.osrg.net ([192.16.179.4]:34363 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab1CFH35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 02:29:57 -0500
Date: Sun, 6 Mar 2011 16:29:44 +0900
To: maximlevitsky@gmail.com
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        oakad@yahoo.com
Subject: Re: [PATCH 1/4] scatterlist: new helper functions
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1299212213-4255-2-git-send-email-maximlevitsky@gmail.com>
References: <1299212213-4255-1-git-send-email-maximlevitsky@gmail.com>
	<1299212213-4255-2-git-send-email-maximlevitsky@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110306162859E.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 06 Mar 2011 16:29:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Mar 2011 06:16:50 +0200
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> While developing memstick driver for legacy memsticks
> I found the need in few helpers that I think should be
> in common scatterlist library
> 
> The functions that were added:
> 
> * sg_nents/sg_total_len - iterate over scatterlist to figure
> out total length of memory it covers / number of entries.

You should invent a data structure per I/O request, something like
msb_request structure. Then you can store nents and total_len in
that.

That's what block subsystems and drivers do. I took a look at your
driver but I can't see why your driver can't do the same.
