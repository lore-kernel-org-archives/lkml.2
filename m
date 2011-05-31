Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab1EaXFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 19:05:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63783 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab1EaXFA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 19:05:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M+j2i8+cUqZvz7ILPCp29nKPIjIr986d5bCu8rt13shMPuOghadRubWX0wvHraBnlr
         K3fcIaybaHqCxaggQaZ7j6y8LHu88Xnp9c7yyPQa/kZTBWaVFGs5Iemw8mx7tp+yzhsS
         0d9us2ptX7Og+ZGhUqJAxbAdM5J97BndQZn6Q=
MIME-Version: 1.0
In-Reply-To: <1306866541-17090-1-git-send-email-bp@amd64.org>
References: <1306866541-17090-1-git-send-email-bp@amd64.org>
Date: Wed, 1 Jun 2011 09:04:59 +1000
Message-ID: <BANLkTimZ4xUEW1ZSZ7eQ9A9SdtBh6MjdDQ@mail.gmail.com>
Subject: Re: [PATCH] init, calibrate: Drop annoying warning
From: Andrew Worsley <amworsley@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can see your point - it's useful when debugging the bogomips issue -
but if it's working it's not relevant.
Would be nice to have an extra level of verbose debug or a debug
branch of the file or perhaps just a relevant comment
that would easily allow it to be found and reverted to re-enable debug
if people want to debug this stuff again.

That said I would suggest just changing the comment (I don't know how
to just submit a comment change?) to something like:

"Drop calibrate_delay_direct() KERN_DEBUG printk related to bogomips
calculation as it appears when booting
every core on setups with 'ignore_loglevel' for people who want to
test latest kernels and scan dmesg for possible issues.
and this information isn't very useful to the widest audience of
kernel boot message gazers."

which would allow an easy revert locally when ever it was deemed useful.

On 1 June 2011 04:29, Borislav Petkov <bp@amd64.org> wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
>
> Even though the error message is KERN_DEBUG, it appears when booting
> every core on setups with 'ignore_loglevel' for people who want to test
> latest kernels and scan dmesg for possible issues. Also, it doesn't show
> very useful information to the widest audience of kernel boot message
> gazers so drop it.
>
> Introduced by d2b463135f84d15808163cd15638b108e323d3e7.
>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  init/calibrate.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
>
> diff --git a/init/calibrate.c b/init/calibrate.c
> index cfd7000..2568d22 100644
> --- a/init/calibrate.c
> +++ b/init/calibrate.c
> @@ -93,9 +93,6 @@ static unsigned long __cpuinit calibrate_delay_direct(void)
>                 * If the upper limit and lower limit of the timer_rate is
>                 * >= 12.5% apart, redo calibration.
>                 */
> -               printk(KERN_DEBUG "calibrate_delay_direct() timer_rate_max=%lu "
> -                           "timer_rate_min=%lu pre_start=%lu pre_end=%lu\n",
> -                         timer_rate_max, timer_rate_min, pre_start, pre_end);
>                if (start >= post_end)
>                        printk(KERN_NOTICE "calibrate_delay_direct() ignoring "
>                                        "timer_rate as we had a TSC wrap around"
> --
> 1.7.4.rc2
>
>

Hopefully the code is working and the KERN_NOTICE is considered useful
to indicate to people it recovering from the problem on other machines
besides my own.

Andrew
