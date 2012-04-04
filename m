Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab2DDXSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 19:18:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51731 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab2DDXSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 19:18:47 -0400
Message-ID: <4F7CD6C9.4060509@kernel.dk>
Date: Wed, 04 Apr 2012 17:18:33 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tao Guo <glorioustao@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        neilb@suse.de, axboe@fusionio.com
Subject: Re: [PATCH] umem: fix up unplugging.
References: <1325254651-15379-1-git-send-email-glorioustao@gmail.com> <20120404144656.7b2a06ec.akpm@linux-foundation.org> <CAAV8rn+T7FM7bG+Q6fyoUrVtzOkYOx94Nh87Rg12UqCdk9HhWQ@mail.gmail.com>
In-Reply-To: <CAAV8rn+T7FM7bG+Q6fyoUrVtzOkYOx94Nh87Rg12UqCdk9HhWQ@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-04 16:20, Tao Guo wrote:
> Hi Andrew,
> 
> Thanks for your reply.
> 
> Yes, without this patch the umem driver just doesn't work.
> It is a bug introduced by commit 7eaceaccab5f40bbfda044629a6298616aeaed50.
> In that patch, Jens removed the whole mm_unplug_device() function,
> which used to be
> the trigger to make umem start to work.

Hmm indeed, that's isn't terribly useful. Why aren't we just calling
activate_card() on addition of a bio?

But your patch looks fine too, if it's tested it beats what we have.

-- 
Jens Axboe

