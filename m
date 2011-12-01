Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab1LAMon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 07:44:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab1LAMom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 07:44:42 -0500
Date: Thu, 1 Dec 2011 13:44:40 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [3.2-rc3] 100% CPU usage while in del_timer_sync from
 iwl3945_rs_free_sta
Message-ID: <20111201124440.GB25614@tiehlicka.suse.cz>
References: <20111129100727.GD2675@tiehlicka.suse.cz>
 <20111129113906.GA7299@redhat.com>
 <20111130101028.GA2906@tiehlicka.suse.cz>
 <20111130142316.GA2466@redhat.com>
 <20111130140316.GA4153@tiehlicka.suse.cz>
 <20111130153929.GA2144@redhat.com>
 <20111201085845.GA4602@tiehlicka.suse.cz>
 <20111201105538.GA4504@tiehlicka.suse.cz>
 <20111201115911.GA5706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201115911.GA5706@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-12-11 12:59:12, Stanislaw Gruszka wrote:
> On Thu, Dec 01, 2011 at 11:55:38AM +0100, Michal Hocko wrote:
> > [  349.316070] iwl3945_rs_free_sta rs_sta f4be1ac0
> > [  349.316076] ------------[ cut here ]------------
> > [  349.316097] WARNING: at drivers/net/wireless/iwlegacy/iwl-3945-rs.c:438 iwl3945_rs_free_sta+0x33/0x42 [iwl3945]()
> 
> Johannes pointed on irc that this problem is most likely caused by:
> 
> commit f785d83a19bca326f79d127a413e35769afc0105
> Author: Eliad Peller <eliad@wizery.com>
> Date:   Mon Aug 8 16:50:22 2011 +0300
> 
>     mac80211: clear sta.drv_priv on reconfiguration
> 
> Michal, could you confirm that? If that is the root of the problem, we
> need patch for iwlegacy (and iwlwifi) that allocate separate memory for
> rc structures.

Should I just revert it?

> 
> Thanks
> Stanislaw

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
