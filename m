Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937294Ab0CPBEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 21:04:39 -0400
Received: from mail-px0-f198.google.com ([209.85.216.198]:44095 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937264Ab0CPBEg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:04:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=R4idDxWrxKi3UnlLfnCp+m6lRddVmKWtbBKRyCsH4abi0ruMcMkScOQo5EA4VyrINM
         laE27+JdG87OgsopplxuRcUPK06ctVt3L13k0aqlveFeehWHjiKCxPB5L0JA+MCkYrqq
         C/IiR1lPJt5gSXh2Nz6ADwTGl2TC7yclkjbSI=
MIME-Version: 1.0
In-Reply-To: <20100313001511.285517122@kvm.kroah.org>
References: <20100313001618.GA9811@kroah.com> <20100313001511.285517122@kvm.kroah.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 15 Mar 2010 18:04:15 -0700
X-Google-Sender-Auth: 3e86075eae270b44
Message-ID: <43e72e891003151804s617659f8o6dcbf0b5ab63cb5d@mail.gmail.com>
Subject: Re: [Stable-review] [patch 070/123] ath9k: re-enable ps by default 
	for new single chip families
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       akpm@linux-foundation.org, Peter Stuge <peter@stuge.se>,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 5:12 PM, Greg KH <gregkh@suse.de> wrote:
> 2.6.33-stable review patch.  If anyone has any objections, please let me know.

This was intended for 2.6.32 as well. Thanks

  Luis
> -----------------
>
> From: Luis R. Rodriguez <lrodriguez@atheros.com>
>
> commit 14acdde6e527950f66c084dbf19bad6fbfcaeedc upstream.
>
> The newer single chip hardware family of chipsets have not been
> experiencing issues with power saving set by default with recent
> fixes merged (even into stable). The remaining issues are only
> reported with AR5416 and since enabling PS by default can increase
> power savings considerably best to take advantage of that feature
> as this has been tested properly.
>
> For more details on this issue see the bug report:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=14267
>
> We leave AR5416 with PS disabled by default, that seems to require
> some more work.
>
> Cc: Peter Stuge <peter@stuge.se>
> Cc: Justin P. Mattock  <justinmattock@gmail.com>
> Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  drivers/net/wireless/ath/ath9k/main.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1849,6 +1849,8 @@ bad_free_hw:
>
>  void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
>  {
> +       struct ath_hw *ah = sc->sc_ah;
> +
>        hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
>                IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
>                IEEE80211_HW_SIGNAL_DBM |
> @@ -1866,7 +1868,8 @@ void ath_set_hw_capab(struct ath_softc *
>                BIT(NL80211_IFTYPE_ADHOC) |
>                BIT(NL80211_IFTYPE_MESH_POINT);
>
> -       hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
> +       if (AR_SREV_5416(ah))
> +               hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
>
>        hw->queues = 4;
>        hw->max_rates = 4;
>
>
> _______________________________________________
> Stable-review mailing list
> Stable-review@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable-review
>
