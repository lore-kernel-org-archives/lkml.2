Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab2BQSpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:45:49 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:45489 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752566Ab2BQSpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:45:47 -0500
Message-ID: <1329504344.584.18.camel@joe2Laptop>
Subject: Re: [PATCH] Cleaning up code formatting errors in net/wireless
 pointed out by checkpatch.
From: Joe Perches <joe@perches.com>
To: Luis Felipe Strano Moraes <lfelipe@profusion.mobi>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 17 Feb 2012 10:45:44 -0800
In-Reply-To: <1329492603-3972-1-git-send-email-lfelipe@profusion.mobi>
References: <1329492603-3972-1-git-send-email-lfelipe@profusion.mobi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 07:30 -0800, Luis Felipe Strano Moraes wrote:
> These are mostly minor changes and they are being sent as one patch only in
> order to cause the smallest amount of disruption.
[]
> diff --git a/net/wireless/core.c b/net/wireless/core.c
[]
> @@ -668,7 +668,7 @@ void wiphy_unregister(struct wiphy *wiphy)
>  		mutex_lock(&rdev->devlist_mtx);
>  		__count = rdev->opencount;
>  		mutex_unlock(&rdev->devlist_mtx);
> -		__count == 0;}));
> +		__count == 0; }));

Inline statement expressions are pretty unusual
for kernel sources.  Normally these are used via
macro.

I'd try to make the statement expression visually
distinct.  Something like:

	wait_event(rdev->dev_wait,
		   ({
			   int __count;
			   mutex_lock(&rdev->devlist_mtx);
			   __count = rdev->opencount;
			   mutex_unlock(&rdev->devlist_mtx);
			   __count == 0;
		   })
		  );


