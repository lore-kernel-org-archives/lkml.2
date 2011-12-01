Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab1LACJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 21:09:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64293 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1LACJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 21:09:55 -0500
Date: Thu, 1 Dec 2011 10:09:45 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [3.2-rc3] 100% CPU usage while in del_timer_sync from
 iwl3945_rs_free_sta
Message-ID: <20111201020945.GA5932@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20111129100727.GD2675@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111129100727.GD2675@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 11:07:27AM +0100, Michal Hocko wrote:
> Looks we are stuck in lock_timer_base loop. I am not familiar with the
> code but either base is NULL or we are racing with timer->base changes.
> I guess that the first one sounds more probable. The timer in question
> is &rs_sta->rate_scale_flush.

FYI

If you could apply below commits in -tip/core/debugobjects
dc4218b timer: Use debugobjects to catch deletion of uninitialized timers
fb16b8c timer: Setup uninitialized timer with a stub callback
b84d435 debugobjects: Extend to assert that an object is initialized
feac18d debugobjects: Be smarter about static objects

and enable DEBUG_OBJECTS_TIMERS, maybe you can catch something easily.

Thanks,
Yong
