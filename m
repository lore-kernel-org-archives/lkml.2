Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044Ab1KWBzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:55:15 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:35276 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab1KWBzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 20:55:13 -0500
Date: Wed, 23 Nov 2011 10:55:03 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111123015503.GC23203@gamma.logic.tuwien.ac.at>
References: <CANUX_P2AA5stHwjegKdFhFGg7jxwdVU2Xr8OUtXUdEOKz_6E5A@mail.gmail.com> <20111122051310.GA23705@gamma.logic.tuwien.ac.at> <CANUX_P1RjcRD2tW1A6YYSEV9+aUZyTEro7tZXJWRoxk6gx-2jA@mail.gmail.com> <CANUX_P2aFn84uSqgZA2gTBN7E4+0jGmJQTkx4eug4Ls0hK0==Q@mail.gmail.com> <20111122072730.GA32225@gamma.logic.tuwien.ac.at> <CANUX_P15En9bHVx4bhq6=XKPZnC2u+QyVJ+jnm4ns=39DrOBtg@mail.gmail.com> <2D0C7905-AEB2-4DE4-89B1-945D89F2B5D6@logic.at> <CANUX_P21PDdyo4u-x_1A0Lcqf-33yHgzUxddAoc3juGRNnrcDg@mail.gmail.com> <20111122124357.GA32440@gamma.logic.tuwien.ac.at> <CANUX_P0uyyuK4netV6srYCh9FsC4cpGzxobHE3T38n5RvvA0RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUX_P0uyyuK4netV6srYCh9FsC4cpGzxobHE3T38n5RvvA0RQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 22 Nov 2011, Emmanuel Grumbach wrote:
> This is completely broken. This log looks really bad. AGG are enabled
> and disabled right away, messing the queues completely.

I can easily reproduce that here, today after reboot I saw something more:
[   82.894328] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate 
AC/CMD Queue 11 on FIFO 0
[   83.072243] iwlwifi 0000:06:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 85 packets in HW queue
[  288.039768] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
[  288.039884] wlan0: deauthenticating from 00:0a:79:eb:56:10 by local choice (reason=3)
[  288.040218] iwlwifi 0000:06:00.0: I iwl_stop_queue Stop hwq 2 ac 2 stop count 1. Queue is full
[  288.052312] iwlwifi 0000:06:00.0: I iwl_wake_queue Wake hwq 2 ac 2. Packets reclaimed
[  288.052542] iwlwifi 0000:06:00.0: I iwl_stop_queue Stop hwq 2 ac 2 stop count 1. Queue is full
[  288.064074] iwlwifi 0000:06:00.0: I iwl_wake_queue Wake hwq 2 ac 2. Packets reclaimed
[  288.064301] iwlwifi 0000:06:00.0: I iwl_stop_queue Stop hwq 2 ac 2 stop count 1. Queue is full
[  288.074618] iwlwifi 0000:06:00.0: I iwl_wake_queue Wake hwq 2 ac 2. Packets reclaimed

> Will send another patch later.

Thanks.

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
FORSINAIN (n. archaic)
The right of the lord of the manor to molest dwarves on their
birthdays.
			--- Douglas Adams, The Meaning of Liff
