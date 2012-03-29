Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727Ab2C2S5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 14:57:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44867 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933594Ab2C2S5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 14:57:38 -0400
Message-ID: <4F74B09B.3070100@kernel.dk>
Date: Thu, 29 Mar 2012 20:57:31 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] blkcg: change a spin_lock() to spin_lock_irq()
References: <20120329185119.GA21812@elgon.mountain>
In-Reply-To: <20120329185119.GA21812@elgon.mountain>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-29 20:51, Dan Carpenter wrote:
> Smatch complains that we re-enable IRQs twice.  It looks like we forgot
> to disable them here on the spin_trylock() failure path.  This was added
> in 9f13ef678e "blkcg: use double locking instead of RCU for blkg
> synchronization".

Thanks, that is indeed a screwup. Fix applied.

-- 
Jens Axboe

