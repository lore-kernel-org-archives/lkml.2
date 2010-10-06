Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281Ab0JFQNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 12:13:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:23083 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab0JFQNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 12:13:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,290,1283756400"; 
   d="scan'208";a="332926575"
Subject: Re: [PATCH wireless-2.6 or stable] iwlwifi: return error when fail
 to start scanning
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Florian Mickler <florian@mickler.org>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "stable@kernel.org" <stable@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Cahill, Ben M" <ben.m.cahill@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101006160434.GB24581@redhat.com>
References: <20101005085717.GA18012@redhat.com>
	 <1286317292-10679-1-git-send-email-florian@mickler.org>
	 <20101006090228.GA2523@redhat.com>  <20101006160434.GB24581@redhat.com>
Content-Type: text/plain
Date: Wed, 06 Oct 2010 09:12:58 -0700
Message-Id: <1286381578.12594.18.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gruszka,

On Wed, 2010-10-06 at 09:04 -0700, Stanislaw Gruszka wrote:
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
> 

Is this the replacement for Mickler's patch?

Thanks
Wey



