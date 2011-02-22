Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab1BVWCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:02:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57378 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab1BVWCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:02:31 -0500
MIME-Version: 1.0
In-Reply-To: <20110222133529.56b02ebb.randy.dunlap@oracle.com>
References: <20110222132438.02d310e0@queued.net> <20110222133529.56b02ebb.randy.dunlap@oracle.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 22 Feb 2011 15:02:11 -0700
X-Google-Sender-Auth: QrYP7E6TWBkHoFFHAd7bXssldNY
Message-ID: <AANLkTikBhnQkjd1-5XX=fnFDGcJ+eQT4SUZkV6Rp2rJN@mail.gmail.com>
Subject: Re: [PATCH] spi/spi_oc_tiny and spi_altera.c: fix build errors
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andres Salomon <dilinger@queued.net>,
        David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 2:35 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Tue, 22 Feb 2011 13:24:38 -0800 Andres Salomon wrote:
>
>> Fix the following build error due to a missing semicolon:
>>
>>  CC [M]  drivers/spi/spi_oc_tiny.o
>> drivers/spi/spi_oc_tiny.c:394: error: expected ‘,’ or ‘;’ before ‘extern’
>> make[2]: *** [drivers/spi/spi_oc_tiny.o] Error 1
>>
>> Signed-off-by: Andres Salomon <dilinger@queued.net>
>
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
>
> Same fix is needed for drivers/spi/spi_altera.c.
> I already had this patch ready to send.  Grant, can you extract
> the spi_altera.c patch...?

done.  Will be pushed out when I finish testing.

g.


>
>
> ---
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix build error due to missing semi-colon:
>
> drivers/spi/spi_altera.c:308: error: expected ',' or ';' before 'extern'
> drivers/spi/spi_oc_tiny.c:394: error: expected ',' or ';' before 'extern'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/spi/spi_altera.c  |    2 +-
>  drivers/spi/spi_oc_tiny.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> --- linux-next-20110222.orig/drivers/spi/spi_oc_tiny.c
> +++ linux-next-20110222/drivers/spi/spi_oc_tiny.c
> @@ -390,7 +390,7 @@ static int __devexit tiny_spi_remove(str
>  static const struct of_device_id tiny_spi_match[] = {
>        { .compatible = "opencores,tiny-spi-rtlsvn2", },
>        {},
> -}
> +};
>  MODULE_DEVICE_TABLE(of, tiny_spi_match);
>  #else /* CONFIG_OF */
>  #define tiny_spi_match NULL
> --- linux-next-20110222.orig/drivers/spi/spi_altera.c
> +++ linux-next-20110222/drivers/spi/spi_altera.c
> @@ -304,7 +304,7 @@ static int __devexit altera_spi_remove(s
>  static const struct of_device_id altera_spi_match[] = {
>        { .compatible = "ALTR,spi-1.0", },
>        {},
> -}
> +};
>  MODULE_DEVICE_TABLE(of, altera_spi_match);
>  #else /* CONFIG_OF */
>  #define altera_spi_match NULL
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
