Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab1LLGgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 01:36:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61617 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab1LLGgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 01:36:42 -0500
MIME-Version: 1.0
In-Reply-To: <j8fvka$fu0$1@dough.gmane.org>
References: <j881g5$tdf$1@dough.gmane.org> <alpine.DEB.2.00.1110252325090.20273@chino.kir.corp.google.com>
 <j8fvka$fu0$1@dough.gmane.org>
From: =?UTF-8?Q?Mat=C3=ADas_Aguirre?= <matiasaguirre@gmail.com>
Date: Mon, 12 Dec 2011 04:36:20 -0200
Message-ID: <CA+tb8OUHNbhVN_KiEkqXJW1apFoExRM5Vrn=ES5SF3sFoGOMfA@mail.gmail.com>
Subject: Re: wifi iwlagn fails to authenticate after wake from suspend
To: Gene Smith <gds@chartertn.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Oct 29, 2011 at 2:32 AM, Gene Smith <gds@chartertn.net> wrote:
> David Rientjes wrote, On 10/26/2011 02:27 AM:
>> So we need to bisect between 2.4.38 and 3.0.0? :)  I'm running ubuntu
>> 11.10 on a home laptop so I'll give this a try as well when I can if I can
>> put up with unity for that long.

I've bisected the problem and narrowed the bug to changeset 73b78a2272
(http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=73b78a22720087d2d384bdd49e9c25500ba73edd).

Here's a patch, that applies against 3.2-rc5, that fixed the error for me:

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c
b/drivers/net/wireless/iwlwifi/iwl-agn.c
index bacc06c..01d5d38 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1297,7 +1297,7 @@ int iwl_alive_start(struct iwl_priv *priv)
                                         BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
                if (ret)
                        return ret;
-       } else {
+       } else if (priv->cfg->bt_params) {
                /*
                 * default is 2-wire BT coexexistence support
                 */
