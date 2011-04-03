Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab1DCWK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 18:10:57 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33892 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab1DCWK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 18:10:56 -0400
Message-ID: <4D98F061.5030003@kernel.dk>
Date: Mon, 04 Apr 2011 00:10:41 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: fix request sorting at unplug
References: <20110402153737.15555.75762.stgit@localhost6>
In-Reply-To: <20110402153737.15555.75762.stgit@localhost6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-02 17:37, Konstantin Khlebnikov wrote:
> Comparison function for list_sort() must be anticommutative,
> otherwise it is not sorting in ordinary meaning.
> 
> But fortunately list_sort() always check ((*cmp)(priv, a, b) <= 0)
> it not distinguish negative and zero, so comparison function can
> implement only less-or-equal instead of full three-way comparison.

Thanks, good catch! It's an optimization, so no breakage. But if you end
up often having > 1 queue plugged, it's a good optimization.

-- 
Jens Axboe

