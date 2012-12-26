Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab2LZUne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 15:43:34 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60218
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537Ab2LZUna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 15:43:30 -0500
Message-ID: <50DB616D.50607@kernel.dk>
Date: Wed, 26 Dec 2012 21:43:25 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: majianpeng <majianpeng@gmail.com>
CC: Shaohua Li <shli@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Remove should_sort judgement when flush blk_plug.
References: <201212251726591128681@gmail.com>
In-Reply-To: <201212251726591128681@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-25 10:27, majianpeng wrote:
> In commit 975927b942c932,it add blk_rq_pos to sort rq when flushing.
> Although this commit was used for the situation which blk_plug handled
> multi devices on the same time like md device.
> I think there must be some situations like this but only single
> device.
> So remove the should_sort judgement.
> Because the parameter should_sort is only for this purpose,it can delete
> should_sort from blk_plug.

Agree with the patch. It does not make sense to have ->should_sort and
not set it for all the conditions that the list_sort() compare now
checks for.

Applied for 3.9, thanks.

-- 
Jens Axboe

