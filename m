Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab0IAKyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 06:54:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789Ab0IAKyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 06:54:04 -0400
Date: Wed, 1 Sep 2010 12:54:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephane Chatty <chatty@enac.fr>
Subject: Re: [PATCH] hid: Add a hid quirk for input sync override
In-Reply-To: <1282640084-19217-1-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LNX.2.00.1009011252450.26813@pobox.suse.cz>
References: <1282640084-19217-1-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010, Henrik Rydberg wrote:

> From: Henrik Rydberg <rydberg@thabit.(none)>
> 
> As of lately, HID devices which send per-frame data split over several
> HID reports have started to emerge. This patch adds a quirk which
> allows the HID driver to take over the input layer synchronization,
> and hence the control of the frame boundary.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Jiri, Dmitry, Stephane,
> 
> No doubt, this is not a final solution, but it serves the purpose of
> being able to make existing drivers functional while a satisfactory
> solution is being worked out.

Hi Henrik,

I obviously don't have any major objections to the patch, as it was my 
initial idea :)

I'd like to merge it together with driver which actually uses it though.

Thanks.

> 
> Cheers,
> Henrik
> 
>  drivers/hid/hid-input.c |    3 +++
>  include/linux/hid.h     |    1 +
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index 69d152e..9d97934 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -656,6 +656,9 @@ void hidinput_report_event(struct hid_device *hid, struct hid_report *report)
>  {
>  	struct hid_input *hidinput;
>  
> +	if (hid->quirks & HID_QUIRK_NO_INPUT_SYNC)
> +		return;
> +
>  	list_for_each_entry(hidinput, &hid->inputs, list)
>  		input_sync(hidinput->input);
>  }
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index 895001f..8029883 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -315,6 +315,7 @@ struct hid_item {
>  #define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
>  #define HID_QUIRK_NO_INIT_REPORTS		0x20000000
>  #define HID_QUIRK_NO_IGNORE			0x40000000
> +#define HID_QUIRK_NO_INPUT_SYNC			0x80000000
>  
>  /*
>   * This is the global environment of the parser. This information is
> -- 
> 1.7.1
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
