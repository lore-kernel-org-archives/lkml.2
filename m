Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab0LFAYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 19:24:09 -0500
Received: from posthamster.phnxsoft.com ([89.1.7.4]:1739 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab0LFAYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 19:24:08 -0500
X-Greylist: delayed 759 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Dec 2010 19:24:07 EST
Message-ID: <4CFC2A05.7010509@phoenixsoftware.de>
Date: Mon, 06 Dec 2010 01:10:45 +0100
From: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 26/45] kstrtox: convert drivers/isdn/
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com> <1291571382-2719-26-git-send-email-adobriyan@gmail.com>
In-Reply-To: <1291571382-2719-26-git-send-email-adobriyan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.63 () AWL,RDNS_DYNAMIC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like the patch, but why not go all the way?

Am 05.12.2010 18:49 schrieb Alexey Dobriyan:
> @@ -566,10 +566,10 @@ void gigaset_handle_modem_response(struct cardstate *cs)
>  		case RT_ZCAU:
>  			event->parameter = -1;
>  			if (curarg + 1 < params) {
> -				unsigned long type, value;
> +				u8 type, value;
>  
> -				i = strict_strtoul(argv[curarg++], 16, &type);
> -				j = strict_strtoul(argv[curarg++], 16, &value);
> +				i = kstrtou8(argv[curarg++], 16, &type);
> +				j = kstrtou8(argv[curarg++], 16, &value);
>  
>  				if (i == 0 && type < 256 &&
>  				    j == 0 && value < 256)

Once type and value are u8, the checks for < 256 are unnecessary.

> @@ -583,7 +583,7 @@ void gigaset_handle_modem_response(struct cardstate *cs)
>  				unsigned long res;
>  				int rc;
>  
> -				rc = strict_strtoul(argv[curarg++], 10, &res);
> +				rc = kstrtoul(argv[curarg++], 10, &res);
>  				if (rc == 0)
>  					event->parameter = res;
>  			}

The new kstrtoul() promises not to touch the result field in the event
of a conversion error, so &event->parameter can be passed directly to
it, getting rid of the variables rc and res and the if statement.

Thanks,
Tilman
