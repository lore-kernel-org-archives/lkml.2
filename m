Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab2BYW4Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 17:56:25 -0500
Received: from mail2.vodafone.ie ([213.233.128.44]:22096 "EHLO
	mail2.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab2BYW4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 17:56:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjUDAKRmSU9tThHq/2dsb2JhbAAMNrATgX0Dg34BAQEEMgFGEAsNAQoJFg8JAwIBAgFFBg0BBwEBvn+LFIIuCwYEAwQDCAQKBw8BCgMDAwKFCAMHCw0Fg3kEmzyMbw
Message-ID: <4F496715.7070005@draigBrady.com>
Date: Sat, 25 Feb 2012 22:56:21 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Eric Wong <normalperson@yhbt.net>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fadvise: avoid EINVAL if user input is valid
References: <20120225022710.GA29455@dcvr.yhbt.net>
In-Reply-To: <20120225022710.GA29455@dcvr.yhbt.net>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2012 02:27 AM, Eric Wong wrote:
> The kernel is not required to act on fadvise, so fail silently
> and ignore advice as long as it has a valid descriptor and
> parameters.
> 

> @@ -106,12 +105,8 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
>  		nrpages = end_index - start_index + 1;
>  		if (!nrpages)
>  			nrpages = ~0UL;
> -		
> -		ret = force_page_cache_readahead(mapping, file,
> -				start_index,
> -				nrpages);
> -		if (ret > 0)
> -			ret = 0;
> +
> +		force_page_cache_readahead(mapping, file, start_index, nrpages);
>  		break;

This whole patch makes sense to me.
The above chunk might cause confusion in future,
if people wonder for a moment why the return is ignored.
Should you use cast with (void) like this to be explicit?

(void) force_page_cache_readahead(...);

cheers,
Pádraig.
