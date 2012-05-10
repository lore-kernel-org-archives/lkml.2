Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761600Ab2EJVkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:40:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758453Ab2EJVkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:40:18 -0400
Date: Thu, 10 May 2012 14:40:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Bryan Wu <bryan.wu@canonical.com>
Subject: Re: [PATCH] leds-pca955x: Fix race condition while setting
 brightness on several LEDs
Message-Id: <20120510144016.3a1b006c.akpm@linux-foundation.org>
In-Reply-To: <1328705048-21073-1-git-send-email-alexander.stein@systec-electronic.com>
References: <1328705048-21073-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 Feb 2012 13:44:08 +0100
Alexander Stein <alexander.stein@systec-electronic.com> wrote:

> When issuing the following command:
> for I in 0 1 2 3 4 5 6 7; do
>   echo 0 > /sys/class/leds/pca955x\:${I}/brightness;
> done
> It is possible that all the pca955x_read_ls calls are done sequentially
> before any pca955x_write_ls call is done. This updates the LS only to the
> last LED update in its set.
> Fix this by using a global lock for the pca995x device during
> pca955x_led_work.

There's the bugfix.

> Also used a struct for shared data bewteen all LEDs.

And there's an apparently unrelated change whcih created a *lot* of
noise in the patch.  It would be good to separate these things, with
the bugfix being the first change.

> ...
>
> -static inline u8 pca955x_ledsel(u8 oldval, int led_num, int state)
> +static inline u8 pca955x_ledel(u8 oldval, int led_num, int state)

Why was this function renamed, and what does "ledel" mean?

