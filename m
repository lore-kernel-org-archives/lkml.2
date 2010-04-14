Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab0DNJ54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 05:57:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37946 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab0DNJ5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 05:57:55 -0400
To: Yehuda Sadeh <yehuda@hq.newdream.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       yehudasa@gmail.com, sage@newdream.net, axboe@kernel.dk
Subject: Re: [PATCH 5/6] ceph: refactor mount related functions, add helpers
From: Andi Kleen <andi@firstfloor.org>
References: <1271201355-9346-1-git-send-email-yehuda@hq.newdream.net>
	<b29a49e98a5186f83094b7a7a5dbc74647921e10.1271198630.git.yehuda@hq.newdream.net>
Date: Wed, 14 Apr 2010 11:57:53 +0200
In-Reply-To: <b29a49e98a5186f83094b7a7a5dbc74647921e10.1271198630.git.yehuda@hq.newdream.net> (Yehuda Sadeh's message of "Tue, 13 Apr 2010 16:29:14 -0700")
Message-ID: <87bpdm9x0e.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yehuda Sadeh <yehuda@hq.newdream.net> writes:
>  
> +int ceph_copy_to_page_vector(struct page **pages,
> +				    const char *data,
> +				    loff_t off, size_t len)
> +{
> +	int i = 0;
> +	int po = off & ~PAGE_CACHE_MASK;
> +	int left = len;
> +	int l;
> +
> +	while (left > 0) {
> +		l = min_t(int, PAGE_CACHE_SIZE-po, left);

int seems like exactly the wrong type here.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
