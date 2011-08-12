Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab1HLX0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 19:26:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43983 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab1HLXZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 19:25:59 -0400
Message-ID: <4E45B684.6080300@lwfinger.net>
Date: Fri, 12 Aug 2011 18:25:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Mike McCormack <mikem@ring3k.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Stefan Weil <weil@mail.berlios.de>,
        Andrea Merello <andreamrl@tiscali.it>, netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] drivers/staging/rtl8192e: Don't pass huge struct
 by value
References: <alpine.LNX.2.00.1108130058310.7387@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1108130058310.7387@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2011 06:04 PM, Jesper Juhl wrote:
> From: Jesper Juhl<jj@chaosbits.net>
> Date: Sat, 13 Aug 2011 00:52:32 +0200
>
> struct ieee80211_network is fairly large (more than half a kilobyte),
> so let's pass a pointer instead of passing the entire structure by
> value when ieee80211_is_54g() and ieee80211_is_shortslot() need to
> look at a few members.
> Also remove parentheses around the values being returned from those
> two functions - 'return' is not a function.
>
> Signed-off-by: Jesper Juhl<jj@chaosbits.net>
> ---
>   drivers/staging/rtl8192e/ieee80211/ieee80211.h     |    4 ++--
>   .../staging/rtl8192e/ieee80211/ieee80211_softmac.c |   14 +++++++-------
>   2 files changed, 9 insertions(+), 9 deletions(-)

This patch is a good one; however, in Greg's pile of unmerged patches is a 
completely different driver for the RTL8192E. The new driver has the advantage 
of being organized much more like the drivers in rtlwifi. That will make it 
easier to convert to mac80211 and move to mainline.

I also have a lot of unsubmitted patches to clean up the code in the new driver. 
At the moment, it is clear of 'checkpatch -f' errors, and most warnings. In 
addition, many of the sparse warnings are fixed. Once Greg merges the patches 
already submitted, I will send the others.

Larry

