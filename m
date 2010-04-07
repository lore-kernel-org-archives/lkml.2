Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab0DGKFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 06:05:40 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:24983 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab0DGKFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 06:05:33 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zzab9bh1432P98dNzz1202hzzz32i87h6bh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0I40S-01-282-02
X-M-MSG: 
Date: Wed, 7 Apr 2010 12:05:12 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Dan Carpenter <error27@gmail.com>, Joerg Roedel <joro@8bytes.org>,
       Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Shaun Ruffell <sruffell@digium.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] dma-debug: cleanup for loop
Message-ID: <20100407100512.GJ28166@amd.com>
References: <20100402112843.GI5265@bicker>
 <20100403204717.GS24846@8bytes.org>
 <20100405125329.GA16197@bicker>
 <20100405140215.GA29758@8bytes.org>
 <20100405140909.GB29758@8bytes.org>
 <20100406164512.GF21229@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100406164512.GF21229@bicker>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Apr 2010 10:05:13.0486 (UTC) FILETIME=[D09C3AE0:01CAD639]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 07:45:12PM +0300, Dan Carpenter wrote:
> Earlier in this function we set the last byte of "buf" to NULL so we 
> always hit the break statement and "i" is never equal to NAME_MAX_LEN.  
> This patch doesn't change how the driver works but it silences a Smatch 
> warning and it makes it clearer that we don't write past the end of the 
> array.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index ba8b670..01e6427 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -570,7 +570,7 @@ static ssize_t filter_write(struct file *file, const char __user *userbuf,
>  	 * Now parse out the first token and use it as the name for the
>  	 * driver to filter for.
>  	 */
> -	for (i = 0; i < NAME_MAX_LEN; ++i) {
> +	for (i = 0; i < NAME_MAX_LEN - 1; ++i) {
>  		current_driver_name[i] = buf[i];
>  		if (isspace(buf[i]) || buf[i] == ' ' || buf[i] == 0)
>  			break;

Applied, thanks.


