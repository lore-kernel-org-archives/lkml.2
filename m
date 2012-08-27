Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab2H0UEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:04:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37902 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab2H0UEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:04:02 -0400
Date: Mon, 27 Aug 2012 13:03:58 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] workqueue: ensure the wq_worker_sleeping() see the
 right flags
Message-ID: <20120827200358.GA14812@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346090307-3020-1-git-send-email-laijs@cn.fujitsu.com>
 <1346090307-3020-6-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346090307-3020-6-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 28, 2012 at 01:58:25AM +0800, Lai Jiangshan wrote:
> The compiler may compile this code into TWO write/modify instructions.
> 		worker->flags &= ~WORKER_UNBOUND;
> 		worker->flags |= WORKER_REBIND;
> 
> so the other CPU may see the temporary of worker->flags which has
> not WORKER_UNBOUND nor WORKER_REBIND, it will wrongly do local wake up.
> 
> so we use one write/modify instruction explicitly instead.
> 
> This bug will not occur on idle workers, because they have another
> WORKER_NOT_RUNNING flags.

Yeap, I think this got broken while moving around when DISASSOCIATED
is cleared.  Can you please put this at the head of the series?

Thanks.

-- 
tejun
