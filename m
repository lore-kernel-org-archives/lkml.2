Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab1KVH1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 02:27:39 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:51132 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab1KVH1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 02:27:38 -0500
Date: Tue, 22 Nov 2011 16:27:30 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111122072730.GA32225@gamma.logic.tuwien.ac.at>
References: <1320709047.31823.188.camel@wwguy-huron> <20111108043233.GA21171@gamma.logic.tuwien.ac.at> <CANUX_P0Q0wve4D6fZPsMv2Zw=02gb9u+3C2cjRv7UAmWqXnjzw@mail.gmail.com> <CANUX_P06ww42p6N1k_P-Y1KMKOd1QgR_DxVWe19qtsEX2rfWpw@mail.gmail.com> <20111109051152.GA16006@gamma.logic.tuwien.ac.at> <CANUX_P2Yz9bWP_EmU1Acs7Mu2w78CXxO-njhiMt97b0TJHFYiQ@mail.gmail.com> <20111121030640.GI32505@gamma.logic.tuwien.ac.at> <CANUX_P2AA5stHwjegKdFhFGg7jxwdVU2Xr8OUtXUdEOKz_6E5A@mail.gmail.com> <20111122051310.GA23705@gamma.logic.tuwien.ac.at> <CANUX_P2aFn84uSqgZA2gTBN7E4+0jGmJQTkx4eug4Ls0hK0==Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUX_P1RjcRD2tW1A6YYSEV9+aUZyTEro7tZXJWRoxk6gx-2jA@mail.gmail.com> <CANUX_P2aFn84uSqgZA2gTBN7E4+0jGmJQTkx4eug4Ls0hK0==Q@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Emmanuel,

On Di, 22 Nov 2011, Emmanuel Grumbach wrote:
> Please apply the patch attached. It has been submitted upstream but
> hasn't been merged in the tree you use apparently.

Does not apply against current git, as there is no iwl-mac80211.c:
[/usr/src/git-kernel/linux.git] patch -p1 --dry-run < ~/QUEUE_DEBUG.patch 
patching file drivers/net/wireless/iwlwifi/iwl-agn-rx.c
patching file drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
Hunk #1 succeeded at 116 (offset -1 lines).
Hunk #2 succeeded at 840 (offset -4 lines).
patching file drivers/net/wireless/iwlwifi/iwl-agn-tx.c
Hunk #1 succeeded at 800 (offset -13 lines).
patching file drivers/net/wireless/iwlwifi/iwl-debug.h
Hunk #1 succeeded at 151 (offset -15 lines).
Hunk #2 succeeded at 188 (offset -15 lines).
can't find file to patch at input line 78
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
|index 073e827..05b1f0d 100644
|--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
|+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
--------------------------
File to patch: 


> Then please run with set the TXQUEUES debug flag: 0x8000000.

Is this a load options to iwlwifi module (debug=0x..... at module load time?)
or has to be set in /sys/kernel/debug/ieee80211/phy?/iwlwifi/debug/*
somewhere?

> This will give us a better understanding regarding what happens with
> the queues and how they are mapped.

You have seen my remark on RX packages and RX bytes?

> Do you use any SoftAP / P2P feature ? HW queues can be stalled

No. Fixed AP with fixed IP and no special adaptions.

> sometimes when using such configuration. Can it also be that the AP
> that we can't work with has any kind of power save feature (I know
> that this one is hard to answer though :-)) ?

There is AFAIR something that is set after 3hours or so ... not of
importance, but I will check the settings. But then, it was always
working before ;-)

> Forgot to reply on the WARN_ON you saw. Yes I know about it. We seem

Ok, fine. Thus I can forget about it. THanks.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
HARPENDEN (n.)
The coda to a phone conversion, consisting of about eight exchanges,
by which people try gracefully to get off the line.
			--- Douglas Adams, The Meaning of Liff
