Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab2CLBOj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 21:14:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61254 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab2CLBOc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 21:14:32 -0400
MIME-Version: 1.0
In-Reply-To: <4F5D4C4E.1060800@gmail.com>
References: <4F5D4C4E.1060800@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 12 Mar 2012 12:14:11 +1100
Message-ID: <CAGRGNgX-RDRFNXKTXf=qw7h4bQNypHx0Hgvjd7rvXu9T43f4WQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mac80211: improve PID rate control mechanism by
 avoiding rate oscillation problem
To: wei <yinwei168@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

Much better!

Still a few style comments below.

On Mon, Mar 12, 2012 at 12:07, wei <yinwei168@gmail.com> wrote:
> From Wei YIN <Wei.Yin@nicta.com.au>
> Improve PID rate control mechanism by avoiding rate oscillation problem
>
> Signed-off-by: Wei YIN <Wei.Yin@nicta.com.au>
> ---
> kernel 3.3.0
> net/mac80211/rc80211_pid_algo.c | 392 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------------
> 1 file changed, 317 insertions(+), 75 deletions(-)
>
> --- wireless-testing_orig/net/mac80211/rc80211_pid_algo.c       2012-02-17 13:59:53.495254495 +1000
> +++ wireless-testing/net/mac80211/rc80211_pid_algo.c    2012-03-08 20:00:31.791698813 +1000
> @@ -155,99 +217,239 @@ static void rate_control_pid_sample(stru
>        /* Ignore all frames that were sent with a different rate than the rate
>         * we currently advise mac80211 to use. */
> -       if (info->status.rates[0].idx != spinfo->txrate_idx)
> -               return;
>
> -       spinfo->tx_num_xmit++;
> +       if ((info->status.rates[0].idx != spinfo->txrate_idx) &&
> +                       (info->status.rates[0].idx != spinfo->tmp_rate_idx))
> +               return;

You don't need the parentheses around the != expressions.

> @@ -271,14 +473,17 @@ rate_control_pid_get_rate(void *priv, st
>                info->control.rates[0].count =
>                        txrc->hw->conf.long_frame_max_tx_count;
>        else
> -               info->control.rates[0].count =
> -                       txrc->hw->conf.short_frame_max_tx_count;
> -
> +               info->control.rates[0].count = 2;

Should this be a constant or something? Why is this being set to 2?

> @@ -321,7 +530,7 @@ rate_control_pid_rate_init(void *priv, s
>                s = false;
>                for (j = 0; j < sband->n_bitrates - i; j++)
>                        if (unlikely(sband->bitrates[rinfo[j].index].bitrate >
> -                                    sband->bitrates[rinfo[j + 1].index].bitrate)) {
> +                               sband->bitrates[rinfo[j + 1].index].bitrate)) {

You should drop this whitespace change as it's unrelated to the rest
of your patch.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
