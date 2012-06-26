Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab2FZSDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 14:03:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9391 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab2FZSDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 14:03:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6754"; a="204823691"
X-IronPort-AV: E=Sophos;i="4.77,478,1336374000"; 
   d="scan'208";a="334907847"
Date: Tue, 26 Jun 2012 11:03:11 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: "Ren, Cloud" <cjren@qca.qualcomm.com>
CC: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <qca-linux-team@qualcomm.com>,
        <nic-devel@qualcomm.com>, xiong <xiong@qca.qualcomm.com>
Subject: Re: [PATCH 1/1] atl1c: fix issue of transmit queue 0 timed out
Message-ID: <20120626180311.GC5070@tux>
References: <1340724786-3819-1-git-send-email-cjren@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1340724786-3819-1-git-send-email-cjren@qca.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 12:33:06PM -0300, Ren, Cloud wrote:
> From: xiong <xiong@qca.qualcomm.com>
> 
> some people report atl1c could cause system hang with following
> kernel trace info:
> ---------------------------------------
> WARNING: at.../net/sched/sch_generic.c:258
> dev_watchdog+0x1db/0x1d0()
> ...
> NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
> ...
> ---------------------------------------
> This is caused by netif_stop_queue calling when cable Link is down
> but netif_wake_queue isn't called when cable Link is resume.
> 
> Signed-off-by: xiong <xiong@qca.qualcomm.com>
> Signed-off-by: Cloud Ren <cjren@qca.qualcomm.com>

If this fixes  a system hang then this could be a stable
fix -- that is, this should be propagated to older stable
kernels, no?

If so then please add to the commit log a line like this:

Cc: stable@vger.kernel.org [3.4]

Note: this is for the commit log! Right above the line below
that has "---"

  Luis
