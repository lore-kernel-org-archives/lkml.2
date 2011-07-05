Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab1GERyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:54:13 -0400
Received: from adelie.canonical.com ([91.189.90.139]:40299 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab1GERyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:54:12 -0400
Message-ID: <4E134FBF.7050002@canonical.com>
Date: Tue, 05 Jul 2011 10:54:07 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: djkurtz@chromium.org
CC: dmitry.torokhov@gmail.com, rydberg@euromail.se, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 08/12] Input: synaptics - rename set_slot to be more descriptive
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org> <1309324042-22943-9-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1309324042-22943-9-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2011 10:07 PM, djkurtz@chromium.org wrote:
> From: Daniel Kurtz <djkurtz@chromium.org>
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

I like the new name much better :).

Acked-by: Chase Douglas <chase.douglas@canonical.com>

> ---
>  drivers/input/mouse/synaptics.c |   17 ++++++++++-------
>  1 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index 4e5e454..0a51b0ba 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -489,7 +489,8 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
>  	return 0;
>  }
>  
> -static void set_slot(struct input_dev *dev, int slot, bool active, int x, int y)
> +static void synaptics_report_semi_mt_slot(struct input_dev *dev, int slot,
> +					  bool active, int x, int y)
>  {
>  	input_mt_slot(dev, slot);
>  	input_mt_report_slot_state(dev, MT_TOOL_FINGER, active);
> @@ -505,14 +506,16 @@ static void synaptics_report_semi_mt_data(struct input_dev *dev,
>  					  int num_fingers)
>  {
>  	if (num_fingers >= 2) {
> -		set_slot(dev, 0, true, min(a->x, b->x), min(a->y, b->y));
> -		set_slot(dev, 1, true, max(a->x, b->x), max(a->y, b->y));
> +		synaptics_report_semi_mt_slot(dev, 0, true, min(a->x, b->x),
> +					      min(a->y, b->y));
> +		synaptics_report_semi_mt_slot(dev, 1, true, max(a->x, b->x),
> +					      max(a->y, b->y));
>  	} else if (num_fingers == 1) {
> -		set_slot(dev, 0, true, a->x, a->y);
> -		set_slot(dev, 1, false, 0, 0);
> +		synaptics_report_semi_mt_slot(dev, 0, true, a->x, a->y);
> +		synaptics_report_semi_mt_slot(dev, 1, false, 0, 0);
>  	} else {
> -		set_slot(dev, 0, false, 0, 0);
> -		set_slot(dev, 1, false, 0, 0);
> +		synaptics_report_semi_mt_slot(dev, 0, false, 0, 0);
> +		synaptics_report_semi_mt_slot(dev, 1, false, 0, 0);
>  	}
>  }
>  

