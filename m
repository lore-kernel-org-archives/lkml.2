Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030833Ab2LGQFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 11:05:38 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:57200 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030394Ab2LGQFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 11:05:36 -0500
Message-ID: <1354896352.9552.9.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH V2 wireless-next] iwlwifi: iwlagn_request_scan: Fix
 check for priv->scan_request
From: Johannes Berg <johannes@sipsolutions.net>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Don Fry <donald.h.fry@intel.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date: Fri, 07 Dec 2012 17:05:52 +0100
In-Reply-To: <1354886914-7822-1-git-send-email-tim.gardner@canonical.com> (sfid-20121207_142923_134753_FC85E705)
References: <1354830114.18211.4.camel@jlt4.sipsolutions.net>
	 <1354886914-7822-1-git-send-email-tim.gardner@canonical.com>
	 (sfid-20121207_142923_134753_FC85E705)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 06:28 -0700, Tim Gardner wrote:
> The WARN_ON_ONCE() check for scan_request will not correctly detect
> a NULL pointer for scan_type == IWL_SCAN_NORMAL. Make it explicit
> that the check only applies to normal scans.
> 
> Convert WARN_ON_ONCE to WARN_ON since priv->scan_request really _can't_
> be NULL for normal scans. If it is then we should emit frequent warnings.
> 
> This smatch warning led to scrutiny of iwlagn_request_scan():
> 
> drivers/net/wireless/iwlwifi/dvm/scan.c:894 iwlagn_request_scan() error: we previously assumed 'priv->scan_request' could be null (see line 792)
> 
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Cc: Intel Linux Wireless <ilw@linux.intel.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Cc: Don Fry <donald.h.fry@intel.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
> 
> This patch does apply to 3.6.y, but it doesn't fix an existing
> bug so I don't think it qualifies. This patch simply makes
> the driver more robust for future development.
> 
> V2 - corrected indentation more like the rest of the source
> in this file.

Thanks, I've picked it up now, adding one space in the condition
still :)
It's in my internal tree for now, so it'll be a few days until it
trickles out to iwlwifi-next.

johannes

