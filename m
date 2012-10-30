Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab2J3K0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:26:36 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:38600 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331Ab2J3K0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:26:34 -0400
Message-ID: <508FB970.8070703@atmel.com>
Date: Tue, 30 Oct 2012 12:26:40 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <havard@skinnemoen.net>,
        <bhutchings@solarflare.com>, <linux-arm-kernel@lists.infradead.org>,
        <plagnioj@jcrosoft.com>, <patrice.vilchez@atmel.com>,
        <linux-kernel@vger.kernel.org>, <manabian@gmail.com>
Subject: Re: [PATCH v3 00/10] net/macb: driver enhancement concerning GEM
 support, ring logic and cleanup
References: <cover.1351591858.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1351591858.git.nicolas.ferre@atmel.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2012 11:17 AM, Nicolas Ferre :
> This is an enhancement work that began several years ago. I try to catchup with
> some performance improvement that has been implemented then by Havard.
> The ring index logic and the TX error path modification are the biggest changes
> but some cleanup/debugging have been added along the way.
> The GEM revision will benefit from the Gigabit support.
> Newer pinctrl infrastructure support is added but it is optional.
> 
> The series has been tested on several Atmel AT91 SoC with the two MACB/GEM
> flavors.
> 
> v3: - rebased on net-next to take into account current effor to merge
>       at91_ether with macb drivers
>     - add additional patch to use the new pinctrl infrastructure
> v2: - modify the tx error handling: now uses a workqueue
>     - information provided by ethtool -i were not accurate: removed

David, if you feel more comfortable with a git branch (I can also 
cook a signed tag if you want), here it is:


The following changes since commit a932657f51eadb8280166e82dc7034dfbff3985a:

  net: sierra: shut up sparse restricted type warnings (2012-10-28 19:09:02 -0400)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git net-next_macb_enhancement3

for you to fetch changes up to 3269426bdd44debc00d027651f8248db9d40f3dc:

  net/macb: add pinctrl consumer support (2012-10-30 11:08:10 +0100)

----------------------------------------------------------------
Havard Skinnemoen (4):
      net/macb: memory barriers cleanup
      net/macb: change debugging messages
      net/macb: clean up ring buffer logic
      net/macb: Offset first RX buffer by two bytes

Jean-Christophe PLAGNIOL-VILLARD (1):
      net/macb: add pinctrl consumer support

Nicolas Ferre (4):
      net/macb: remove macb_get_drvinfo()
      net/macb: tx status is more than 8 bits now
      net/macb: ethtool interface: add register dump feature
      net/macb: better manage tx errors

Patrice Vilchez (1):
      net/macb: Add support for Gigabit Ethernet mode

 drivers/net/ethernet/cadence/macb.c | 446 ++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------
 drivers/net/ethernet/cadence/macb.h |  30 ++++--
 2 files changed, 334 insertions(+), 142 deletions(-)


Thanks, best regards,
-- 
Nicolas Ferre
