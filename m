Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab1JQTgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 15:36:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:5192 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab1JQTge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 15:36:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,360,1315206000"; 
   d="scan'208";a="63444265"
Subject: Re: 3.1.0-rc9+ : wlan stops working w/o any error messages
From: wwguy <wey-yi.w.guy@intel.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: David Rientjes <rientjes@google.com>, werner <w.landgraf@ru.ru>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <201110170952.43916.toralf.foerster@gmx.de>
References: <201110152119.58509.toralf.foerster@gmx.de>
	 <alpine.DEB.2.00.1110151416360.15894@chino.kir.corp.google.com>
	 <201110170931.59534.toralf.foerster@gmx.de>
	 <201110170952.43916.toralf.foerster@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Oct 2011 12:30:47 -0700
Message-ID: <1318879847.17584.3.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 00:52 -0700, Toralf Förster wrote:
> Toralf Förster wrote at 09:31:58
> > > What does "iwconfig" show?
> 
> And this is the state if the netwerk stops working :
> 
> wlan0     IEEE 802.11abgn  ESSID:"IBM"  
>           Mode:Managed  Frequency:2.462 GHz  Access Point: 00:21:55:AC:8B:80   
>           Bit Rate=54 Mb/s   Tx-Power=15 dBm   
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
>           Link Quality=45/70  Signal level=-65 dBm  
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:77   Missed beacon:0
> 
> 
When the problem happen, could you please dump the tx_queue status in
debugfs and send us the information

In order to dump the the tx_queue, please do the following
1. make sure you compile your kernel with CONFIG_IWLWIFI_DEBUGFS=y
2. unload and reload the "iwlagn" module
3. cd to /sys/kernel/debug/ieee80211/phyX/iwlwifi/debug (phX: "X" based
on your system)
4. "$sudo cat tx_queue" to show the current tx queue status

Thanks
Wey



