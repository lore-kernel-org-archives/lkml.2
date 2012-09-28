Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab2I1BTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 21:19:45 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46190 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab2I1BTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 21:19:42 -0400
Date: Thu, 27 Sep 2012 18:17:00 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 46/57] power: chargealg: Realign with upstream version
Message-ID: <20120928011700.GF5040@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-47-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-47-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:43AM -0600, mathieu.poirier@linaro.org wrote:
> From: Loic Pallardy <loic.pallardy@stericsson.com>
> 
> Upstream version of AB charge algo has been reverted
> during kernel 3.4 port.

Why it's been reverted in the first place?.. If you're just reverting what
has been reverted before, you're probably breaking things again, so the
patch would [temporary] introduce some breakage?

> This patch restore state by:
> - renaming ab8500_chargal.c in abx500_chargal.c
> - renaming function from ab8500 to abx500
> - moving generic structure in "include/mfd/abx500.h"
> 
> Goal is to ease next code reversion and realignment
> with mainline

I still hardly understand the rationale behind this change. But if it
compiles, bisectionable and works... it's fine by me. :-)

> 
> Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
> ---
>  drivers/power/ab8500_charger.c       |  166 +++++++++++-----------------------
>  include/linux/mfd/abx500.h           |   10 ++-
>  include/linux/mfd/abx500/ab8500-bm.h |    5 +-
>  3 files changed, 65 insertions(+), 116 deletions(-)
> 
[...]
> @@ -2678,7 +2616,7 @@ static void ab8500_charger_vbus_drop_end_work(struct work_struct *work)
>  {
>  	struct ab8500_charger *di = container_of(work,
>  		struct ab8500_charger, vbus_drop_end_work.work);
> -	int ret;
> +	int ret, curr;

Should be one variable declaration per line.
