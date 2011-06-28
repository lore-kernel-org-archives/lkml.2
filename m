Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab1F1UVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 16:21:31 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57526 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118Ab1F1UVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 16:21:24 -0400
X-Sasl-enc: acm8WJ9BooH5oFjhuj1PY/VMYaASnyZmt0Oan46KEPTR 1309292483
Date: Tue, 28 Jun 2011 13:06:56 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: driverdevel <devel@driverdev.osuosl.org>, gregkh@suse.de,
        linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@gmail.com>, Joe Perches <joe@perches.com>,
        Naveen Singh <nsingh@atheros.com>
Subject: Re: staging: fix ath6kl build when CFG80211 is not enabled
Message-ID: <20110628200656.GA7992@kroah.com>
References: <20110527130321.18a51d63.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527130321.18a51d63.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 01:03:21PM -0700, Randy Dunlap wrote:
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix build errors when CONFIG_CFG80211 is not enabled:
> 
> drivers/built-in.o: In function `ar6k_cfg80211_deinit':
> (.text+0x189b71): undefined reference to `cfg80211_scan_done'
> drivers/built-in.o: In function `ar6k_cfg80211_deinit':
> (.text+0x189b86): undefined reference to `wiphy_unregister'
> drivers/built-in.o: In function `ar6k_cfg80211_deinit':
> (.text+0x189b8d): undefined reference to `wiphy_free'
> drivers/built-in.o: In function `ar6k_cfg80211_init':
> (.text+0x18add7): undefined reference to `wiphy_new'
> drivers/built-in.o: In function `ar6k_cfg80211_init':
> (.text+0x18ae48): undefined reference to `wiphy_register'
> drivers/built-in.o: In function `ar6k_cfg80211_tkip_micerr_event':
> (.text+0x18ae95): undefined reference to `cfg80211_michael_mic_failure'
> drivers/built-in.o: In function `ar6k_cfg80211_scan_node':
> (.text+0x18afb5): undefined reference to `__ieee80211_get_channel'
> drivers/built-in.o: In function `ar6k_cfg80211_scan_node':
> (.text+0x18afd2): undefined reference to `cfg80211_inform_bss_frame'
> drivers/built-in.o: In function `ar6k_cfg80211_disconnect_event':
> (.text+0x18b046): undefined reference to `cfg80211_ibss_joined'
> drivers/built-in.o: In function `ar6k_cfg80211_disconnect_event':
> (.text+0x18b176): undefined reference to `cfg80211_connect_result'
> drivers/built-in.o: In function `ar6k_cfg80211_disconnect_event':
> (.text+0x18b190): undefined reference to `cfg80211_disconnected'
> drivers/built-in.o: In function `ar6k_cfg80211_connect_event':
> (.text+0x18b291): undefined reference to `cfg80211_get_bss'
> drivers/built-in.o: In function `ar6k_cfg80211_connect_event':
> (.text+0x18b457): undefined reference to `cfg80211_put_bss'
> drivers/built-in.o: In function `ar6k_cfg80211_connect_event':
> (.text+0x18b4fa): undefined reference to `cfg80211_roamed'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Luis R. Rodriguez <mcgrof@gmail.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Naveen Singh <nsingh@atheros.com>
> ---
>  drivers/staging/ath6kl/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20110517.orig/drivers/staging/ath6kl/Kconfig
> +++ linux-next-20110517/drivers/staging/ath6kl/Kconfig
> @@ -1,6 +1,7 @@
>  config ATH6K_LEGACY
>  	tristate "Atheros AR6003 support (non mac80211)"
>          depends on MMC && WLAN
> +	depends on CFG80211

Is this still needed in the next linux-next release?

confused,

greg k-h
