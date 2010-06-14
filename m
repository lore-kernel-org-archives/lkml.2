Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab0FNQRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:17:53 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44666 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab0FNQRv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:17:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gpj59EBHe2mbheWhIKyazifq58o94UEVzcQPHE4KmfQml00lg4bZ/7KGswky/H52PN
         ULpICoVAc6I9qATfe8AsoyVbvP8LthtHZJ/voLdn2ib9tJBUVsEXvZ9AZzTH+jLWjscI
         E1tgvis45AiHkh1jv9ayMmTd5Bc+w95nt6A3k=
MIME-Version: 1.0
In-Reply-To: <1276516181-4519-1-git-send-email-rydberg@euromail.se>
References: <1276516181-4519-1-git-send-email-rydberg@euromail.se>
Date: Mon, 14 Jun 2010 09:17:49 -0700
Message-ID: <AANLkTinI8w5vCi-VOf_IybZmOBDe8gjlJymZNSmmpkpk@mail.gmail.com>
Subject: Re: [PATCH] hid-input: Use a larger event buffer for MT devices
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephane Chatty <chatty@enac.fr>, Rafi Rubin <rafi@seas.upenn.edu>,
       Michael Poole <mdpoole@troilus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 4:49 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> The MT devices produce a lot of data. Tell the underlying input device
> approximately how many events will be sent per synchronization, to allow
> for better buffering. The number is a template based on continuously
> reporting details for each finger on a single hand.
>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Hi Jiri,
>
> This patch goes together with the evdev buffer patchset, which Dmitry
> is going to queue for 2.6.36.
>
> Cheers,
> Henrik
>
>  drivers/hid/hid-input.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index 7a0d2e4..69d152e 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -534,6 +534,9 @@ mapped:
>                        input_set_abs_params(input, usage->code, a, b, (b - a) >> 8, (b - a) >> 4);
>                else    input_set_abs_params(input, usage->code, a, b, 0, 0);
>
> +               /* use a larger default input buffer for MT devices */
> +               if (usage->code == ABS_MT_POSITION_X && input->hint_events_per_packet == 0)
> +                       input_set_events_per_packet(input, 60);

Do we really want to use a hardcoded number here? Considering you have
used the same value in your "input: bcm5974" patch, adding it as an
ifdef in linux/input.h should not be an overkill in design and offers
the other drivers a chance to use it.

Ping

>        }
>
>        if (usage->type == EV_ABS &&
> --
> 1.6.3.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
