Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab2HWU25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:28:57 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:59235 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751581Ab2HWU2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:28:53 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18oGy1DfvIoezgomYgPYuUEI0kj4m0A1JT10Uk+ph
	64VUzrpc9uwoDT
Message-ID: <5036927E.1080504@gmx.de>
Date: Thu, 23 Aug 2012 20:28:46 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Paul Cercueil <paul@crapouillou.net>
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 2/4] fbcon: prevent possible buffer overflow.
References: <1343091626-11435-1-git-send-email-paul@crapouillou.net> <1343091626-11435-2-git-send-email-paul@crapouillou.net>
In-Reply-To: <1343091626-11435-2-git-send-email-paul@crapouillou.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 01:00 AM, Paul Cercueil wrote:
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>

Applied.


Thanks,

Florian Tobias Schandinat

> ---
>  drivers/video/console/fbcon.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
> index a0b1818..3ffab97 100644
> --- a/drivers/video/console/fbcon.c
> +++ b/drivers/video/console/fbcon.c
> @@ -442,7 +442,7 @@ static int __init fb_console_setup(char *this_opt)
>  
>  	while ((options = strsep(&this_opt, ",")) != NULL) {
>  		if (!strncmp(options, "font:", 5))
> -			strcpy(fontname, options + 5);
> +			strlcpy(fontname, options + 5, sizeof(fontname));
>  		
>  		if (!strncmp(options, "scrollback:", 11)) {
>  			char *k;

