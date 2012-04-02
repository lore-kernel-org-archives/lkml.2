Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab2DBQcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 12:32:12 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60696 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2DBQcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 12:32:10 -0400
Message-ID: <4F79D486.5090605@suse.cz>
Date: Mon, 02 Apr 2012 18:32:06 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120331 Thunderbird/13.0a2
MIME-Version: 1.0
To: Simon Wood <simon@mungewell.org>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>
Subject: Re: [PATCH 1/2] HID: hid-lg4ff: Use Private Data
References: <a4e40aa5c43be934d83240849aa25f3b.squirrel@mungewell.org> <1333378444-3117-1-git-send-email-simon@mungewell.org>
In-Reply-To: <1333378444-3117-1-git-send-email-simon@mungewell.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 04:54 PM, Simon Wood wrote:
> Use private data in hid-lg4ff to store device properties.
> 
> This code was writen by Michal, he asked me to check it and forward
> it on to the list.

So this patch is missing proper From: header.

> Signed-off-by: Michal Maly <madcatxster@gmail.com>
> Signed-off-by: Simon Wood <simon@mungewell.org>
> ---
>  drivers/hid/hid-lg4ff.c |   96 +++++++++++++++++++++-------------------------
>  1 files changed, 44 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
> index 1145292..c3146e0 100644
> --- a/drivers/hid/hid-lg4ff.c
> +++ b/drivers/hid/hid-lg4ff.c
> @@ -285,18 +280,20 @@ static void hid_lg4ff_switch_native(struct hid_device *hid, const struct lg4ff_n
>  /* Read current range and display it in terminal */
>  static ssize_t lg4ff_range_show(struct device *dev, struct device_attribute *attr, char *buf)
>  {
> -	struct lg4ff_device_entry *uninitialized_var(entry);
> -	struct list_head *h;
>  	struct hid_device *hid = to_hid_device(dev);
> +	struct lg4ff_device_entry *uninitialized_var(entry);
> +	struct lg_drv_data *uninitialized_var(drv_data);

You don't need uninitialized_var bloat anymroe, right?

Here and at the other places too...

>  	size_t count;
>  
> -	list_for_each(h, &device_list.list) {
> -		entry = list_entry(h, struct lg4ff_device_entry, list);
> -		if (strcmp(entry->device_id, (&hid->dev)->kobj.name) == 0)
> -			break;
> +	drv_data = hid_get_drvdata(hid);
> +	if (!drv_data) {
> +		hid_err(hid, "Private driver data not found!\n");
> +		return 0;
>  	}
> -	if (h == &device_list.list) {
> -		dbg_hid("Device not found!");
> +
> +	entry = drv_data->device_props;
> +	if (!entry) {
> +		hid_err(hid, "Device properties not found!\n");
>  		return 0;
>  	}
>  

-- 
js
suse labs

