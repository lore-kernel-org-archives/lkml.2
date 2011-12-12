Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab1LLOz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:55:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:4007 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193Ab1LLOz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:55:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95223173"
Subject: Re: wifi iwlagn fails to authenticate after wake from suspend
From: wwguy <wey-yi.w.guy@intel.com>
To: =?ISO-8859-1?Q?Mat=EDas?= Aguirre <matiasaguirre@gmail.com>
Cc: Gene Smith <gds@chartertn.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CA+tb8OUHNbhVN_KiEkqXJW1apFoExRM5Vrn=ES5SF3sFoGOMfA@mail.gmail.com>
References: <j881g5$tdf$1@dough.gmane.org>
	 <alpine.DEB.2.00.1110252325090.20273@chino.kir.corp.google.com>
	 <j8fvka$fu0$1@dough.gmane.org>
	 <CA+tb8OUHNbhVN_KiEkqXJW1apFoExRM5Vrn=ES5SF3sFoGOMfA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Dec 2011 06:48:42 -0800
Message-ID: <1323701322.1806.24.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-11 at 22:36 -0800, Matías Aguirre wrote:
> Hi,
> 
> On Sat, Oct 29, 2011 at 2:32 AM, Gene Smith <gds@chartertn.net> wrote:
> > David Rientjes wrote, On 10/26/2011 02:27 AM:
> >> So we need to bisect between 2.4.38 and 3.0.0? :)  I'm running ubuntu
> >> 11.10 on a home laptop so I'll give this a try as well when I can if I can
> >> put up with unity for that long.
> 
> I've bisected the problem and narrowed the bug to changeset 73b78a2272
> (http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=73b78a22720087d2d384bdd49e9c25500ba73edd).
> 
> Here's a patch, that applies against 3.2-rc5, that fixed the error for me:
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c
> b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index bacc06c..01d5d38 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -1297,7 +1297,7 @@ int iwl_alive_start(struct iwl_priv *priv)
>                                          BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
>                 if (ret)
>                         return ret;
> -       } else {
> +       } else if (priv->cfg->bt_params) {
>                 /*
>                  * default is 2-wire BT coexexistence support
>                  */
this is not right, you stop the bt coex for non-combo device.
maybe you system has issue with BT, we seen this happen on some cases.
try the following module parameter and see if help

$sudo modprobe iwlagn bt_coex_active=0

Thanks
Wey

