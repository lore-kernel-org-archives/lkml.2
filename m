Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab2E0LSk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 07:18:40 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44316 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2E0LSj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 07:18:39 -0400
MIME-Version: 1.0
In-Reply-To: <4FB6722B.6050103@ladisch.de>
References: <1335112621.20322.8.camel@home>
	<4FB6722B.6050103@ladisch.de>
Date: Sun, 27 May 2012 17:18:38 +0600
Message-ID: <CAN_LGv3a=X2GSjanvJAPG_0H14PUbw+XZZ+yoo6QnXwxunRDFw@mail.gmail.com>
Subject: Re: kmemleak findings about USB audio recording on 3.3.2
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/18 Clemens Ladisch <clemens@ladisch.de>:
> Please try this patch.
>
> --8<---------------------------------------------------------------->8--
> ALSA: usb-audio: fix rate_list memory leak
>
> The array of sample rates is reallocated every time when opening
> the PCM device, but was freed only once when unplugging the device.
>
> Reported-by: "Alexander E. Patrakov" <patrakov@gmail.com>
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> ---
>  sound/usb/pcm.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> --- a/sound/usb/pcm.c
> +++ b/sound/usb/pcm.c
> @@ -783,6 +783,9 @@ static int snd_usb_pcm_check_knot(struct snd_pcm_runtime *runtime,
>        int count = 0, needs_knot = 0;
>        int err;
>
> +       kfree(subs->rate_list.list);
> +       subs->rate_list.list = NULL;
> +
>        list_for_each_entry(fp, &subs->fmt_list, list) {
>                if (fp->rates & SNDRV_PCM_RATE_CONTINUOUS)
>                        return 0;

I have applied this on top of 3.4.0. So far, the microphone works, and
there are no leaks detected.

-- 
Alexander E. Patrakov
