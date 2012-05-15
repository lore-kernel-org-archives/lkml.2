Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab2EOLM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:12:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab2EOLM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:12:58 -0400
Date: Tue, 15 May 2012 14:12:55 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] EDD: Check for correct EDD 3.0 length
Message-ID: <20120515111255.GJ32036@redhat.com>
References: <1337079889-62380-1-git-send-email-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337079889-62380-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Next time you resent an email say why you are doing it (wrong lkml
address in this case).

On Tue, May 15, 2012 at 01:04:49PM +0200, Hannes Reinecke wrote:
> The device_path_info_length for EDD 3.0 is 36, not 44.
> Cf http://mbldr.sourceforge.net/specsedd30.pdf.
> 
That's the wrong spec.

> This is a regression introduced by commit
> 0c61227094b3ddaca2f847ee287c4a2e3762b5a2
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> 
> diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
> index e229576..09a77d5 100644
> --- a/drivers/firmware/edd.c
> +++ b/drivers/firmware/edd.c
> @@ -545,8 +545,8 @@ edd_has_edd30(struct edd_device *edev)
>  	}
>  
>  
> -	/* We support only T13 spec */
> -	if (info->params.device_path_info_length != 44)
Here is the spec that code supports is spelled out, but you just replace
the comment with pointer to the spec that the code does not support.

> +	/* EDD 3.0 specifies this to be 36 */
> +	if (info->params.device_path_info_length != 36)
>  		return 0;
>  
>  	for (i = 30; i < info->params.device_path_info_length + 30; i++)

--
			Gleb.
