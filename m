Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab1DAXvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 19:51:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60824 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab1DAXvs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 19:51:48 -0400
MIME-Version: 1.0
In-Reply-To: <1301691819-2090-1-git-send-email-chase.douglas@canonical.com>
References: <1301691819-2090-1-git-send-email-chase.douglas@canonical.com>
From: Jeffrey Brown <jeffbrown@android.com>
Date: Fri, 1 Apr 2011 16:51:07 -0700
Message-ID: <AANLkTim-tN=siA8tJVCzNZHs+oM0hN-N8Ckc+9ynnNpb@mail.gmail.com>
Subject: Re: [PATCH resend] hid-magicmouse: Increase evdev buffer size
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Henrik Rydberg <rydberg@euromail.se>,
        Simon Budig <simon@budig.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got another change in the works that fixes this problem more
systematically.

On Fri, Apr 1, 2011 at 2:03 PM, Chase Douglas
<chase.douglas@canonical.com> wrote:
> The evdev buffer isn't big enough when you get many fingers on the
> device. Bump up the buffer to a reasonable size, matching what other
> multitouch devices use. Without this change, events may be discarded in
> the evdev buffer before they are read.
>
> Reported-by: Simon Budig <simon@budig.de>
> Cc: Henrik Rydberg <rydberg@euromail.se>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: stable@kernel.org
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> ---
> Forgot to Cc the mailing lists on the first send.
>
>  drivers/hid/hid-magicmouse.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
> index 698e645..404dcbc 100644
> --- a/drivers/hid/hid-magicmouse.c
> +++ b/drivers/hid/hid-magicmouse.c
> @@ -418,6 +418,8 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
>                        input_set_abs_params(input, ABS_MT_POSITION_Y, -2456,
>                                2565, 4, 0);
>                }
> +
> +               input_set_events_per_packet(input, 60);
>        }
>
>        if (report_undeciphered) {
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
