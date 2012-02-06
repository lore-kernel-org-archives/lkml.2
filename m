Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2BFWsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:48:38 -0500
Received: from lunge.queued.net ([173.255.254.236]:46436 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab2BFWsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:48:38 -0500
Date: Mon, 6 Feb 2012 14:48:36 -0800
From: Andres Salomon <dilinger@queued.net>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: linux-kernel@vger.kernel.org, Danny Kukawka <dkukawka@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] cs5535-mfgpt: don't call __init function from __devinit
Message-ID: <20120206144836.65aed6ca@queued.net>
In-Reply-To: <1328188830-28133-2-git-send-email-danny.kukawka@bisect.de>
References: <1328188830-28133-1-git-send-email-danny.kukawka@bisect.de>
	<1328188830-28133-2-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Feb 2012 14:20:29 +0100
Danny Kukawka <danny.kukawka@bisect.de> wrote:

> Fix scan_timers() to be __devinit and not __init since
> the function get called from cs5535_mfgpt_probe which is
> __devinit.

You are correct that it should be devinit; however, it's incomplete.
cs5535_mfgpt_probe calls scan_timers which calls reset_all_timers.. All
of those should be devinit.



> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  drivers/misc/cs5535-mfgpt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
> index bc685bf..87a390d 100644
> --- a/drivers/misc/cs5535-mfgpt.c
> +++ b/drivers/misc/cs5535-mfgpt.c
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
