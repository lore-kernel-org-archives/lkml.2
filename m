Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab1G2Sbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 14:31:32 -0400
Received: from mail3.vodafone.ie ([213.233.128.45]:58595 "EHLO
	mail3.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab1G2Sbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 14:31:31 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jul 2011 14:31:30 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAKT5Mk5tTgZ2/2dsb2JhbAAMKAEBBTgBTBEMDQsJIg8JAwIBAgECUQcOAQ4BAfBXhkEEmB6LQA
Message-ID: <4E32FA3D.5060100@draigBrady.com>
Date: Fri, 29 Jul 2011 19:21:49 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: linux-mm@kvack.org, mgorman@suse.de, linux-kernel@vger.kernel.org,
        andrea@cpushare.com, tim.c.chen@intel.com, shaohua.li@intel.com,
        akpm@linux-foundation.org, riel@redhat.com, luto@mit.edu
Subject: Re: [PATCH] kswapd: avoid unnecessary rebalance after an unsuccessful
 balancing
References: <1311952990-3844-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1311952990-3844-1-git-send-email-alex.shi@intel.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2011 04:23 PM, Alex Shi wrote:
> In commit 215ddd66, Mel Gorman said kswapd is better to sleep after a
> unsuccessful balancing if there is tighter reclaim request pending in
> the balancing. In this scenario, the 'order' and 'classzone_idx'
> that are checked for tighter request judgment is incorrect, since they
> aren't the one kswapd should read from new pgdat, but the last time pgdat
> value for just now balancing. Then kswapd will skip try_to_sleep func
> and rebalance the last pgdat request. It's not our expected behavior.
> 
> So, I added new variables to distinguish the returned order/classzone_idx
> from last balancing, that can resolved above issue in that scenario.
> 
> I tested the patch on our LKP system with swap-cp/fio mmap randrw
> benchmarks. The performance has no change.
> 
> Padraig Brady, would you like to test this patch for your scenario.

This
+ your previous 2 line patch
+ Mel's 3 patches
+ 2.6.38.4

still works fine for me.

cheers,
Pádraig.
