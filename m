Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab1F1V1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 17:27:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab1F1V0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 17:26:51 -0400
Date: Tue, 28 Jun 2011 14:21:48 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>, driverdevel <devel@driverdev.osuosl.org>,
        linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@gmail.com>, Joe Perches <joe@perches.com>,
        Naveen Singh <nsingh@atheros.com>
Subject: Re: staging: fix ath6kl build when CFG80211 is not enabled
Message-ID: <20110628212148.GA27939@suse.de>
References: <20110527130321.18a51d63.randy.dunlap@oracle.com>
 <20110628200656.GA7992@kroah.com>
 <4E0A3BC8.6000504@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0A3BC8.6000504@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 01:38:32PM -0700, Randy Dunlap wrote:
> On 06/28/11 13:06, Greg KH wrote:
> > On Fri, May 27, 2011 at 01:03:21PM -0700, Randy Dunlap wrote:
> >>
> >> From: Randy Dunlap <randy.dunlap@oracle.com>
> >>
> >> Fix build errors when CONFIG_CFG80211 is not enabled:
> >>
> >> drivers/built-in.o: In function `ar6k_cfg80211_deinit':
> >> (.text+0x189b71): undefined reference to `cfg80211_scan_done'
> >> drivers/built-in.o: In function `ar6k_cfg80211_deinit':
> >> (.text+0x189b86): undefined reference to `wiphy_unregister'
> >> drivers/built-in.o: In function `ar6k_cfg80211_deinit':
> >> (.text+0x189b8d): undefined reference to `wiphy_free'
> >> drivers/built-in.o: In function `ar6k_cfg80211_init':
> >> (.text+0x18add7): undefined reference to `wiphy_new'
> >> drivers/built-in.o: In function `ar6k_cfg80211_init':
> >> (.text+0x18ae48): undefined reference to `wiphy_register'
> >> drivers/built-in.o: In function `ar6k_cfg80211_tkip_micerr_event':
> >> (.text+0x18ae95): undefined reference to `cfg80211_michael_mic_failure'
> >> drivers/built-in.o: In function `ar6k_cfg80211_scan_node':
> >> (.text+0x18afb5): undefined reference to `__ieee80211_get_channel'
> >> drivers/built-in.o: In function `ar6k_cfg80211_scan_node':
> >> (.text+0x18afd2): undefined reference to `cfg80211_inform_bss_frame'
> >> drivers/built-in.o: In function `ar6k_cfg80211_disconnect_event':
> >> (.text+0x18b046): undefined reference to `cfg80211_ibss_joined'
> >> drivers/built-in.o: In function `ar6k_cfg80211_disconnect_event':
> >> (.text+0x18b176): undefined reference to `cfg80211_connect_result'
> >> drivers/built-in.o: In function `ar6k_cfg80211_disconnect_event':
> >> (.text+0x18b190): undefined reference to `cfg80211_disconnected'
> >> drivers/built-in.o: In function `ar6k_cfg80211_connect_event':
> >> (.text+0x18b291): undefined reference to `cfg80211_get_bss'
> >> drivers/built-in.o: In function `ar6k_cfg80211_connect_event':
> >> (.text+0x18b457): undefined reference to `cfg80211_put_bss'
> >> drivers/built-in.o: In function `ar6k_cfg80211_connect_event':
> >> (.text+0x18b4fa): undefined reference to `cfg80211_roamed'
> >>
> >> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> >> Cc: Luis R. Rodriguez <mcgrof@gmail.com>
> >> Cc: Joe Perches <joe@perches.com>
> >> Cc: Naveen Singh <nsingh@atheros.com>
> >> ---
> >>  drivers/staging/ath6kl/Kconfig |    1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> --- linux-next-20110517.orig/drivers/staging/ath6kl/Kconfig
> >> +++ linux-next-20110517/drivers/staging/ath6kl/Kconfig
> >> @@ -1,6 +1,7 @@
> >>  config ATH6K_LEGACY
> >>  	tristate "Atheros AR6003 support (non mac80211)"
> >>          depends on MMC && WLAN
> >> +	depends on CFG80211
> > 
> > Is this still needed in the next linux-next release?
> 
> It's already there, isn't it?
> 
> config ATH6K_LEGACY
> 	tristate "Atheros AR6003 support (non mac80211)"
>         depends on MMC && WLAN
> 	depends on CFG80211
>         select WIRELESS_EXT
>         select WEXT_PRIV

I thought so, hence my confusion :)
