Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab2H0TEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 15:04:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59322 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab2H0TEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 15:04:35 -0400
Date: Mon, 27 Aug 2012 12:04:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] workqueue: single pass rebind_workers
Message-ID: <20120827190431.GB13094@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346090307-3020-1-git-send-email-laijs@cn.fujitsu.com>
 <1346090307-3020-5-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346090307-3020-5-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Tue, Aug 28, 2012 at 01:58:24AM +0800, Lai Jiangshan wrote:
> busy_worker_rebind_fn() can't return until all idle workers are rebound,
> the code of busy_worker_rebind_fn() ensure this.
> 
> So we can change the order of the code of rebind_workers(),
> and make it a single pass do the rebind_workers().
> 
> It makes the code much clean and better readability.

I can't see how this could be correct.  What prevents busy worker from
grabbing manager_mutex before idle one?

Thanks.

-- 
tejun
