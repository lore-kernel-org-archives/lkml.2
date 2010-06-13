Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab0FMIFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 04:05:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:23922 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704Ab0FMIF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 04:05:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,410,1272870000"; 
   d="scan'208";a="807448469"
Message-ID: <4C149147.3080808@intel.com>
Date: Sun, 13 Jun 2010 01:05:27 -0700
From: John Fastabend <john.r.fastabend@intel.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: "markus@trippelsdorf.de" <markus@trippelsdorf.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: mpd client timeouts (bisected) 2.6.35-rc3
References: <20100612102802.GA1782@arch.tripp.de> <20100612.145835.123986343.davem@davemloft.net>
In-Reply-To: <20100612.145835.123986343.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Markus Trippelsdorf <markus@trippelsdorf.de>
> Date: Sat, 12 Jun 2010 12:28:02 +0200
> 
>> Commit 597a264b1a9c7e36d1728f677c66c5c1f7e3b837:
>> »net: deliver skbs on inactive slaves to exact matches«
>>
>> causes large timeouts when mpd clients try to connect to a locally
>> running mpd (music player demon) on my machine. This makes it 
>> impossible to control mpd.
>>
>> I bisected this down to the commit mentioned above.
>> Reverting the commit from 2.6.35-rc3 also solves the problem.
> 
> John, find an easy and fast way to fix this or else I am
> going to revert.
> 
> Thanks.

Looks like skbs are hitting loopback_xmit() with deliver_no_wcard set.  Then in 
the receive path these skbs are only delivered to exact matches.  Not sure why 
this bit is set here, I'll track this down first thing tomorrow.

Thanks,
John.
