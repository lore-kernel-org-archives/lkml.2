Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab1HDVrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 17:47:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202Ab1HDVq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 17:46:56 -0400
Date: Thu, 4 Aug 2011 23:46:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Bojan Prtvar <prtvar.b@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] HID: kfree() NULL pointer cleanup
In-Reply-To: <1312490626-14838-1-git-send-email-prtvar.b@gmail.com>
Message-ID: <alpine.LNX.2.00.1108042346450.32288@pobox.suse.cz>
References: <1312490626-14838-1-git-send-email-prtvar.b@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Aug 2011, Bojan Prtvar wrote:

> Checking for NULL pointers before kfree() is redundant.
> 
> Signed-off-by: Bojan Prtvar <prtvar.b@gmail.com>
> ---
>  drivers/hid/hid-zydacron.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/hid-zydacron.c b/drivers/hid/hid-zydacron.c
> index e903715..1ad85f2 100644
> --- a/drivers/hid/hid-zydacron.c
> +++ b/drivers/hid/hid-zydacron.c
> @@ -201,9 +201,7 @@ static void zc_remove(struct hid_device *hdev)
>  	struct zc_device *zc = hid_get_drvdata(hdev);
>  
>  	hid_hw_stop(hdev);
> -
> -	if (NULL != zc)
> -		kfree(zc);
> +	kfree(zc);
>  }

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
