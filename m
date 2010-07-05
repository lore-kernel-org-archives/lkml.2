Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317Ab0GEMfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 08:35:32 -0400
Received: from smtp.nokia.com ([192.100.105.134]:21853 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab0GEMfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 08:35:30 -0400
Subject: Re: [PATCH] sunrpc: make the cache cleaner workqueue deferrable
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1277996756-8415-1-git-send-email-dedekind1@gmail.com>
References: <1277996756-8415-1-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Jul 2010 15:31:30 +0300
Message-ID: <1278333090.29620.47.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Jul 2010 12:35:07.0205 (UTC) FILETIME=[800C9750:01CB1C3E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 18:05 +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> This patch makes the cache_cleaner workqueue deferrable, to prevent
> unnecessary system wake-ups, which is very important for embedded
> battery-powered devices.
> 
> do_cache_clean() is called every 30 seconds at the moment, and often
> makes the system wake up from its power-save sleep state. With this
> change, when the workqueue uses a deferrable timer, the
> do_cache_clean() invocation will be delayed and combined with the
> closest "real" wake-up. This improves the power consumption situation.
> 
> Note, I tried to create a DECLARE_DELAYED_WORK_DEFERRABLE() helper
> macro, similar to DECLARE_DELAYED_WORK(), but failed because of the
> way the timer wheel core stores the deferrable flag (it is the
> LSBit in the time->base pointer). My attempt to define a static
> variable with this bit set ended up with the "initializer element is
> not constant" error.
> 
> Thus, I have to use run-time initialization, so I created a new
> cache_initialize() function which is called once when sunrpc is
> being initialized.
> 
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Bruce,

I did some git-logging, and found out that sunrpc stuff goes from you,
from Trond, and from David, and MAINTAINERS also mentions Neil. Whom
should I ping WRT to merging this patch?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

