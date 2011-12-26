Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab1LZRpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 12:45:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48458 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1LZRpn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 12:45:43 -0500
MIME-Version: 1.0
In-Reply-To: <1324900599-20804-1-git-send-email-consul.kautuk@gmail.com>
References: <1324900599-20804-1-git-send-email-consul.kautuk@gmail.com>
Date: Mon, 26 Dec 2011 12:45:41 -0500
Message-ID: <CAFPAmTRJix3hYitz3V=__Wsc70px3mXUx9TXHC+QK5UYcKwxag@mail.gmail.com>
Subject: Re: [PATCH 1/1] swapfile: swap_info_get: Check for swap_info[type] == NULL
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Eric B Munson <emunson@mgebm.net>, Pekka Enberg <penberg@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry, please ignore the patch file below.

I made a mistake in understanding the code logic.
I now understand that the first "bad_nofile" validation check
is good enough for checking the validity of the value in the "type" variable.


On Mon, Dec 26, 2011 at 6:56 AM, Kautuk Consul <consul.kautuk@gmail.com> wrote:
> From: Kautuk Consul <consul.kautuk@gmail.com>
>
> If the swapfile type encoded within entry.val is corrupted in
> such a way that the swap_info[type] == NULL, then the code in
> swap_info_get will cause a NULL pointer exception.
>
> Assuming that the code in swap_info_get attempts to validate the
> swapfile type by checking its range, another bad_nofile check would
> be to check for check whether the swap_info[type] pointer is NULL.
>
> Adding a NULL check for swap_info[type] to be reagrded as a "bad_nofile"
> error scenario.
>
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
> ---
>  mm/swapfile.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index b1cd120..7bdbe91 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -483,6 +483,8 @@ static struct swap_info_struct *swap_info_get(swp_entry_t entry)
>        if (type >= nr_swapfiles)
>                goto bad_nofile;
>        p = swap_info[type];
> +       if (!p)
> +               goto bad_nofile;
>        if (!(p->flags & SWP_USED))
>                goto bad_device;
>        offset = swp_offset(entry);
> --
> 1.7.6
>
