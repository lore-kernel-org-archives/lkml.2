Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab2A2ByA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 20:54:00 -0500
Received: from smtp-2.sys.kth.se ([130.237.32.160]:58110 "EHLO
	smtp-2.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2A2Bx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 20:53:58 -0500
X-Greylist: delayed 1654 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jan 2012 20:53:58 EST
X-KTH-Auth: niso [89.253.77.162]
X-KTH-mail-from: niso@kth.se
Message-ID: <4F24A03B.3030001@kth.se>
Date: Sun, 29 Jan 2012 02:26:19 +0100
From: =?UTF-8?B?TmlrbGFzIFPDtmRlcmx1bmQ=?= <niso@kth.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
MIME-Version: 1.0
To: =?UTF-8?B?TmlrbGFzIFPDtmRlcmx1bmQ=?= <niso@kth.se>
CC: mchehab@redhat.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] i7core_edac: fix erroneous size of static array
References: <1318530294-6829-1-git-send-email-niso@kth.se> <1318539151-1096-1-git-send-email-niso@kth.se>
In-Reply-To: <1318539151-1096-1-git-send-email-niso@kth.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Anyone have comments on this or are there no interest in this patch?

// Niklas

On 10/13/2011 10:52 PM, Niklas Söderlund wrote:

> Remove size form lookup arrays and mark them as const.
> 
> Signed-off-by: Niklas Söderlund <niso@kth.se>
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


