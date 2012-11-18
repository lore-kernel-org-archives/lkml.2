Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2KRCIM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 21:08:12 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43642 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab2KRCIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 21:08:10 -0500
Date: Sat, 17 Nov 2012 18:04:59 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: dragos.tatulea@intel.com
Cc: ccross@android.com, keescook@chromium.org, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        octavian.purdila@intel.com
Subject: Re: [PATCH v3 4/9] pstore: allow storing different type id's in ram
 backend
Message-ID: <20121118020459.GA10763@lizard.sbx05977.paloaca.wayport.net>
References: <1350558367-31801-1-git-send-email-dragos.tatulea@intel.com>
 <1350558367-31801-5-git-send-email-dragos.tatulea@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1350558367-31801-5-git-send-email-dragos.tatulea@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 02:06:02PM +0300, dragos.tatulea@intel.com wrote:
> From: Dragos Tatulea <dragos.tatulea@intel.com>
> 
> Added pstore_type_id in message header when storing to ram.
> On write, take into account the contents of this header and
> set the type accordingly.
> 
> Signed-off-by: Dragos Tatulea <dragos.tatulea@intel.com>
> ---
[...]
> -static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz)
> +static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz,
> +				     enum pstore_type_id type)
>  {
>  	char *hdr;
>  	struct timeval timestamp;
>  	size_t len;
>  
>  	do_gettimeofday(&timestamp);
> -	hdr = kasprintf(GFP_ATOMIC, RAMOOPS_KERNMSG_HDR "%lu.%lu\n",
> -		(long)timestamp.tv_sec, (long)timestamp.tv_usec);
> +	hdr = kasprintf(GFP_ATOMIC, "%u" RAMOOPS_KERNMSG_HDR "%lu.%lu\n",
> +		type, (long)timestamp.tv_sec, (long)timestamp.tv_usec);

This will probably break scripts (and the main purpose for the header is
to make it somewhat scripts-parsable). It's safer to change it to

	RAMOOPS_KERNMSG_HDR "%lu.%lu %u"

Thanks,
Anton.
