Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab0KBNTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 09:19:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45301 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752479Ab0KBNTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 09:19:45 -0400
Date: Tue, 2 Nov 2010 09:19:52 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: regulator disable supply fix
Message-ID: <20101102131952.GC21476@opensource.wolfsonmicro.com>
References: <1288700549-28535-1-git-send-email-mattias.wallin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288700549-28535-1-git-send-email-mattias.wallin@stericsson.com>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 01:22:29PM +0100, Mattias Wallin wrote:
> This patch fixes a disable failure when regulator supply is used.
> A while loop in regulator disable checks for supply pointer != NULL
> but the pointer is not always updated, resulting in the while loop
> running too many times causing a disable failure.

> Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>

Hrm.  This does fix the problem which is needed so:

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> ---
>  drivers/regulator/core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index f1d10c9..dc7d36e 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1424,6 +1424,7 @@ int regulator_disable(struct regulator *regulator)
>  	/* decrease our supplies ref count and disable if required */
>  	while (supply_rdev != NULL) {
>  		rdev = supply_rdev;
> +		supply_rdev = NULL;
>  
>  		mutex_lock(&rdev->mutex);
>  		_regulator_disable(rdev, &supply_rdev);

but this does smell a bit like it ought to be in the _regulator_disable()
call rather than the caller.
