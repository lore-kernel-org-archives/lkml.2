Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab1LVImQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:42:16 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9003 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab1LVImM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:42:12 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6567"; a="146837931"
X-IronPort-AV: E=Sophos;i="4.71,391,1320652800"; 
   d="scan'208";a="156832383"
Message-ID: <4EF2ECA0.2080501@qca.qualcomm.com>
Date: Thu, 22 Dec 2011 10:38:56 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "John W. Linville" <linville@tuxdriver.com>, Michal Marek <mmarek@suse.cz>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: linux-next: build failure after merge of the final tree (wireless
 tree related)
References: <20111222165849.df5ea3e2997375de24f1490b@canb.auug.org.au>
In-Reply-To: <20111222165849.df5ea3e2997375de24f1490b@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.4.123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

I'll add linux-wireless and ath6kl-devel as I'm sick today and hopefully
someone else from our team will take a look at it.

On 12/22/2011 07:58 AM, Stephen Rothwell wrote:

> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/net/wireless/ath/ath6kl/cfg80211.c:27:1: error: expected ')' before 'KBUILD_MODNAME'
> drivers/net/wireless/ath/ath6kl/cfg80211.c:27:1: error: 'KBUILD_MODNAME' undeclared here (not in a function)
> drivers/net/wireless/ath/ath6kl/cfg80211.c:27:1: error: expected ',' or ';' before string constant
> drivers/net/wireless/ath/ath6kl/init.c:32:1: error: expected ')' before 'KBUILD_MODNAME'
> drivers/net/wireless/ath/ath6kl/init.c:32:1: error: 'KBUILD_MODNAME' undeclared here (not in a function)
> drivers/net/wireless/ath/ath6kl/init.c:32:1: error: expected ',' or ';' before string constant
> drivers/net/wireless/ath/ath6kl/init.c:33:1: error: expected ')' before 'KBUILD_MODNAME'
> drivers/net/wireless/ath/ath6kl/init.c:33:1: error: invalid initializer
> drivers/net/wireless/ath/ath6kl/init.c:33:1: error: expected ',' or ';' before string constant
> drivers/net/wireless/ath/ath6kl/init.c:34:1: error: expected ')' before 'KBUILD_MODNAME'
> drivers/net/wireless/ath/ath6kl/init.c:34:1: error: invalid initializer
> drivers/net/wireless/ath/ath6kl/init.c:34:1: error: expected ',' or ';' before string constant
> 
> I can't figure out what goes wrong here.  On the compile command line,
> KBUILD_MODNAME is not defined, but KBUILD_BASE_NAME is.
> 
> However, reverting commit fde57764ef87 ("ath6kl: enable USB support")
> made the problem go away.  That commit caused the above two files to be
> built into two separate modules.

Is this ppc specific problem? Is there anything we should do on ath6kl
to fix this?

Kalle
