Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab0IKN4k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 09:56:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab0IKN4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 09:56:39 -0400
Subject: Re: [PATCH] drivers: scsi: remove private hex_to_bin()
 implementation
From: James Bottomley <James.Bottomley@suse.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <1284212280-25944-1-git-send-email-andy.shevchenko@gmail.com>
References: <1284212280-25944-1-git-send-email-andy.shevchenko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Sep 2010 08:56:35 -0500
Message-ID: <1284213395.2986.9.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-11 at 16:38 +0300, Andy Shevchenko wrote:
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/scsi/libsas/sas_scsi_host.c |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index f0cfba9..527dcf7 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -1078,14 +1078,10 @@ void sas_target_destroy(struct scsi_target *starget)
>  static void sas_parse_addr(u8 *sas_addr, const char *p)
>  {
>  	int i;
> -	for (i = 0; i < SAS_ADDR_SIZE; i++) {
> +	for (i = 0; i < SAS_ADDR_SIZE && *p; i++) {
>  		u8 h, l;
> -		if (!*p)
> -			break;
> -		h = isdigit(*p) ? *p-'0' : toupper(*p)-'A'+10;
> -		p++;
> -		l = isdigit(*p) ? *p-'0' : toupper(*p)-'A'+10;
> -		p++;
> +		h = hex_to_bin(*p++);
> +		l = hex_to_bin(*p++);

the hex_to_bin() is really to prevent open coded mistakes.  When the
open coding pre-dates the hex_to_bin macro, I'm inclined to leave it
alone unless it contains an actual bug.

James


