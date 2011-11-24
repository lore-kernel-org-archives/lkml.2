Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab1KXGrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 01:47:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56270 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab1KXGrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 01:47:41 -0500
MIME-Version: 1.0
In-Reply-To: <20111123015503.GC23203@gamma.logic.tuwien.ac.at>
References: <CANUX_P2AA5stHwjegKdFhFGg7jxwdVU2Xr8OUtXUdEOKz_6E5A@mail.gmail.com>
	<20111122051310.GA23705@gamma.logic.tuwien.ac.at>
	<CANUX_P1RjcRD2tW1A6YYSEV9+aUZyTEro7tZXJWRoxk6gx-2jA@mail.gmail.com>
	<CANUX_P2aFn84uSqgZA2gTBN7E4+0jGmJQTkx4eug4Ls0hK0==Q@mail.gmail.com>
	<20111122072730.GA32225@gamma.logic.tuwien.ac.at>
	<CANUX_P15En9bHVx4bhq6=XKPZnC2u+QyVJ+jnm4ns=39DrOBtg@mail.gmail.com>
	<2D0C7905-AEB2-4DE4-89B1-945D89F2B5D6@logic.at>
	<CANUX_P21PDdyo4u-x_1A0Lcqf-33yHgzUxddAoc3juGRNnrcDg@mail.gmail.com>
	<20111122124357.GA32440@gamma.logic.tuwien.ac.at>
	<CANUX_P0uyyuK4netV6srYCh9FsC4cpGzxobHE3T38n5RvvA0RQ@mail.gmail.com>
	<20111123015503.GC23203@gamma.logic.tuwien.ac.at>
Date: Thu, 24 Nov 2011 08:47:39 +0200
Message-ID: <CANUX_P1zDDzMy5yrFXSZAkMQ-87uu-fE1e-2sCEgHJi4dh5eiw@mail.gmail.com>
Subject: Re: iwlagn is getting very shaky
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 03:55, Norbert Preining <preining@logic.at> wrote:
> On Di, 22 Nov 2011, Emmanuel Grumbach wrote:
>> This is completely broken. This log looks really bad. AGG are enabled
>> and disabled right away, messing the queues completely.
>
> I can easily reproduce that here, today after reboot I saw something more:
> [   82.894328] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate
> AC/CMD Queue 11 on FIFO 0
> [   83.072243] iwlwifi 0000:06:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 85 packets in HW queue
> [  288.039768] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [  288.039884] wlan0: deauthenticating from 00:0a:79:eb:56:10 by local choice (reason=3)
> [  288.040218] iwlwifi 0000:06:00.0: I iwl_stop_queue Stop hwq 2 ac 2 stop count 1. Queue is full
> [  288.052312] iwlwifi 0000:06:00.0: I iwl_wake_queue Wake hwq 2 ac 2. Packets reclaimed
> [  288.052542] iwlwifi 0000:06:00.0: I iwl_stop_queue Stop hwq 2 ac 2 stop count 1. Queue is full
> [  288.064074] iwlwifi 0000:06:00.0: I iwl_wake_queue Wake hwq 2 ac 2. Packets reclaimed
> [  288.064301] iwlwifi 0000:06:00.0: I iwl_stop_queue Stop hwq 2 ac 2 stop count 1. Queue is full
> [  288.074618] iwlwifi 0000:06:00.0: I iwl_wake_queue Wake hwq 2 ac 2. Packets reclaimed
>
>> Will send another patch later.
>

Please apply the patch attached on top of the one I previously sent.
Let me know I you have trouble with patch.
Please also enable the MAC80211_HT_DEBUG compilation flag
I also the (HT + TXQUEUES) debug flag of the driver: modprobe iwlwifi
debug=0x84000000

Thanks
