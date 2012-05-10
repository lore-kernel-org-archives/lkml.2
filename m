Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761411Ab2EJALO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 20:11:14 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:58721 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761267Ab2EJALN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 20:11:13 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18s1eBBSk8szZ5LfV3xSKY7ssyu8XKY9Rvy9cUD0y
	i9AnO6mZQA91P4
Message-ID: <4FAB0798.8090502@gmx.de>
Date: Thu, 10 May 2012 00:11:04 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Icedove/3.0.11
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org,
        steve.glendinning@smsc.com
Subject: Re: [PATCH] video: smscufx.c: local functions should not be exposed
 globally
References: <201205021717.23749.hartleys@visionengravers.com>
In-Reply-To: <201205021717.23749.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 12:17 AM, H Hartley Sweeten wrote:
> Functions not referenced outside of a source file should be marked
> static to prevent them from being exposed globally.
> 
> Quiets the sparse warnings:
> 
> warning: symbol 'ufx_handle_damage' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Steve Glendinning <steve.glendinning@smsc.com>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Applied.


Thanks,

Florian Tobias Schandinat

> 
> ---
> 
> diff --git a/drivers/video/smscufx.c b/drivers/video/smscufx.c
> index 9985785..af3ef27 100644
> --- a/drivers/video/smscufx.c
> +++ b/drivers/video/smscufx.c
> @@ -846,7 +846,7 @@ static void ufx_raw_rect(struct ufx_data *dev, u16 *cmd, int x, int y,
>  	}
>  }
>  
> -int ufx_handle_damage(struct ufx_data *dev, int x, int y,
> +static int ufx_handle_damage(struct ufx_data *dev, int x, int y,
>  	int width, int height)
>  {
>  	size_t packed_line_len = ALIGN((width * 2), 4);
> 

