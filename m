Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab0JFJpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:45:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab0JFJpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:45:35 -0400
Date: Wed, 6 Oct 2010 11:02:35 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Florian Mickler <florian@mickler.org>
Cc: linville@tuxdriver.com, stable@kernel.org, linux-wireless@vger.kernel.org,
        wey-yi.w.guy@intel.com, reinette.chatre@intel.com, ilw@linux.intel.com,
        johannes.berg@intel.com, ben.m.cahill@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: fix iwlwifi scanning corner cases
Message-ID: <20101006090228.GA2523@redhat.com>
References: <20101005085717.GA18012@redhat.com>
 <1286317292-10679-1-git-send-email-florian@mickler.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286317292-10679-1-git-send-email-florian@mickler.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian

On Wed, Oct 06, 2010 at 12:21:32AM +0200, Florian Mickler wrote:
> Stanislaw Gruszka pointed out, that commit
> "iwl3945: queue the right work if the scan needs to be aborted"
> has an awkward definition of "right". Specifically the abort_scan work
> doesn't notify the generic wireless stack that the scan was aborted.
> 
> In order to get rid of the warning in bug
> https://bugzilla.kernel.org/show_bug.cgi?id=17722
> we inform ieee80211_scan_completed that we are aborting
> the scan by setting the apropriate status bit in request_scan and 
> pass it into ieee80211_scan_completed. 
> 
> Signed-off-by: Florian Mickler <florian@mickler.org>
> ---
> 
> Hi John!
> 
> Here is the fix that Stanislaw described. 
> (Yes, it is in a brown paper bag.)  Please wait for him to review this. 
> 
> Another option would be to just revert my previous patch and live with the 
> warning until the scanning rework hit's mainline.

This patch is not so bad, but better would be just return value from 
{iwlagn,iwl3945}_request_scan instead of queuing anything. I will
prepare patch(s) today or tomorrow.

Stanislaw
