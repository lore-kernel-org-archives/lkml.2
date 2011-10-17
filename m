Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1JQLXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:23:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44181 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab1JQLXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:23:49 -0400
MIME-Version: 1.0
In-Reply-To: <20111010100555.GA33394@0x90.at>
References: <20111010100555.GA33394@0x90.at>
Date: Mon, 17 Oct 2011 17:23:48 +0600
Message-ID: <CADZ9YHjF-xwfc7sxGz+ih-S0Xa+XNcDBx3e15=acdMyiQVm-Kw@mail.gmail.com>
Subject: Re: [PATCH][TRIVIAL] [thermal] fix unused variable warning
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Daniel Walter <d.walter@0x90.at>
Cc: rui.zhang@intel.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Mon, Oct 10, 2011 at 4:05 PM, Daniel Walter <d.walter@0x90.at> wrote:
> [thermal] fix unused variable warning
>
> thermal_event_seqnum is only used if CONFIG_NET is defined.
>
> Signed-off-by: Daniel Walter <d.walter@0x90.at>
> ---
>  drivers/thermal/thermal_sys.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> ---
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 708f8e9..def02da 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -60,7 +60,9 @@ static LIST_HEAD(thermal_tz_list);
>  static LIST_HEAD(thermal_cdev_list);
>  static DEFINE_MUTEX(thermal_list_lock);
>
> +#ifdef CONFIG_NET
>  static unsigned int thermal_event_seqnum;
> +#endif /* CONFIG_NET */
>
I think, it would be nice to move thermal_event_seqnum under
CONFIG_NET defined section, instead of wrapping with CONFIG_NET.
Although your fix is okay but moving under CONFIG_NET would be nicer.
Something like below:

---
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 708f8e9..b88c6ba 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -60,8 +60,6 @@ static LIST_HEAD(thermal_tz_list);
 static LIST_HEAD(thermal_cdev_list);
 static DEFINE_MUTEX(thermal_list_lock);

-static unsigned int thermal_event_seqnum;
-
 static int get_idr(struct idr *idr, struct mutex *lock, int *id)
 {
        int err;
@@ -1293,6 +1291,8 @@ void thermal_zone_device_unregister(struct
thermal_zone_device *tz)
 EXPORT_SYMBOL(thermal_zone_device_unregister);

 #ifdef CONFIG_NET
+static unsigned int thermal_event_seqnum;
+
 static struct genl_family thermal_event_genl_family = {
        .id = GENL_ID_GENERATE,
        .name = THERMAL_GENL_FAMILY_NAME,


Thanks,
Rakib
