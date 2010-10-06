Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab0JFRtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 13:49:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:22502 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759083Ab0JFRth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 13:49:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,291,1283756400"; 
   d="scan'208";a="332967899"
Subject: Re: [PATCH wireless-2.6 or stable] iwlwifi: return error when fail
 to start scanning
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Florian Mickler <florian@mickler.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "stable@kernel.org" <stable@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Cahill, Ben M" <ben.m.cahill@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101006194537.35e8b00e@schatten.dmk.lab>
References: <20101005085717.GA18012@redhat.com>
	 <1286317292-10679-1-git-send-email-florian@mickler.org>
	 <20101006090228.GA2523@redhat.com>	<20101006160434.GB24581@redhat.com>
	 <20101006194537.35e8b00e@schatten.dmk.lab>
Content-Type: text/plain
Date: Wed, 06 Oct 2010 10:48:49 -0700
Message-Id: <1286387329.12594.21.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-06 at 10:45 -0700, Florian Mickler wrote:
> Hi Stanislaw!
> 
> On Wed, 6 Oct 2010 18:04:35 +0200
> Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> 
> > This is stable friendly backport of wireless-testing commit
> > 3eecce527c7434dfd16517ce08b49632c8a26717 "iwlwifi: unify scan start
> > checks". Wireless-testing version include also a lot of cleanups.
> > 
> > On error case in {iwl3945,iwlagn}_request_scan we queue abort_scan work,
> > which in a fact do nothing, so we never complete the scan. Thats gives
> > "WARNING: at net/wireless/core.c:614 wdev_cleanup_work" and stopped
> > network connection until reload iwlwifi modules. Return of -EIO and
> > stopping queuing any work is a fix.
> > 
> > Note there are still many cases when we can get: 
> > 
> > WARNING: at net/wireless/core.c:614 wdev_cleanup_work  
> > WARNING: at net/mac80211/scan.c:266 ieee80211_scan_completed
> > WARNING: at net/mac80211/scan.c:269 ieee80211_scan_complete
> > 
> > which are not fixed. Unfortunately does not exist single, small fix
> > for that problems, and we probably will see some more bug reports
> > with scan warnings. As solution we rewrite iwl-scan.c code to avoid
> > all possible race conditions. That quite big patch set is queued
> > for 2.6.37 .
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

looks good to me

Thanks
Wey


