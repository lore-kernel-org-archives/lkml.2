Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab1ANAqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 19:46:22 -0500
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:49941 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab1ANAqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 19:46:16 -0500
X-Greylist: delayed 1227 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jan 2011 19:46:16 EST
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
References: <alpine.LNX.2.00.1101132332430.11347@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1101132332430.11347@swampdragon.chaosbits.net>
Mime-Version: 1.0 (iPhone Mail 8C148)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <0203A9B5-3035-49A1-AAB7-207EB638A080@dotat.at>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (8C148)
From: Tony Finch <dot@dotat.at>
Subject: Re: [PATCH] strncpy() will not \0 terminate result
Date: Fri, 14 Jan 2011 00:25:17 +0000
To: Jesper Juhl <jj@chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is incorrect. The strncpy is replacing "else" with "if  " so needs to copy exactly 4 bytes.

Tony.
--
f.anthony.n.finch  <dot@dotat.at>  http://dotat.at/

On 13 Jan 2011, at 22:35, Jesper Juhl <jj@chaosbits.net> wrote:

> Hi,
> 
> Mpass() in scripts/unifdef.c has this code:
>  strncpy(keyword, "if  ", 4);
> this will fail to \0 terminate the destination.
> Following patch should fix that up.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
> unifdef.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/unifdef.c b/scripts/unifdef.c
> index 44d3978..d579249 100644
> --- a/scripts/unifdef.c
> +++ b/scripts/unifdef.c
> @@ -376,7 +376,7 @@ static void Idrop (void) { Fdrop();  ignoreon(); }
> static void Itrue (void) { Ftrue();  ignoreon(); }
> static void Ifalse(void) { Ffalse(); ignoreon(); }
> /* edit this line */
> -static void Mpass (void) { strncpy(keyword, "if  ", 4); Pelif(); }
> +static void Mpass (void) { strncpy(keyword, "if  ", 5); Pelif(); }
> static void Mtrue (void) { keywordedit("else\n");  state(IS_TRUE_MIDDLE); }
> static void Melif (void) { keywordedit("endif\n"); state(IS_FALSE_TRAILER); }
> static void Melse (void) { keywordedit("endif\n"); state(IS_FALSE_ELSE); }
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
> 
