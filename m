Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab1IAIws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 04:52:48 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:39074 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497Ab1IAIwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 04:52:46 -0400
Date: Thu, 1 Sep 2011 10:52:26 +0200
From: Jean Delvare <khali@linux-fr.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@xenotime.net>, "Ben Dooks" <ben-linux@fluff.org>,
        linux-doc@vger.kernel.org, linux-i2c@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] i2c: remove deprecated callbacks
Message-ID: <20110901105226.0d8dd8b2@endymion.delvare>
In-Reply-To: <1314852027-9523-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1314852027-9523-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cong,

On Thu,  1 Sep 2011 12:40:27 +0800, WANG Cong wrote:
> i2c_driver.attach_adapter and i2c_driver.detach_adapter are deprecated
> and scheduled to be removed in Sep 2011.
> 
> Cc: Jean Delvare <khali@linux-fr.org>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

I'm not sure what you are trying to achieve here.

I am obviously aware of these functions being deprecated, I am the one
who added the entry in feature-removal-schedule.txt. And as a matter of
fact, I have a patch ready for months now.

I could understand you sending a patch if the entry had expired long
ago, but this isn't the case: it is marked for September 2011 and you
send a patch on September 1st. Hardly a coincidence. While there
certainly is a benefit in people reading feature-removal-schedule.txt
and trying to clean it up by closing old (presumably forgotten)
entries, this doesn't apply here.

Furthermore, you didn't even check if the deprecated callbacks were
still in use. It turns out that there are 9 drivers still using one of
them (6 macintosh drivers and 3 sound drivers) so plain removing it
will cause build breakages. We obviously don't want to do that, so I am
not going to apply your patch (nor mine) for now.

I know that Benjamin Herrenschmidt is working on converting (some of)
the macintosh drivers. I don't have any news for some time though. Ben,
are you done with the conversion by now? It would be great to get it
merged in kernel 3.2.

Cong, do you have a specific interest in these callbacks being removed?

If you want to help, then instead of sending a patch which I already
have and virtually everybody could have written, please get the
remaining 3 drivers converted to the current i2c binding model:
  sound/ppc/keywest.c
  sound/aoa/codecs/onyx.c
  sound/aoa/codecs/tas.c
THAT would be helpful. At the moment, it only looks like you are trying
to get your name on a trivial patch, i.e. getting credit for work you
didn't really do.

> 
> ---
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index c4a6e14..89a9695 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -486,15 +486,6 @@ Files:	include/linux/netfilter_ipv4/ipt_addrtype.h
>  
>  ----------------------------
>  
> -What:	i2c_driver.attach_adapter
> -	i2c_driver.detach_adapter
> -When:	September 2011
> -Why:	These legacy callbacks should no longer be used as i2c-core offers
> -	a variety of preferable alternative ways to instantiate I2C devices.
> -Who:	Jean Delvare <khali@linux-fr.org>
> -
> -----------------------------
> -
> (...)

-- 
Jean Delvare
