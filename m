Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab2BGSK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 13:10:29 -0500
Received: from lunge.queued.net ([173.255.254.236]:58986 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2BGSK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 13:10:28 -0500
Date: Tue, 7 Feb 2012 09:48:12 -0800
From: Andres Salomon <dilinger@queued.net>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: linux-kernel@vger.kernel.org, Danny Kukawka <dkukawka@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] cs5535-mfgpt: don't call __init function from
 __devinit
Message-ID: <20120207094812.5e7cb796@debxo>
In-Reply-To: <1328618470-26953-1-git-send-email-danny.kukawka@bisect.de>
References: <1328618470-26953-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 Feb 2012 13:41:10 +0100
Danny Kukawka <danny.kukawka@bisect.de> wrote:

> Fix scan_timers() and reset_all_timers()  to be __devinit
> and not __init since the function get called from
> cs5535_mfgpt_probe which is __devinit.
> 
> v2: set also reset_all_timers() to __devinit
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>


Acked-by: Andres Salomon <dilinger@queued.net>

Thanks!


> ---
>  drivers/misc/cs5535-mfgpt.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
> index bc685bf..f505a40 100644
> --- a/drivers/misc/cs5535-mfgpt.c
> +++ b/drivers/misc/cs5535-mfgpt.c
> @@ -246,7 +246,7 @@ EXPORT_SYMBOL_GPL(cs5535_mfgpt_write);
>   * Jordan tells me that he and Mitch once played w/ it, but it's
> unclear
>   * what the results of that were (and they experienced some
> instability). */
> -static void __init reset_all_timers(void)
> +static void __devinit reset_all_timers(void)
>  {
>  	uint32_t val, dummy;
>  
> @@ -262,7 +262,7 @@ static void __init reset_all_timers(void)
>   * In other cases (such as with VSAless OpenFirmware), the system
> firmware
>   * leaves timers available for us to use.
>   */
> -static int __init scan_timers(struct cs5535_mfgpt_chip *mfgpt)
> +static int __devinit scan_timers(struct cs5535_mfgpt_chip *mfgpt)
>  {
>  	struct cs5535_mfgpt_timer timer = { .chip = mfgpt };
>  	unsigned long flags;

