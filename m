Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab0FSMpN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 08:45:13 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:3122 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab0FSMpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 08:45:11 -0400
Date: Sat, 19 Jun 2010 08:38:41 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, ath5k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ath5k: disable ASPM
Message-ID: <20100619123841.GA31838@hash.localnet>
References: <20100528100901.14580.1322.stgit@fate.lan> <1276806785.20754.8.camel@maxim-laptop> <20100618112026.17623g6uhdjk8hts@naisho.dyndns.info> <1276856142.9114.1.camel@maxim-laptop> <20100618134930.124225d4fsi8w1fk@naisho.dyndns.info> <1276859156.19554.2.camel@maxim-laptop> <AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com> <1276870309.23783.3.camel@maxim-laptop> <1276933774.16697.11.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276933774.16697.11.camel@maxim-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 10:49:34AM +0300, Maxim Levitsky wrote:
> How this patch?

Looks fine to me.  Some nitpicking below but feel free to add my

Acked-by: Bob Copeland <me@bobcopeland.com>

to this or a later version.

>     Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>     Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

I believe maintaining the s-o-b is usually reserved for the case when the
patch only has minor edits; here your patch while same in spirit has
some 30 fewer lines.  Maybe should use "From:" or mention Jussi in the
commit log to maintain attribution instead?

> +	/* Disable PCIE ASPM L0S. It is never enabled by windows driver */
> +	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
> +

Would be good to expand this comment as to why (just copy another
sentence from the commit log or so).

>  	ret = pci_enable_device(pdev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "can't enable device\n");
> @@ -722,6 +726,8 @@ static int ath5k_pci_resume(struct device *dev)
>  	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
>  	struct ath5k_softc *sc = hw->priv;
>  
> +	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
> +

Did you test that it did get lost over suspend/resume?  A glance at
pci_save_pcie_state seems to indicate it's saved.

-- 
Bob Copeland %% www.bobcopeland.com

