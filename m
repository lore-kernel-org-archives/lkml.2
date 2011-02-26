Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab1BZK6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 05:58:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab1BZK6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 05:58:49 -0500
Date: Sat, 26 Feb 2011 11:58:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        micki@n-trig.com, rydberg@euromail.se, chatty@enac.fr,
        peter.hutterer@who-t.net
Subject: Re: [PATCH 1/2] HID: ntrig don't dereference unclaimed hidinput
In-Reply-To: <1298610932-21957-1-git-send-email-rafi@seas.upenn.edu>
Message-ID: <alpine.LNX.2.00.1102261156480.2160@pobox.suse.cz>
References: <1298610932-21957-1-git-send-email-rafi@seas.upenn.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011, Rafi Rubin wrote:

> Moved the claimed input check before dereferencing field->hidinput to
> fix a reported invalid deference bug.
> 
> Switched to a goto instead of an extra indent for most of the function.
> 
> Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
> ---
> Peter Hutterer reported seeing ntrig_event called when field->hidinput
> is NULL.
> 
> Seems like a reasonable opportunity to adjust the whitespace a bit.

Hi Rafi,

thanks for the fix. Even though it's obvious in this case what the actual 
fix is, I'd prefer to have it separate from the other cleanup changes ...

> ---
>  drivers/hid/hid-ntrig.c |  466 ++++++++++++++++++++++++-----------------------
>  1 files changed, 236 insertions(+), 230 deletions(-)
> 
> diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
> index beb4034..616f091 100644
> --- a/drivers/hid/hid-ntrig.c
> +++ b/drivers/hid/hid-ntrig.c
> @@ -539,277 +539,283 @@ static int ntrig_input_mapped(struct hid_device *hdev, struct hid_input *hi,
>  static int ntrig_event (struct hid_device *hid, struct hid_field *field,
>  			struct hid_usage *usage, __s32 value)
>  {
> -	struct input_dev *input = field->hidinput->input;
>  	struct ntrig_data *nd = hid_get_drvdata(hid);
> +	struct input_dev *input;
> +
> +	/* Skip processing if not a claimed input */
> +	if (!(hid->claimed & HID_CLAIMED_INPUT))
> +		goto not_claimed_input;

Makes me wonder why ntrig would be the only driver needing this ... 
perhaps pushing it up the stack would make more sense?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
