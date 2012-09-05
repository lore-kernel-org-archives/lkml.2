Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353Ab2IEJ5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:57:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab2IEJ5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:57:44 -0400
Date: Wed, 5 Sep 2012 11:57:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Axel Lin <axel.lin@gmail.com>
Cc: Chris Schlund <chrisschlund@gmx.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hid-lcpower: Use HID_UP_LOGIVENDOR instead of hard
 coded 0x0ffbc0000
In-Reply-To: <1346811570.3994.0.camel@phoenix>
Message-ID: <alpine.LNX.2.00.1209051156560.11079@pobox.suse.cz>
References: <1346811570.3994.0.camel@phoenix>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2012, Axel Lin wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/hid/hid-lcpower.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-lcpower.c b/drivers/hid/hid-lcpower.c
> index c4fe9bd0..22bc14a 100644
> --- a/drivers/hid/hid-lcpower.c
> +++ b/drivers/hid/hid-lcpower.c
> @@ -24,7 +24,7 @@ static int ts_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  		struct hid_field *field, struct hid_usage *usage,
>  		unsigned long **bit, int *max)
>  {
> -	if ((usage->hid & HID_USAGE_PAGE) != 0x0ffbc0000)
> +	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_LOGIVENDOR)
>  		return 0;
>  
>  	switch (usage->hid & HID_USAGE) {

The name of the actual constant is quite losing its point with more and 
more non-Logitech devices using this usage page.

I am applying your patch now, but I guess we'll rather rename the define 
in a near future.

Thanks,

-- 
Jiri Kosina
SUSE Labs
