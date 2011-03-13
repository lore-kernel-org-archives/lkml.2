Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1CMGip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 01:38:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61148 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab1CMGio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 01:38:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WqFRQxnnwVU00t/TbujMP3ECmzgmzPvFvv/XtR7m5A9of5oMoQFjMy9bsMitcU4iVO
         L+/dUhAxk8d70L4CNSAsZp6EYjHlLlHldxVxdO4vTNrjKaLHQcZ3Zt1AHBr7bm4syEzp
         0yRWKJ209Fb/8HbhFNeI3b+96z5PtKGa5J3BE=
Date: Sat, 12 Mar 2011 22:38:38 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: johnpol@2ka.mipt.ru, sameo@linux.intel.com, a.zummo@towertech.it,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: add workqueue thread into 88pm860x
Message-ID: <20110313063838.GF31566@core.coreip.homeip.net>
References: <1299512600-29047-1-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-2-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-3-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-4-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-5-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299512600-29047-5-git-send-email-haojian.zhuang@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 11:43:13PM +0800, Haojian Zhuang wrote:
> Create workqueue thread in 88pm860x driver since 88pm860x driver
> needs to handle event in workqueue.
> 
> Avoid to use system workqueue since i2c operation cost a lot of
> time. It would impact system performance.

No, not anymore - the concurrency managed workqueues implemented by
Tejun allow scheduling longer-running jobs on the system workqueue
without impacting other users.
 
Thanks.

-- 
Dmitry
