Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab0JXPGQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 11:06:16 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:52726 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab0JXPGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 11:06:13 -0400
X-Spam-Flag: NO
X-Spam-Score: -21.89
Message-ID: <4CC4407E.6060705@tremplin-utc.net>
Date: Sun, 24 Oct 2010 16:19:42 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101020 Mandriva/3.1.5-1mdv2011.0 (2011.0) Thunderbird/3.1.5
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
CC: khali@linux-fr.org, guenter.roeck@ericsson.com, jic23@cam.ac.uk,
        lm-sensors@lm-sensors.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] hwmon: lis3: Update coordinates at polled device
 open
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com> <1287748654-2626-5-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1287748654-2626-5-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 22-10-10 13:57, Samu Onkalo schreef:
> Call input device poll function at device open to refresh coordinates
> immediately. This is needed for the case where poll interval is set to
> zero and coordinate updates happens purely under interrupt control.
>
> Signed-off-by: Samu Onkalo<samu.p.onkalo@nokia.com>
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>
> ---
>   drivers/hwmon/lis3lv02d.c |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
> index fe97390..e2e0bb4 100644
> --- a/drivers/hwmon/lis3lv02d.c
> +++ b/drivers/hwmon/lis3lv02d.c
> @@ -312,6 +312,11 @@ static void lis3lv02d_joystick_open(struct input_polled_dev *pidev)
>
>   	if (lis3_dev.pdata&&  lis3_dev.whoami == WAI_8B&&  lis3_dev.idev)
>   		atomic_set(&lis3_dev.wake_thread, 1);
> +	/*
> +	 * Update coordinates for the case where poll interval is 0 and
> +	 * the chip in running purely under interrupt control
> +	 */
> +	lis3lv02d_joystick_poll(pidev);
>   }
>
>   static void lis3lv02d_joystick_close(struct input_polled_dev *pidev)

