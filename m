Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab2FMNUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:20:46 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:44653 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab2FMNUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:20:45 -0400
Message-ID: <1339593640.4519.39.camel@jlt3.sipsolutions.net>
Subject: Re: [BUG] iwldvm lock oops
From: Johannes Berg <johannes@sipsolutions.net>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 13 Jun 2012 15:20:40 +0200
In-Reply-To: <20120613131725.GA2052@localhost> (sfid-20120613_151753_455745_D624F0E8)
References: <20120613131725.GA2052@localhost>
	 (sfid-20120613_151753_455745_D624F0E8)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,

> The kernel compiled from commit b35032f ("iwlwifi: don't configure a
> txq that is being disabled") in
> 
>         git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git  master
> 
> triggers a kernel oops below.
> 
> That particular commit may well not be the root cause. I'm just hoping
> you may have better idea which recent change may be relevant.

Thanks for the report. This particular problem is due to the fact that
we have the objects linked into the kernel in the wrong order, we have a
fix pending for it. git.kernel.org is down right now so I can't link to
it, but it's in the iwlwifi/iwlwifi-next.git tree:

commit 65fe593a519c4d7c62289d3b0a17ca412e95b037
Author: Brandon Misemer <brandon.misemer@intel.com>
Date:   Fri Jun 8 14:59:27 2012 -0700

    iwlwifi: Fix Makefile build order for built-in driver


johannes

