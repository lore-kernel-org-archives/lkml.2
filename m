Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004Ab2EVD2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 23:28:11 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:41381 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484Ab2EVD2J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 23:28:09 -0400
MIME-Version: 1.0
In-Reply-To: <1337614542-31696-1-git-send-email-siretart@tauware.de>
References: <1337614542-31696-1-git-send-email-siretart@tauware.de>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 22 May 2012 11:27:48 +0800
X-Google-Sender-Auth: HBjRqHYnQcIbHprkWqPeKT_bD1o
Message-ID: <CAK5ve-+MqwncOAJLhnkcJANLS8gebgTEAcsvK8rHtMrdqb+UfA@mail.gmail.com>
Subject: Re: [PATCH] drivers/leds/leds-lp5521.c: actually check return value
 of lp5521_read
To: Reinhard Tartler <siretart@tauware.de>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 11:35 PM, Reinhard Tartler <siretart@tauware.de> wrote:
> This detects device failures properly. Fixes compiler warning:
> drivers/leds/leds-lp5521.c:741: warning: 'buf' may be used uninitialized in this function
>
> Signed-off-by: Reinhard Tartler <siretart@tauware.de>
> ---
>  drivers/leds/leds-lp5521.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> This problem was found by tools developed by the VAMOS project:
> http://www4.cs.fau.de/Research/VAMOS/
>
> diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
> index 410a723..943c69d 100644
> --- a/drivers/leds/leds-lp5521.c
> +++ b/drivers/leds/leds-lp5521.c
> @@ -785,7 +785,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
>         * LP5521_REG_ENABLE register will not have any effect - strange!
>         */
>        ret = lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
> -       if (buf != LP5521_REG_R_CURR_DEFAULT) {
> +       if (ret == -EIO || buf != LP5521_REG_R_CURR_DEFAULT) {

Looks fine to me.
Acked-by: Bryan Wu <bryan.wu@canonical.com>

And applied to fixes-for-3.5 branch of linux-leds.git

-Bryan
