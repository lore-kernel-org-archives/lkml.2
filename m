Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2A3QCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:02:11 -0500
Received: from [206.117.179.246] ([206.117.179.246]:60910 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753895Ab2A3QCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:02:10 -0500
Message-ID: <1327939311.25132.9.camel@joe2Laptop>
Subject: Re: [PATCH 12/15] ixj: fix Wsequence-point compiler warnings
From: Joe Perches <joe@perches.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 30 Jan 2012 08:01:51 -0800
In-Reply-To: <1327934418-12674-13-git-send-email-danny.kukawka@bisect.de>
References: <1327934418-12674-1-git-send-email-danny.kukawka@bisect.de>
	 <1327934418-12674-13-git-send-email-danny.kukawka@bisect.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 15:40 +0100, Danny Kukawka wrote:
> Fix some Wsequence-point compiler warnings in ixj.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  drivers/telephony/ixj.c |  194 ++++++++++++++++++++++++++---------------------
>  1 files changed, 107 insertions(+), 87 deletions(-)
> 
> diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
> index d5f923b..7d02cae 100644
> --- a/drivers/telephony/ixj.c
> +++ b/drivers/telephony/ixj.c
> @@ -5923,35 +5923,38 @@ static int ixj_build_filter_cadence(IXJ *j, IXJ_FILTER_CADENCE __user * cp)
>  
>  static void add_caps(IXJ *j)
>  {
> -	j->caps = 0;
> -	j->caplist[j->caps].cap = PHONE_VENDOR_QUICKNET;
> -	strcpy(j->caplist[j->caps].desc, "Quicknet Technologies, Inc. (www.quicknet.net)");
> -	j->caplist[j->caps].captype = vendor;
> -	j->caplist[j->caps].handle = j->caps++;
> -	j->caplist[j->caps].captype = device;
> +	int i = 0;
> +	j->caplist[i].cap = PHONE_VENDOR_QUICKNET;

I think this would be much simpler with a pointer
use for j->caplist[i]

	struct whatever_typeof caplist *p = j->caplist;

	p->cap = PHONE_VENDOR_QUICKNET;
	strlcpy(p->desc, "Quicknet etc...", sizeof(p->desc));
	p->captype = vendor;
...
	p++;


