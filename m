Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab1KHIYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 03:24:23 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45874 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab1KHIYU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 03:24:20 -0500
MIME-Version: 1.0
In-Reply-To: <CANUX_P06ww42p6N1k_P-Y1KMKOd1QgR_DxVWe19qtsEX2rfWpw@mail.gmail.com>
References: <20111021012442.GB26758@gamma.logic.tuwien.ac.at>
	<alpine.DEB.2.00.1110231424500.17218@chino.kir.corp.google.com>
	<20111026025014.GB24956@gamma.logic.tuwien.ac.at>
	<1319601333.14693.19.camel@wwguy-ubuntu>
	<20111026040332.GF24956@gamma.logic.tuwien.ac.at>
	<20111102031345.GA10851@gamma.logic.tuwien.ac.at>
	<1320204101.31823.140.camel@wwguy-huron>
	<20111104045817.GA25778@gamma.logic.tuwien.ac.at>
	<20111107123812.GB23508@gamma.logic.tuwien.ac.at>
	<1320709047.31823.188.camel@wwguy-huron>
	<20111108043233.GA21171@gamma.logic.tuwien.ac.at>
	<CANUX_P06ww42p6N1k_P-Y1KMKOd1QgR_DxVWe19qtsEX2rfWpw@mail.gmail.com>
Date: Tue, 8 Nov 2011 10:24:18 +0200
Message-ID: <CANUX_P0Q0wve4D6fZPsMv2Zw=02gb9u+3C2cjRv7UAmWqXnjzw@mail.gmail.com>
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
        Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 10:07, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>
>> In short, this is the output of your patch:
>> [  215.872090] iwlwifi 0000:06:00.0: Queue 11 stuck for 10000 ms.
>> [  215.872101] iwlwifi 0000:06:00.0: Current SW read_ptr 105 write_ptr 115
>> [  215.872156] iwlwifi 0000:06:00.0: Current HW read_ptr 105 write_ptr 115
>> [  215.872164] iwlwifi 0000:06:00.0: On demand firmware reload
>>
>>
> Ok thanks for that. The HW and the SW agree then...
>
> I would like to see what happens in terms or power.
> Please set the power debug flag: modprobe iwlwifi debug=0x100
>
> Thanks.
>

It may be worth to disable Link Power save too. I would be glad if you
could try this patch (attached and inlined), with the power debug flag
set.


diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c
b/drivers/net/wireless/iwlwifi/iwl-power.c
index 4eaab20..e5f309b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -436,7 +436,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 /* initialize to default */
 void iwl_power_initialize(struct iwl_priv *priv)
 {
-	priv->power_data.bus_pm = bus_get_pm_support(bus(priv));
+	priv->power_data.bus_pm = false;

 	priv->power_data.debug_sleep_level_override = -1;



Thanks for your patience !
