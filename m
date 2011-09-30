Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab1I3VaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 17:30:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37937 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab1I3VaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 17:30:05 -0400
Message-ID: <4E8634D3.2080504@zytor.com>
Date: Fri, 30 Sep 2011 14:29:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        James.Bottomley@HansenPartnership.com
Subject: Re: [RFCv2][PATCH 1/4] break units out of string_get_size()
References: <20110930203219.60D507CB@kernel>
In-Reply-To: <20110930203219.60D507CB@kernel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2011 01:32 PM, Dave Hansen wrote:
> I would like to use these (well one of them) arrays in
> another function.  Might as well break both versions
> out for consistency.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> ---
> 
>  linux-2.6.git-dave/lib/string_helpers.c |   25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff -puN lib/string_helpers.c~string_get_size-pow2 lib/string_helpers.c
>  
> +const char *units_10[] = { "B", "kB", "MB", "GB", "TB", "PB",
> +			   "EB", "ZB", "YB", NULL};
> +const char *units_2[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB",
> +			 "EiB", "ZiB", "YiB", NULL };

These names are way too generic to be public symbols.

Another thing worth thinking about is whether or not the -B suffix
should be part of these arrays.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

