Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab1LAL65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 06:58:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab1LAL64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 06:58:56 -0500
Date: Thu, 1 Dec 2011 12:59:12 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [3.2-rc3] 100% CPU usage while in del_timer_sync from
 iwl3945_rs_free_sta
Message-ID: <20111201115911.GA5706@redhat.com>
References: <20111129100727.GD2675@tiehlicka.suse.cz>
 <20111129113906.GA7299@redhat.com>
 <20111130101028.GA2906@tiehlicka.suse.cz>
 <20111130142316.GA2466@redhat.com>
 <20111130140316.GA4153@tiehlicka.suse.cz>
 <20111130153929.GA2144@redhat.com>
 <20111201085845.GA4602@tiehlicka.suse.cz>
 <20111201105538.GA4504@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201105538.GA4504@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 11:55:38AM +0100, Michal Hocko wrote:
> [  349.316070] iwl3945_rs_free_sta rs_sta f4be1ac0
> [  349.316076] ------------[ cut here ]------------
> [  349.316097] WARNING: at drivers/net/wireless/iwlegacy/iwl-3945-rs.c:438 iwl3945_rs_free_sta+0x33/0x42 [iwl3945]()

Johannes pointed on irc that this problem is most likely caused by:

commit f785d83a19bca326f79d127a413e35769afc0105
Author: Eliad Peller <eliad@wizery.com>
Date:   Mon Aug 8 16:50:22 2011 +0300

    mac80211: clear sta.drv_priv on reconfiguration

Michal, could you confirm that? If that is the root of the problem, we
need patch for iwlegacy (and iwlwifi) that allocate separate memory for
rc structures.

Thanks
Stanislaw
