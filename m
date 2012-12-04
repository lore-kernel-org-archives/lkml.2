Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab2LDPjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 10:39:46 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48748 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2LDPjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 10:39:44 -0500
Date: Tue, 4 Dec 2012 07:39:39 -0800
From: Tejun Heo <tj@kernel.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>,
        Neela Syam Kolli <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] megaraid: fix use of delayed work
Message-ID: <20121204153939.GD3885@mtj.dyndns.org>
References: <1354620834-2953-1-git-send-email-xtfeng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354620834-2953-1-git-send-email-xtfeng@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 07:33:54PM +0800, Xiaotian Feng wrote:
> megaraid use INIT_WORK to declare a hotplug_work, but cast the hotplug_work
> from work_struct to delayed_work and schedule_delayed_work on it. This is
> very dangerous, as other part of delayed_work might be kernel memories allocated
> by others.
> 
> With commit 8852aac, schedule_delayed_work() will check dwork->timer before
> queue_work, this will cause megaraid code to hit the BUG_ON in workqueue code.
> Change megaraid code to use delayed work.
> 
> Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org

Urgh... what the....  Didn't see that one coming.  I'm gonna push this
to Linus through the workqueue tree.

Thanks for the fix.

-- 
tejun
