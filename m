Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab0IBOzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:55:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab0IBOzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:55:36 -0400
Date: Thu, 2 Sep 2010 16:55:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Michael Poole <mdpoole@troilus.org>, Henrik Rydberg <rydberg@euromail.se>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7 v3] HID: magicmouse: Adjust major / minor axes to
 scale
In-Reply-To: <1283306184-28833-8-git-send-email-chase.douglas@canonical.com>
Message-ID: <alpine.LNX.2.00.1009021654520.26813@pobox.suse.cz>
References: <1283306184-28833-1-git-send-email-chase.douglas@canonical.com> <1283306184-28833-8-git-send-email-chase.douglas@canonical.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Aug 2010, Chase Douglas wrote:

> From: Henrik Rydberg <rydberg@euromail.se>
> 
> By visual inspection, the reported touch_major and touch_minor axes
> are roughly a factor of four too small. The factor is approximate,
> since the protocol is not known and the HID report encodes touch size
> with fewer bits than positions. This patch scales the reported values
> by a factor of four.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> Acked-by: Michael Poole <mdpoole@troilus.org>
> ---
>  drivers/hid/hid-magicmouse.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
> index 6f13e56..0792b16 100644
> --- a/drivers/hid/hid-magicmouse.c
> +++ b/drivers/hid/hid-magicmouse.c
> @@ -254,8 +254,8 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
>  	/* Generate the input events for this touch. */
>  	if (report_touches && down) {
>  		input_report_abs(input, ABS_MT_TRACKING_ID, id);
> -		input_report_abs(input, ABS_MT_TOUCH_MAJOR, touch_major);
> -		input_report_abs(input, ABS_MT_TOUCH_MINOR, touch_minor);
> +		input_report_abs(input, ABS_MT_TOUCH_MAJOR, touch_major << 2);
> +		input_report_abs(input, ABS_MT_TOUCH_MINOR, touch_minor << 2);
>  		input_report_abs(input, ABS_MT_ORIENTATION, orientation);
>  		input_report_abs(input, ABS_MT_POSITION_X, x);
>  		input_report_abs(input, ABS_MT_POSITION_Y, y);

Care to fold this into "[PATCH 3/7 v3] HID: magicmouse: simplify touch 
data bit manipulation", which is actually adding this?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
