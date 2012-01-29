Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2A2WOK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 17:14:10 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21403 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2A2WOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 17:14:08 -0500
Date: Sun, 29 Jan 2012 23:14:22 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: =?ISO-8859-15?Q?Niklas_S=F6derlund?= <niso@kth.se>
cc: mchehab@redhat.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] i7core_edac: fix erroneous size of static array
In-Reply-To: <1327874672-19222-1-git-send-email-niso@kth.se>
Message-ID: <alpine.LNX.2.00.1201292314010.27749@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201290300100.20079@swampdragon.chaosbits.net> <1327874672-19222-1-git-send-email-niso@kth.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1620297489-1327875262=:27749"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1620297489-1327875262=:27749
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 29 Jan 2012, Niklas Söderlund wrote:

> Remove size from lookup arrays and mark them as const.
> 
> Signed-off-by: Niklas Söderlund <niso@kth.se>

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


> ---
>  drivers/edac/i7core_edac.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
> index 70ad892..f50acfb 100644
> --- a/drivers/edac/i7core_edac.c
> +++ b/drivers/edac/i7core_edac.c
> @@ -417,21 +417,21 @@ static inline int numdimms(u32 dimms)
>  
>  static inline int numrank(u32 rank)
>  {
> -	static int ranks[4] = { 1, 2, 4, -EINVAL };
> +	static const int ranks[] = { 1, 2, 4, -EINVAL };
>  
>  	return ranks[rank & 0x3];
>  }
>  
>  static inline int numbank(u32 bank)
>  {
> -	static int banks[4] = { 4, 8, 16, -EINVAL };
> +	static const int banks[] = { 4, 8, 16, -EINVAL };
>  
>  	return banks[bank & 0x3];
>  }
>  
>  static inline int numrow(u32 row)
>  {
> -	static int rows[8] = {
> +	static const int rows[] = {
>  		1 << 12, 1 << 13, 1 << 14, 1 << 15,
>  		1 << 16, -EINVAL, -EINVAL, -EINVAL,
>  	};
> @@ -441,7 +441,7 @@ static inline int numrow(u32 row)
>  
>  static inline int numcol(u32 col)
>  {
> -	static int cols[8] = {
> +	static const int cols[] = {
>  		1 << 10, 1 << 11, 1 << 12, -EINVAL,
>  	};
>  	return cols[col & 0x3];
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-1620297489-1327875262=:27749--
