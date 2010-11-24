Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab0KXQaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:30:14 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52947 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab0KXQaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:30:12 -0500
Date: Wed, 24 Nov 2010 11:24:36 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bruno Randolf <br1@einfach.org>
Cc: randy.dunlap@oracle.com, br1@thinktube.com, peterz@infradead.org,
        blp@cs.stanford.edu, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        stefanr@s5r6.in-berlin.de, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com
Subject: Re: [PATCH v8 3/3] nl80211/mac80211: Report signal average
Message-ID: <20101124162435.GB7435@tuxdriver.com>
References: <20101116015837.21081.79264.stgit@localhost6.localdomain6>
 <20101116015848.21081.60180.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116015848.21081.60180.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 10:58:48AM +0900, Bruno Randolf wrote:
> Extend nl80211 to report an exponential weighted moving average (EWMA) of the
> signal value. Since the signal value usually fluctuates between different
> packets, an average can be more useful than the value of the last packet.
> 
> This uses the recently added generic EWMA library function.
> 
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  include/linux/nl80211.h |    2 ++
>  include/net/cfg80211.h  |    4 ++++
>  net/mac80211/Kconfig    |    1 +
>  net/mac80211/cfg.c      |    3 ++-
>  net/mac80211/rx.c       |    1 +
>  net/mac80211/sta_info.c |    2 ++
>  net/mac80211/sta_info.h |    3 +++
>  net/wireless/nl80211.c  |    3 +++
>  8 files changed, 18 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index fb877b5..0ceb552 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -1132,6 +1132,7 @@ enum nl80211_rate_info {
>   * @__NL80211_STA_INFO_AFTER_LAST: internal
>   * @NL80211_STA_INFO_MAX: highest possible station info attribute
>   * @NL80211_STA_INFO_SIGNAL: signal strength of last received PPDU (u8, dBm)
> + * @NL80211_STA_INFO_SIGNAL_AVG: signal strength average (u8, dBm)
>   * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate, nested attribute
>   * 	containing info as possible, see &enum nl80211_sta_info_txrate.
>   * @NL80211_STA_INFO_RX_PACKETS: total received packet (u32, from this station)
> @@ -1149,6 +1150,7 @@ enum nl80211_sta_info {
>  	NL80211_STA_INFO_PLID,
>  	NL80211_STA_INFO_PLINK_STATE,
>  	NL80211_STA_INFO_SIGNAL,
> +	NL80211_STA_INFO_SIGNAL_AVG,
>  	NL80211_STA_INFO_TX_BITRATE,
>  	NL80211_STA_INFO_RX_PACKETS,
>  	NL80211_STA_INFO_TX_PACKETS,

It's been pointed-out that this breaks kernel->userland ABI.

That could be fixed rather easily, but due to the performance concerns
I'm going to just revert this one for now.  Please correct the ABI
issue when submitting a new version that addresses the performance
concerns raised by Jouni.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
