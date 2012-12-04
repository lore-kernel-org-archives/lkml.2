Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab2LDP5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 10:57:47 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36105 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab2LDP5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 10:57:44 -0500
Date: Tue, 4 Dec 2012 07:57:39 -0800
From: Tejun Heo <tj@kernel.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>,
        Neela Syam Kolli <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] megaraid: fix use of delayed work
Message-ID: <20121204155739.GG3885@mtj.dyndns.org>
References: <1354620834-2953-1-git-send-email-xtfeng@gmail.com>
 <20121204153939.GD3885@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121204153939.GD3885@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again, Xiaotian.

On Tue, Dec 04, 2012 at 07:39:39AM -0800, Tejun Heo wrote:
> Urgh... what the....  Didn't see that one coming.  I'm gonna push this
> to Linus through the workqueue tree.
> 
> Thanks for the fix.

It seems like megaraid doesn't have any reason to use delayed_work at
all.  It can use a plain work and cancel_work_sync() instead.  Maybe
it was doing the container_of() thing because workqueue didn't use to
have cancel_work_sync()?  Anyways, please convert it to use plain
work_struct post 3.7.

Thanks.

-- 
tejun
