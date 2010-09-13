Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab0IMIEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:04:36 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:58543 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab0IMIEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:04:34 -0400
Date: Mon, 13 Sep 2010 10:04:27 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux390@de.ibm.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH] drivers: s390: remove custom implementation of
 hex_to_bin()
Message-ID: <20100913080427.GA2310@osiris.boeblingen.de.ibm.com>
References: <1284212198-25849-1-git-send-email-andy.shevchenko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284212198-25849-1-git-send-email-andy.shevchenko@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 11, 2010 at 04:36:38PM +0300, Andy Shevchenko wrote:
> diff --git a/drivers/s390/cio/blacklist.c b/drivers/s390/cio/blacklist.c
> index 13cb601..76058a5 100644
> --- a/drivers/s390/cio/blacklist.c
> +++ b/drivers/s390/cio/blacklist.c
> @@ -79,17 +79,15 @@ static int pure_hex(char **cp, unsigned int *val, int min_digit,
>  		    int max_digit, int max_val)
>  {
>  	int diff;
> -	unsigned int value;
> 
>  	diff = 0;
>  	*val = 0;
> 
> -	while (isxdigit(**cp) && (diff <= max_digit)) {
> +	while (diff <= max_digit) {
> +		int value = hex_to_bin(**cp);
> 
> -		if (isdigit(**cp))
> -			value = **cp - '0';
> -		else
> -			value = tolower(**cp) - 'a' + 10;
> +		if (value < 0)
> +			break;
>  		*val = *val * 16 + value;
>  		(*cp)++;
>  		diff++;

Applied, thanks!
