Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933Ab0JFUPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 16:15:09 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59806 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759625Ab0JFUPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:15:07 -0400
Date: Wed, 6 Oct 2010 16:01:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Florian Mickler <florian@mickler.org>, stable@kernel.org,
        linux-wireless@vger.kernel.org, wey-yi.w.guy@intel.com,
        reinette.chatre@intel.com, ilw@linux.intel.com,
        johannes.berg@intel.com, ben.m.cahill@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-2.6 or stable] iwlwifi: return error when fail
 to start scanning
Message-ID: <20101006200150.GJ2472@tuxdriver.com>
References: <20101005085717.GA18012@redhat.com>
 <1286317292-10679-1-git-send-email-florian@mickler.org>
 <20101006090228.GA2523@redhat.com>
 <20101006160434.GB24581@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006160434.GB24581@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 06:04:35PM +0200, Stanislaw Gruszka wrote:
> This is stable friendly backport of wireless-testing commit
> 3eecce527c7434dfd16517ce08b49632c8a26717 "iwlwifi: unify scan start
> checks". Wireless-testing version include also a lot of cleanups.
> 
> On error case in {iwl3945,iwlagn}_request_scan we queue abort_scan work,
> which in a fact do nothing, so we never complete the scan. Thats gives
> "WARNING: at net/wireless/core.c:614 wdev_cleanup_work" and stopped
> network connection until reload iwlwifi modules. Return of -EIO, and
> stopping queuing any work is a fix.
> 
> Note there are still many cases when we can get: 
> 
> WARNING: at net/wireless/core.c:614 wdev_cleanup_work  
> WARNING: at net/mac80211/scan.c:266 ieee80211_scan_completed
> WARNING: at net/mac80211/scan.c:269 ieee80211_scan_complete
> 
> which are not fixed. Unfortunately does not exist single, small fix
> for that problems, and we probably will see some more bug reports
> with scan warnings. As solution we rewrite iwl-scan.c code to avoid
> all possible race conditions. That quite big patch set is queued
> for 2.6.37 .
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> Patch is intended for wireless-2.6, or in case when it does not
> make 2.6.36 release, for -stable 2.6.36.y 

I'm fine with this patch for -stable, but I'm not sure it is worthwhile
to rush it into 2.6.36.  The problem it fixes is intermittent and
not always very severe, and we've already been living with it for
4 releases.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
