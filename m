Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab2HUBmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 21:42:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36007 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab2HUBmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 21:42:23 -0400
Date: Mon, 20 Aug 2012 18:40:00 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: tony.luck@intel.com, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] pstore: add missed platform_device_unregister
Message-ID: <20120821013958.GA27381@lizard>
References: <CACV3sbKA6pjcjc+Wr-w+JNtzJfrJS=6tcMKgDzWMaZ_AV1NQ3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACV3sbKA6pjcjc+Wr-w+JNtzJfrJS=6tcMKgDzWMaZ_AV1NQ3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 02:58:26PM +0800, Jovi Zhang wrote:
> From 152373a6262045d19023cf45de84ad3c69316a45 Mon Sep 17 00:00:00 2001
> From: Jovi Zhang <bookjovi@gmail.com>
> Date: Mon, 20 Aug 2012 14:20:01 +0800
> Subject: [PATCH] pstore: add missed platform_device_unregister
> 
> we need unregister platform device when module exit, add it.
> 
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
> ---
>  fs/pstore/ram.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index 0b311bc..adb218a 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -537,6 +537,7 @@ postcore_initcall(ramoops_init);
>  static void __exit ramoops_exit(void)
>  {
>  	platform_driver_unregister(&ramoops_driver);
> +	platform_device_unregister(dummy);
>  	kfree(dummy_data);
>  }
>  module_exit(ramoops_exit);

It looks OK to me. Unless there are objections I'll apply it to
linux-pstore.git.

Thanks!
